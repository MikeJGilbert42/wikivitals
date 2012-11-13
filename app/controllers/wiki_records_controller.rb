class WikiRecordsController < ApplicationController
  include WikiHelper

  def search
    if params[:q] && !params[:q].blank?
      @article_title = repair_link params[:q]
      fetch
      if @result.disambiguation?
        redirect_to :action => :disambiguate, :page => @result.article_title
      else
        redirect_to person_path Person.person_for_wiki_record(@result).id
      end
    end
  end

  def disambiguate
    @article_title = repair_link params[:page]
    fetch
  end

  def fetch
    @result = WikiRecord.fetch @article_title
  end
end
