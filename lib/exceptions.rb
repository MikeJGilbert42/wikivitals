module Exceptions
  class WikipediaArticleError < StandardError; end
  class ArticleNotFound < WikipediaArticleError; end
  class ArticleNotPerson < WikipediaArticleError; end
end
