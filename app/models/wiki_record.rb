class WikiRecord < ActiveRecord::Base
  include ActionView::Helpers::TextHelper
  include WikiHelper

  has_many :links
  has_many :targets, :through => :links

  # Retrieve article based on query string, traversing redirects unless specified.
  def self.fetch page_name, options = {}
    options = { :follow_redirects => true }.merge options
    found = nil
    begin
      found = find_article page_name
      if found
        page_name = found.redirect.article_title if found.redirect
      end
    end while options[:follow_redirects] && found && found.redirect
    found
  end

  # Find article in database and populate article body with Wikipedia content if needed.
  def self.find_article page_name
    record = nil
    page_name = repair_link(page_name)
    record = WikiRecord.where(:article_title => page_name).first
    unless record
      body = WikiFetcher.get_article_body page_name
      record = WikiRecord.new :article_title => page_name, :article_body => body
      record.save!
    end
    record
  end

  def redirect
    return @redirect if @redirect
    ensure_read
    @redirect = targets.first if links.count == 1
  end

  def person?
    return @is_person if !@is_person.nil?
    ensure_read
    @is_person = has_persondata? article_body
  end

  def alive?
    ensure_read
    return false if !person?
    categories_suggest_alive = infohash(:alive_category) || !infohash(:dead_category)
    # Death date = certainty
    infohash(:death_date).nil? && categories_suggest_alive
  end

  def death_date
    ensure_read
    infohash(:death_date)
  end

  def birth_date
    ensure_read
    infohash(:birth_date)
  end

  def infohash(key)
    ensure_read
    return nil if @infohash.nil?
    instance_variable_get("@infohash")[key]
  end

  def to_s
    string = "WikiRecord [[#{article_title}]]"
    string += " Name: #{@infohash[:name]} " if @infohash && @infohash[:name]
    string += " Links: [" + truncate(targets.pluck(:article_title).join(', '), :length => 100) + "]" unless targets.empty?
    string += " Body: #{truncate(article_body, :length => 100)}"
  end

  private

  def read_article
    if redirect?
      @infohash = {}
      return if targets.map(&:article_title).include? redirect_title
      destination = WikiRecord.find_article redirect_title # Recursive call!  I hope this doesn't come back to bite me ...
      @infohash[:redirect] = redirect_title
      targets << destination
    elsif disambiguation?
      @infohash = {}
      @infohash[:disambiguation] = true # placeholder
      link_titles = disambiguation_links_from_body
      link_titles.each do |title|
        article = WikiRecord.fetch title
        targets << article if article.person?
      end
    else
      @infohash = {}
      parse_info_box article_body
      parse_persondata article_body
    end
  end

  def ensure_read
    read_article if !@infohash
  end

  def redirect?
    redirect_title != nil
  end

  def disambiguation?
    return @is_disambiguation if !@disambiguation.nil?
    @is_disambiguation = article_body =~ /may refer to/i
  end

  def redirect_title
    @redirect_title ||= repair_link((/\A\#REDIRECT\s\[\[([^\]]+)\]\]/i.match(article_body) || [])[1])
  end

  def make_date_from_year year
    #return Date.parse "1/1/" + year.gsub(/\d+/, "%04d" % $&.to_i) # this is broken right now in Rails, so do below instead
    numeric = year.to_i
    return Date.parse "1/1/" + year.gsub(/\d+/, "%04d" % numeric)
  end

  def parse_date_template input
    # Process * Date [And Age] template
    input =~ /\{\{.*?date(?: and age)?.*?\|(\d+)\|(\d+)\|(\d+).*\}\}/i
    return Date.parse Regexp.last_match[1..3].reverse.join("-") if Regexp.last_match && Regexp.last_match.length >= 3

    # Process * Year [And Age] template
    if input =~ /\{\{.*?year(?: and age)?\|(\d+\s?(B\.?C)?).*?\}\}/i
      return make_date_from_year "#{Regexp.last_match[1]} #{Regexp.last_match[2]}"
    end

    # Check to see if it parses as a plain text date (see Alexander Hamilton)
    return Date.parse input.gsub(/\([^\)]*\)/, "") rescue ArgumentError

    # If nothing else worked, maybe it contains a plain text year.
    if input =~ /\d+\s?(B\.?C)?/i
      return make_date_from_year Regexp.last_match[0]
    end

    return nil
  end

  def has_persondata? body
    !(body.index(/\{\{Persondata[^\}]*\}\}/).nil?)
  end

  def extract_template name, body
    start_index = body =~ /\{\{#{name}/
    return nil if !(start_index)
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

  def extract_infobox body
    extract_template "Infobox", body
  end

  def extract_persondata body
    extract_template "Persondata", body
  end

  def parse_info_box body
    @infohash = {}
    @infobox = extract_infobox body
    return unless @infobox
    @infobox =~ /\{\{Infobox\s+([\w ]+)/
    @person_type = Regexp.last_match(1)
    if @infobox
      data = @infobox.scan(/^\|\s?(.*)$/).flatten.map { |s| s.split(/\s*=\s*/, 2) } #[["x","y"], ["z", ""], ...]
      @infohash = data.inject({}) do |hash, e|
        hash[e.first.to_sym] = e.last == "" ? nil : e.last unless e.empty? || e.first.nil?
        hash
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

  def parse_persondata body
    # Fill in blanks with this alternate, less-reliable info
    @persondata = extract_persondata body
    return unless @persondata
    @infohash[:birth_date] = parse_date_template Regexp.last_match[1] if !@infohash[:birth_date] && @persondata =~ /DATE OF BIRTH\s*=\s*(\d+\sBC)/i
    @infohash[:death_date] = parse_date_template Regexp.last_match[1] if !@infohash[:death_date] && @persondata =~ /DATE OF DEATH\s*=\s*(\d+\sBC)/i
  end

  def disambiguation_links_from_body
    article_body.scan(/\*\s*\[\[(.*?)\]\]/).flatten.map { |b| repair_link b }
  end
end
