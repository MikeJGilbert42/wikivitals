class PeopleController < ApplicationController
  def index
    @fields = Person.get_fields
    @people = Person.all :select => @fields
  end

  def search
    if params[:q]
      article_name = WikiFetcher.repair_link params[:q]
      @person = Person.get_person article_name
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
end
