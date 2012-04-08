class PeopleController < ApplicationController
  def index
    @fields = Person.get_fields
    @people = Person.all :select => @fields
  end
end
