class SearchController < ApplicationController
  include WikiHelper

  def index
  end

  def search
    if params[:q] && !params[:q].blank?
      @article_title = repair_link params[:q]
      fetch
      if @result.disambiguation?
        redirect_to :action => :disambiguate, :page => @result.article_title
      else
        render :show
      end
    end
  end

  def show
  end

  def disambiguate
    @article_title = repair_link params[:page]
    fetch
  end

  def fetch
    @result = WikiRecord.fetch @article_title
    if @result.disambiguation?
      @people = @result.targets.map do |link|
        Person.person_for_wiki_record link rescue ArticleNotPerson
      end
    else
      @people = [] << Person.person_for_wiki_record(@result)
    end
  end
end
