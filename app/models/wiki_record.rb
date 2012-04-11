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

  def death_date
    fetch
    @death_date
  end

  def birth_date
    fetch
    @birth_date
  end

  def infobox
    @infobox
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

  def has_persondata? body
    body =~ /\{\{Persondata[^\}]*\}\}/
    !Regexp.last_match.nil?
  end

  def extract_infobox body
    start_index = body =~ /\{\{Infobox\s+([\w\s]+)/
    raise "Infobox was not found!" if !(start_index)
    @person_type = Regexp.last_match(1)
    open = 0
    end_index = 0
    body[start_index..-1].split("").each_with_index do |c, index|
      open += 1 if c == '{'
      open -= 1 if c == '}'
      if open == 0
        end_index = index + start_index
        break
      end
    end
    body[start_index..end_index]
  end

  def parse_info_box body
    #All the data extraction goes here.
    @infobox = extract_infobox body
    @infobox =~ /\{\{Infobox\s([\w ]+)/

    data = @infobox.scan(/^\|\s?(.*)$/).flatten.map { |s| s.split(/\s*=\s*/, 2) } #[["x","y"], ["z", ""], ...]
    @infohash = {}
    data.collect do |x|
      next if x[0].nil?
      @infohash[x[0].to_sym] = x[1] == "" ? nil : x[1]
    end
    if (@infohash[:death_date])
      @death_date = parse_date_template @infohash[:death_date]
    end
    if (@infohash[:birth_date])
      @birth_date = parse_date_template @infohash[:birth_date]
    end

    #Infer name if not present
    @infohash[:name] = @page_name.sub('_', ' ') if @infohash[:name].nil?
  end

  def fetch
    return if @fetched
    fetcher = WikiFetcher.new @page_name
    page = fetcher.get_page
    # Store new page name if it changed
    @page_name = fetcher.page_name
    raise "Whoops!  Something bad happened and I got no data to show for it" if page.nil?
    parse_info_box page
    @is_person = has_persondata? page
    @fetched = true
  end
end
