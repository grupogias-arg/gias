Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  # Panel de carga. Solo en español: lo usa el grupo, no el público.
  #
  # Ojo: Post#to_param devuelve el slug, para los permalinks públicos. En el
  # panel las rutas van por id, porque el slug se puede editar en el formulario:
  #
  #   edit_admin_post_path(post.id)   # sí
  #   edit_admin_post_path(post)      # no
  namespace :admin do
    root "posts#index"

    resource :session, only: %i[new create destroy], path: "sesion", path_names: { new: "ingresar" }
    resources :posts, path: "novedades", path_names: { new: "nueva", edit: "editar" }
    resources :cover_photos, path: "portada", only: %i[index create destroy] do
      patch :move, on: :member, path: "mover"
    end

    # El resto de las secciones: listado y formulario, sin página propia. Para
    # ver cómo queda, el listado tiene un link al sitio.
    edit_paths = { new: "nuevo", edit: "editar" }
    resources :members, path: "equipo", except: :show, path_names: edit_paths do
      patch :move, on: :member, path: "mover"
    end
    resources :publications, path: "publicaciones", except: :show, path_names: { new: "nueva", edit: "editar" }
    resources :projects, path: "proyectos", except: :show, path_names: edit_paths
    resources :campaigns, path: "campanas", except: :show, path_names: { new: "nueva", edit: "editar" }
    resources :outreach_items, path: "divulgacion", except: :show, path_names: edit_paths do
      patch :move, on: :member, path: "mover"
    end
  end

  # Bilingüe ES/EN con español por defecto (CLAUDE.md).
  #
  # El español vive en la raíz (/equipo) y el inglés bajo prefijo (/en/equipo),
  # así los links que ya se compartieron por WhatsApp siguen funcionando y la
  # URL corta es la del idioma por defecto.
  scope "(:locale)", locale: /en/ do
    root "pages#home"

    #
    # Ojo: con `(:locale)` delante, `post_path(post)` le asigna el post al
    # segmento :locale y falla. El slug va siempre con nombre:
    #
    #   post_path(slug: post)   # sí
    #   post_path(post)         # no
    #
    resources :novedades, only: %i[index show], controller: "posts", param: :slug, as: :posts
    get "equipo",       to: "members#index",       as: :members
    get "publicaciones", to: "publications#index",  as: :publications
    get "proyectos",    to: "projects#index",      as: :projects
    get "campanas",     to: "campaigns#index",     as: :campaigns
    get "divulgacion",  to: "outreach_items#index", as: :outreach_items
    get "contacto",     to: "pages#contact",       as: :contact
  end
end
