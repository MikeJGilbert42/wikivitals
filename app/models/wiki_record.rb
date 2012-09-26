class WikiRecord < ActiveRecord::Base

  after_create :read_article, :if => :fetched?

  has_many :links
  has_many :targets, :through => :links

  def self.fetch page_name, follow_redirects = true #to become fetch_children?
    found = nil
    begin
      found = find_article page_name
      if found
        page_name = found.redirect.article_title if found.redirect
      end
    end while follow_redirects && found && found.redirect
    found
  end

  def self.find_article page_name
    record = nil
    page_name = WikiHelper::repair_link(page_name)
    record = WikiRecord.where(:article_title => page_name).first #scope this
    if record && record.fetched?
      body = record.article_body
    else
      body = WikiFetcher.get_article_body page_name
      if body.include? "may refer to"
        #TODO: Handle disambiguation pages.
        raise "You're gonna have to be more specific."
      end
      begin
        if !record
          record = WikiRecord.new
          record.article_title = page_name
        end
        record.article_body = body
        record.save!
      rescue ActiveRecord::StatementInvalid => e
        # This shouldn't happen because of the 'where' executed above, but just in case...
        return nil
      end
    end
    record
  end


  def article_body= body
    write_attribute(:article_body, body)
    read_article
  end

  def fetched?
    !!article_body
  end

  def redirect_title
    check_fetched
    @redirect_title ||= WikiHelper::repair_link((/\A\#REDIRECT\s\[\[([^\]]+)\]\]/i.match(article_body) || [])[1])
  end

  def redirect
    check_fetched
    @redirect ||= targets.first if links.count == 1
  end

  def person?
    check_fetched
    @is_person ||= has_persondata? article_body
  end

  def alive?
    check_fetched
    false if !person?
    infohash(:alive_category) || !infohash(:dead_category) || infohash(:death_date).nil?
  end

  def death_date
    check_fetched
    infohash(:death_date)
  end

  def birth_date
    check_fetched
    infohash(:birth_date)
  end

  def infohash(key)
    check_fetched
    if @infohash.nil?
      parse_info_box article_body if person?
    end
    return nil if @infohash.nil?
    instance_variable_get("@infohash")[key]
  end

  private

  def read_article
    if redirect_title
      destination = WikiRecord.find_or_create_by_article_title(redirect_title)
      targets << destination unless targets.include? destination
    else
      return if !fetched?
      parse_info_box article_body if person?
    end
    return nil
  end

  def check_fetched
    raise Exceptions::WikiRecordStateError unless fetched?
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
    !(body.index(/\{\{Persondata[^\}]*\}\}/).nil?)
  end

  def extract_infobox body
    start_index = body =~ /\{\{Infobox\s+([\w ]+)/
    return nil if !(start_index)
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
    @infohash = {}
    @infobox = extract_infobox body
    if @infobox
      @infobox =~ /\{\{Infobox\s([\w ]+)/

      data = @infobox.scan(/^\|\s?(.*)$/).flatten.map { |s| s.split(/\s*=\s*/, 2) } #[["x","y"], ["z", ""], ...]
      data.collect do |x|
        next if x[0].nil?
        @infohash[x[0].to_sym] = x[1] == "" ? nil : x[1]
      end
      # Convert Wikipedia dates to Ruby dates
      @infohash[:death_date] = parse_date_template @infohash[:death_date] if (@infohash[:death_date])
      @infohash[:birth_date] = parse_date_template @infohash[:birth_date] if (@infohash[:birth_date])
    end

    #Infer name if not present
    @infohash[:name] = article_title.gsub('_', ' ') if @infohash[:name].nil?
    #Backup means of determining liveness
    @infohash[:alive_category] = !(body.index(/Category:Living people/).nil?)
    @infohash[:dead_category] = !(body.index(/Category:\d+ deaths/).nil?)
  end
end
