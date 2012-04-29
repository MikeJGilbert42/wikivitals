module WikiHelper
  # Typos have been encountered from time to time.
  def self.repair_link link
    link.titlecase.gsub(" ", "_").gsub(/The|And|Of/) { |s| s.downcase }
  end
end
