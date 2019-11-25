Workarea::Storefront::Engine.routes.draw do
  scope '(:locale)', constraints: Workarea::I18n.routes_constraint do
    resource :search, only: [] do
      get 'autocomplete'
    end
  end
end
