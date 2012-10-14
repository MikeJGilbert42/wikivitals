module Disambiguation
  def self.parse body
    body.scan(/\*\s*\[\[(.*?)\]\]/).flatten
  end
end
