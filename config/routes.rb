Wikivitals::Application.routes.draw do
  match 'search' => 'wiki_records#search'
  match 'show/:article_title' => 'wiki_records#show', :as => :wiki_record
  match 'details' => 'wiki_records#details'
  match 'disambiguate' => 'wiki_records#disambiguate'
  match 'page_views/:action' => 'page_views'
  root :to => 'wiki_records#index'
end
