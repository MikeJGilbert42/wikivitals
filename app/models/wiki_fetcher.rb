class WikiFetcher
  include WikiHelper
  require 'net/http'

  def self.get page_name, follow_redirects = true
    found = nil
    begin
      source_page = found
      found = find_article page_name
      if found
        # Set up the permanent redirect here
        source_page.update_attributes(:redirect => found) if source_page
        page_name = found.redirect_title if found.redirect_title
      end
    end while follow_redirects && found && found.redirect_title
    found
  end

  private

  def self.find_article page_name
    record = nil
    page_name = WikiHelper::repair_link(page_name)
    if (record = WikiRecord.where(:article_title => page_name).first)
      # Follow permanent redirects
      record = record.redirect while record.fetched? && record.redirect
    end
    if record && record.fetched?
      body = record.article_body
    else
      body = get_article_body page_name
      if body.include? "may refer to"
        #TODO: Handle disambiguation pages.
        raise "You're gonna have to be more specific."
      end
      begin
        record = WikiRecord.new if !record
        record.article_title = page_name
        record.article_body = body
        record.save!
      rescue ActiveRecord::StatementInvalid => e
        # This shouldn't happen because of the 'where' executed above, but just in case...
        return nil
      end
    end
    record
  end

  def self.get_article_body page_name
    uri = URI.parse('http://en.wikipedia.org/w/index.php')
    params = { 'action' => 'raw', 'title' => "#{page_name}" }
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Get.new uri.path
    request.set_form_data params
    request = Net::HTTP::Get.new uri.path + '?' + request.body
    response = http.request request
    #puts response
    raise Exceptions::ArticleNotFound.new "Article #{page_name} not found" if response.code == "404"
    response.body.force_encoding('utf-8')
  end
end
