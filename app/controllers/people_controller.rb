class PeopleController < ApplicationController
  rescue_from ArticleNotFound, :with => :render_article_not_found
  rescue_from ArticleNotPerson, :with => :render_not_person

  def index
    @fields = Person.get_fields
    @people = Person.all :select => @fields
  end

  def search
    if params[:q]
      article_name = WikiFetcher.repair_link params[:q]
      @person = Person.find_person article_name
      render :show
      return
    end
  end

  def show
    @person = Person.find(params[:id]) if @person.nil?
  end

  def disambiguate
    #TODO: The user will need to choose between various Person results here.
  end

  private

  def render_article_not_found(exception)
    @error_message = exception.message
    respond_to do |format|
      format.html { render 'people/article_not_found' }
      format.all { render nothing: true }
    end
  end

  def render_not_person(exception)
    @error_message = exception.message
    respond_to do |format|
      format.html { render 'people/not_person' }
      format.all { render nothing: true }
    end
  end

end
