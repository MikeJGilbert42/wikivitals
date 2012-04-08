class WikiRecord

  require 'net/http'

  def initialize(page_name)
    @page_name = page_name
    @response = nil
    @infobox = nil
    @is_person = false
  end

  def person?
    fetch
    @is_person
  end

  def alive?
    fetch
    @death_date.nil?
  end

  def infobox
    fetch
    @infobox
  end

  def death_date
    fetch
    @death_date
  end

  def [](key)
    fetch
    instance_variable_get("@infohash")[key]
  end

  def parse_date_template input
    input =~ /\{\{(?:.*\|)(\d+)\|(\d+)\|(\d+)\|(:?(\d+)\|(\d+)\|(\d+))?\}\}/
    Date.parse Regexp.last_match[1..3].reverse.join("-")
  end

  def parse_info_box(body)
    #All the data extraction goes here.
    body =~ /(\{\{Infobox\s(\S+)\n(?:|.*\n)*\}\})/
    @infobox = Regexp.last_match 1
    @is_person = Regexp.last_match(2) == "person"
    puts "That's not a person, dumbass." if !@is_person

    data = @infobox.scan(/\|\s*(\S+)\s*=\s*(.*)\n/) #results in [["key","value"], ["key", "value"]...]
    @infohash = {}
    data.collect { |x| @infohash[x[0]] = x[1] }
    #TODO: parse death date ex. "{{death date and age|1996|3|9|1896|1|20}}<br>({{age in years and days|1896|1|20|1996|3|9}})"
    if (@infohash["death_date"])
      @death_date = parse_date_template @infohash["death_date"]
    end
    if (@infohash["birth_date"])
      @birth_date = parse_date_template @infohash["birth_date"]
    end
  end

  def fetch
    if @response.nil?
      uri = URI.parse('http://en.wikipedia.org/w/index.php')
      params = { 'action' => 'raw', 'title' => "#{@page_name}" }
      http = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP::Get.new uri.path
      request.set_form_data params
      request = Net::HTTP::Get.new uri.path + '?' + request.body
      @response = http.request request
      #puts @response
      raise "Y U NO GIVE GOOD QUERY: #{@response.code}" if @response.code != "200"
    end

    parse_info_box @response.body
  end
end
