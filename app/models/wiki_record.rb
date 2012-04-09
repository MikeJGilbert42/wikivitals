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

  #debug accessor
  def infobox
    @infobox
  end

  #debug accessor
  def infohash
    @infohash
  end

  #debug accessor
  def response
    @response
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
    # All we care about is the first three decimals in succession
    input =~ /\{\{.*?(\d+)\|(\d+)\|(\d+).*}\}/
    Date.parse Regexp.last_match[1..3].reverse.join("-")
  end

  def parse_info_box(body)
    #All the data extraction goes here.
    body =~ /(\{\{Infobox\s(\S+)\n(?:|.*\n)*\}\})/
    @infobox = Regexp.last_match 1
    @is_person = Regexp.last_match(2) == "person"
    puts "That's not a person, dumbass." if !@is_person

    data = @infobox.scan(/^\|\s(.*)$/).flatten.map { |s| s.split(/\s*=\s*/, 2) } #[["x","y"], ["z", ""], ...]
    @infohash = {}
    data.collect { |x| @infohash[x[0]] = x[1] == "" ? nil : x[1] }
    #TODO: parse death date ex. "{{death date and age|1996|3|9|1896|1|20}}<br>({{age in years and days|1896|1|20|1996|3|9}})"
    if (@infohash["death_date"])
      @death_date = parse_date_template @infohash["death_date"]
    end
    if (@infohash["birth_date"])
      @birth_date = parse_date_template @infohash["birth_date"]
    end
  end

  def fetch
    while @response.nil?
      uri = URI.parse('http://en.wikipedia.org/w/index.php')
      params = { 'action' => 'raw', 'title' => "#{@page_name}" }
      http = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP::Get.new uri.path
      request.set_form_data params
      request = Net::HTTP::Get.new uri.path + '?' + request.body
      @response = http.request request
      #puts @response
      raise "Y U NO GIVE GOOD QUERY: #{@response.code}" if @response.code != "200"

      if @response.body =~ /\A\#REDIRECT\s\[\[(\S+)\]\]/
        @page_name = Regexp.last_match[1]
        puts "You must be new here.  Redirecting to \"#{@page_name}\""
        @response = nil
      end
      if @response.body.include? "may refer to"
        #TODO: Handle disambiguation pages.
        raise "You're gonna have to be more specific."
      end
    end
    parse_info_box @response.body
  end
end
