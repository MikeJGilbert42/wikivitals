class WikiRecordsController < ApplicationController
  include WikiHelper

  rescue_from ArticleNotFound, :with => :render_article_not_found
  rescue_from ArticleNotPerson, :with => :render_not_person

  def search
    if params[:q] && !params[:q].blank?
      @article_title = repair_link params[:q]
      fetch
      if @result.disambiguation?
        redirect_to :action => :disambiguate, :page => @result.article_title
      else
        @person = Person.person_for_wiki_record @result
        render :show
      end
    end
  end

  def show
    @article_title = params[:article_title]
    fetch
    @person = Person.person_for_wiki_record @result
  end

  def details
    @article_title = params[:article_title]
    fetch
    render :partial => 'details'
  end

  def disambiguate
    @article_title = params[:page]
    fetch
  end

  private

  def fetch
    @result = WikiRecord.fetch @article_title
  end

  def render_article_not_found(exception)
    @error_message = exception.message
    render 'article_not_found'
  end

  def render_not_person(exception)
    @error_message = exception.message
    render 'not_person'
  end
end
