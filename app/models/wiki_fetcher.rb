class WikiFetcher

  require 'net/http'

  def self.get page_name
    find_article page_name
  end

  private

  def self.find_article(page_name, follow_redirects = true)
    begin
      # Why doesn't this have access to application helper's function?
      body = get_article_body repair_link(page_name)
      redirect_to = nil
      if body =~ /\A\#REDIRECT\s\[\[([^\]]+)\]\]/
        redirect_to = Regexp.last_match[1]
      elsif body.include? "may refer to"
        #TODO: Handle disambiguation pages.
        raise "You're gonna have to be more specific."
      end
      page_name = redirect_to if redirect_to && follow_redirects
    end while redirect_to && follow_redirects
    WikiRecord.new page_name, body
  end

  def self.get_article_body page_name
    uri = URI.parse('http://en.wikipedia.org/w/index.php')
    params = { 'action' => 'raw', 'title' => "#{wiki_url}" }
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Get.new uri.path
    request.set_form_data params
    request = Net::HTTP::Get.new uri.path + '?' + request.body
    response = http.request request
    #puts response
    raise "Y U NO GIVE GOOD QUERY: #{response.code}" if response.code != "200"
    response.body
  end

  # Typos have been encountered from time to time.
  def self.repair_link link
    link.titlecase.gsub(" ", "_").gsub(/The|And|Of/) { |s| s.downcase }
  end

end
