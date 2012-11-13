Wikivitals::Application.routes.draw do
  match 'people/show/:id' => 'people#show', :as => :person
  match 'search' => 'wiki_records#search'
  match 'disambiguate' => 'wiki_records#disambiguate'
  root :to => 'wiki_records#index'
end
