module ApplicationHelper
  # Typos have been encountered from time to time.
  def repair_link link
    link.titlecase.gsub(" ", "_").gsub(/The|And|Of/) { |s| s.downcase }
  end
end
