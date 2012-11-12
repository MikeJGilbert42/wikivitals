module Exceptions
  class WikipediaArticleError < StandardError
    def initialize message = "There was a problem with the article"
      @message = message
    end

    def message
      @message
    end
  end

  class ArticleNotFound < WikipediaArticleError
    def initialize(message = "Article not found")
      @message = message
    end

    def message
      @message
    end
  end

  class ArticleNotPerson < WikipediaArticleError
    def initialize(message = "Article is not of a person")
      @message = message
    end

    def message
      @message
    end
  end

  class WikiRecordStateError < StandardError
    def initialize message = "Operation not possible before fetching article"
      @message = message
    end

    def message
      @message
    end
  end
end
