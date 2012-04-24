class WikiRecord

  def initialize(page_name, body)
    @page_name = page_name
    raise "Missing page body" if body.nil?
    parse_info_box body
    @is_person = has_persondata? body
  end

  def person?
    @is_person
  end

  def alive?
    @death_date.nil?
  end

  def death_date
    @death_date
  end

  def birth_date
    @birth_date
  end

  def article_title
    @page_name
  end

  def [](key)
    instance_variable_get("@infohash")[key]
  end

  def parse_date_template input
    # All we care about is the first three integers in succession, delimited by pipes
    input =~ /\{\{.*?(\d+)\|(\d+)\|(\d+).*}\}/
    if Regexp.last_match.nil? || Regexp.last_match.length < 3
      # Check for a plain text date (see Alexander Hamilton)
      Date.parse input.gsub(/\([^\)]*\)/, "")
    else
      Date.parse Regexp.last_match[1..3].reverse.join("-")
    end
  end

  def has_persondata? body
    body =~ /\{\{Persondata[^\}]*\}\}/
    !Regexp.last_match.nil?
  end

  def extract_infobox body
    start_index = body =~ /\{\{Infobox\s+([\w ]+)/
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
    @infohash[:name] = @page_name.gsub('_', ' ') if @infohash[:name].nil?
  end
end
