module ApplicationHelper
  # Typos have been encountered from time to time.
  def repair_link link
    link.titlecase.sub(" ", "_")
  end
end
