Workarea::Storefront::Engine.routes.draw do
  resource :search, only: [] do
    get 'autocomplete'
  end
end
