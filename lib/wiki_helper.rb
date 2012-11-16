module WikiHelper
  include ActiveSupport::Inflector
  extend ActiveSupport::Concern
  module ClassMethods
    # Repair common mistakes found in case and formatting.
    def repair_link link
      return nil if link.nil?
      link = fix_case link.gsub("_", " ")
      link.gsub(" ", "_")
    end

    def humanize_article_title link
      fix_case link.gsub("_", " ")
    end

    private

    def fix_case link
      # Capitalize all words except of, the, and, excluding words inside parentheses
      link =~ /([^\(]*)(\([^\)]*\))?/
      name, parenthetical = Regexp.last_match[1..2]
      name.gsub!(/\w+/) { |s| s[0] = s[0].upcase; s }
      name.gsub!(/The|And|Of/) { $&.downcase }
      name.concat(parenthetical || "")
    end
  end

  def repair_link link
    self.class.repair_link link
  end

  def humanize_article_title link
    self.class.humanize_article_title link
  end
end
