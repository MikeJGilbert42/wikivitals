class PeopleController < ApplicationController
  include WikiHelper

  def show
    @person = Person.find(params[:id]) if @person.nil?
  end
end
