# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = "1.0"

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path

# Leaflet se sirve aparte, no dentro del bundle `:app`: el mapa es una pieza
# de una sola página (campañas) y en celular ni siquiera se muestra
# (CLAUDE.md). La hoja se enlaza a mano desde esa vista.
Rails.application.config.assets.paths << Rails.root.join("vendor/assets/stylesheets")
