class ModifyPeopleToOneName < ActiveRecord::Migration
  def self.up
    add_column :people, :name, :string
    Person.reset_column_information
    Person.all.each do |person|
      person.name = person.first_name + " " + person.last_name
      person.save!
    end
    remove_column :people, :first_name
    remove_column :people, :last_name
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
    #remove_column :people, :name
  end
end
