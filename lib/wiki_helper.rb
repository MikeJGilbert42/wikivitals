module WikiHelper
  # Repair common mistakes found in case and formatting.
  def self.repair_link link
    # Capitalize all words except of, the, and, excluding words inside parentheses
    link =~ /([^\(]*)(\([^\)]*\))?/
    name, parenthetical = Regexp.last_match[1..2]
    name = name.titlecase.gsub(/The|And|Of/) { |s| s.downcase }
    name.concat(parenthetical || "").gsub(" ", "_")
  end
end
