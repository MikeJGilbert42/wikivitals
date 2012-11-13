module WikiHelper
  extend ActiveSupport::Concern
  module ClassMethods
    # Repair common mistakes found in case and formatting.
    def repair_link link
      return nil if link.nil?
      # Capitalize all words except of, the, and, excluding words inside parentheses
      link.gsub!("_", " ")
      link =~ /([^\(]*)(\([^\)]*\))?/
      name, parenthetical = Regexp.last_match[1..2]
      name.gsub!(/\w+/) { |s| s[0] = s[0].upcase; s }
      name.gsub!(/The|And|Of/) { $&.downcase }
      name.concat(parenthetical || "").gsub(" ", "_")
    end

    def humanize_article_title link
      link.humanze
    end
  end

  def repair_link link
    self.class.repair_link link
  end

  def humanize_article_title link
    self.class.humanize_article_title link
  end
end
