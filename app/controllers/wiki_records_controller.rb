class WikiRecordsController < ApplicationController
  include WikiHelper

  rescue_from ArticleNotFound, :with => :render_article_not_found
  rescue_from ArticleNotPerson, :with => :render_not_person

  def search
    if params[:q] && !params[:q].blank?
      fetch repair_link params[:q]
      if @result.disambiguation?
        @user.add_page_view @result
        redirect_to :action => :disambiguate, :page => @result.article_title
      else
        @person = Person.person_for_wiki_record @result
        @user.add_page_view @result
        render :show
      end
    end
  end

  def show
    fetch params[:article_title]
    @person = Person.person_for_wiki_record @result
  end

  def details
    fetch params[:article_title]
    render :partial => 'details'
  end

  def disambiguate
    fetch params[:page]
    @links = @result.person_targets
  end

  private

  def fetch article_title
    @result = WikiRecord.fetch article_title
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
