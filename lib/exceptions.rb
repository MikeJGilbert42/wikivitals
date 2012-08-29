module Exceptions
  class WikipediaArticleError < StandardError
    def message
      "There was a problem with the article."
    end
  end

  class ArticleNotFound < WikipediaArticleError
    def message
      "Article not found."
    end
  end

  class ArticleNotPerson < WikipediaArticleError
    def message
      "Article is not of a person."
    end
  end

  class WikiRecordStateError < StandardError
    def message
      "Operation not possible before fetching article."
    end
  end
end
