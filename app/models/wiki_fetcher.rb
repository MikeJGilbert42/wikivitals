class WikiFetcher

  require 'net/http'

  def initialize(page_name)
    @page_name = page_name
  end

  def get_page(follow_redirects = true)
    begin
      body = wiki_fetch @page_name
      redirect_to = nil
      if body =~ /\A\#REDIRECT\s\[\[([^\]]+)\]\]/
        redirect_to = repair_link(Regexp.last_match[1])
      elsif body.include? "may refer to"
        #TODO: Handle disambiguation pages.
        raise "You're gonna have to be more specific."
      end
      @page_name = redirect_to if redirect_to && follow_redirects
    end while redirect_to && follow_redirects
    body
  end

  # For retrieving final article name after redirects, etc.
  def page_name
    return @page_name
  end

  private

  def wiki_fetch wiki_url
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
  def repair_link link
    link.sub(" ", "_")
  end
end
