class WikiRecordsController < ApplicationController
  include WikiHelper

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

  def disambiguate
    @article_title = repair_link params[:page]
    fetch
  end

  def fetch
    @result = WikiRecord.fetch @article_title
  end
end
