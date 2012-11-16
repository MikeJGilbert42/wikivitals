class PeopleController < ApplicationController
  include WikiHelper

  rescue_from ArticleNotFound, :with => :render_article_not_found
  rescue_from ArticleNotPerson, :with => :render_not_person

  def search
    if params[:q] && !params[:q].blank?
      article_name = WikiHelper::repair_link params[:q]
      @person = Person.find_person article_name
      render :show
      return
    end
  end

  def show
    @person = Person.find(params[:id]) if @person.nil?
  end

  private

  def render_article_not_found(exception)
    @error_message = exception.message
    respond_to do |format|
      format.html { render 'article_not_found' }
      format.all { render nothing: true }
    end
  end

  def render_not_person(exception)
    @error_message = exception.message
    respond_to do |format|
      format.html { render 'not_person' }
      format.all { render nothing: true }
    end
  end

end
