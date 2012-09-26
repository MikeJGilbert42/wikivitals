class WikiFetcher
  include WikiHelper
  require 'net/http'

  #todo: keep a session alive for fetching multiple requests
  def self.get_article_body page_name
    uri = URI.parse('http://en.wikipedia.org/w/index.php')
    params = { 'action' => 'raw', 'title' => "#{page_name}" }
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Get.new uri.path
    request.set_form_data params
    request = Net::HTTP::Get.new uri.path + '?' + request.body
    response = http.request request
    raise Exceptions::ArticleNotFound.new "Article #{page_name} not found" if response.code == "404"
    response.body.force_encoding('utf-8')
  end
end
