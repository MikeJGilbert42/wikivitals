require 'exceptions'

def mock_get_article_body page_name
  file_name = "#{page_name}.raw"
  body = nil
  begin
    file = File.open Rails.root.join("test_data", "#{file_name}")
  rescue Exception => e
    raise Exceptions::ArticleNotFound.new "Problem opening test data file #{file_name}"
  end

  begin
    body = IO.read file
  rescue Exception => e
    raise Exceptions::ArticleNotFound.new "Problem reading test data file #{file_name}"
  end
  body
end

def mock_wiki_fetcher
  WikiFetcher.class_eval do
    def self.get_article_body(page_name)
      mock_get_article_body(page_name)
    end
  end
end

def create_current_user
  user = FactoryGirl.create(:user)
  cookies.signed[:user_id] = user.id
end
