class SearchController < ApplicationController
  include WikiHelper

  def index
    render :index
  end

  def search
    if params[:q] && !params[:q].blank?
      article_name = repair_link params[:q]
      @result = WikiRecord.fetch article_name
      if @result.disambiguation?
        redirect_to :action => :disambiguate, :record => @result
      else
        @person = Person.new_from_wiki_record @result
        render :show
      end
    end
  end

  def show
    @person = Person.new_from_wiki_record @result
  end

  def disambiguate
    @result = WikiRecord.find params[:record]
    @people = @result.targets.map do |link|
      Person.new_from_wiki_record link
    end
  end
end
