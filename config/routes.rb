Wikivitals::Application.routes.draw do
  match 'people/show/:id' => 'people#show'
  match 'search' => 'search#search'
  match 'disambiguate' => 'search#disambiguate'
  root :to => 'search#index'
end
