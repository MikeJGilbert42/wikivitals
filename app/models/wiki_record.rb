class WikiRecord

  def initialize(page_name)
    @page_name = page_name
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

  def death_date
    fetch
    @death_date
  end

  def birth_date
    fetch
    @birth_date
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
    @is_person = Regexp.last_match(2) == "person" #TODO: this does not work for specific person types!

    data = @infobox.scan(/^\|\s(.*)$/).flatten.map { |s| s.split(/\s*=\s*/, 2) } #[["x","y"], ["z", ""], ...]
    @infohash = {}
    data.collect { |x| @infohash[x[0]] = x[1] == "" ? nil : x[1] }
    if (@infohash["death_date"])
      @death_date = parse_date_template @infohash["death_date"]
    end
    if (@infohash["birth_date"])
      @birth_date = parse_date_template @infohash["birth_date"]
    end

    #Infer name if not present
    @infohash["name"] = @page_name.sub('_', ' ') if @infohash["name"].nil?
  end

  def fetch
    fetcher = WikiFetcher.new @page_name
    @page = fetcher.get_page
    # Store new page name if it changed
    @page_name = fetcher.page_name
    parse_info_box @page
  end
end
