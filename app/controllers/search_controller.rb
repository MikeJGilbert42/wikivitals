class SearchController < ApplicationController
  include WikiHelper

  before_filter :fetch, :except => [:search]

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
  end

  def fetch
    @result = WikiRecord.fetch @article_title
    if @result.disambiguation?
      @people = @result.targets.map do |link|
        Person.get_person_for_wiki_record link
      end
    else
      @people = [] << Person.get_person_for_wiki_record(@result)
    end
  end
end
