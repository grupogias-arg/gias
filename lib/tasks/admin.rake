require "io/console"

namespace :admin do
  # Crea un usuario del panel, o le cambia la contraseña si ya existe.
  #
  # No hay "olvidé mi contraseña" por mail (no hay proveedor de mails hasta la
  # etapa 2), así que este es el camino para las dos cosas:
  #
  #   bin/rails admin:usuario                                   # local
  #   bin/kamal app exec -i --reuse "bin/rails admin:usuario"   # producción
  #
  # La contraseña se pide por teclado y no queda en el historial de la terminal.
  desc "Crea un usuario del panel o le cambia la contraseña"
  task usuario: :environment do
    print "Correo electrónico: "
    email = $stdin.gets.to_s.strip
    abort "Falta el correo." if email.empty?

    user = User.find_or_initialize_by(email_address: email)

    if user.new_record?
      print "Nombre (para el saludo del panel): "
      user.name = $stdin.gets.to_s.strip
    else
      puts "Ya existe #{user.name} <#{user.email_address}>: se le cambia la contraseña."
    end

    password = $stdin.getpass("Contraseña (10 caracteres o más): ")
    confirmation = $stdin.getpass("Repetila: ")
    abort "Las contraseñas no coinciden." unless password == confirmation

    user.password = password

    if user.save
      # Cambiar la contraseña cierra las sesiones abiertas en otros equipos.
      user.sessions.destroy_all unless user.previously_new_record?
      puts user.previously_new_record? ? "Listo: se creó el usuario." : "Listo: contraseña cambiada."
    else
      abort user.errors.full_messages.to_sentence
    end
  end
end

namespace :admin do
  # Completa la `url` de las fotos embebidas en textos de Action Text que no la
  # tienen. Sin ella, el editor del panel muestra la foto como un recuadro
  # vacío (el sitio público no la usa, así que ahí se ven bien).
  #
  # Les pasaba a las novedades cargadas por db/seeds/posts.rb antes de que el
  # seed agregara la url. Lo que se sube desde el editor ya la trae. Se puede
  # correr más de una vez: lo que ya tiene url no se toca.
  #
  #   bin/rails admin:completar_urls_de_fotos
  #   bin/kamal app exec --reuse "bin/rails admin:completar_urls_de_fotos"
  desc "Completa la url de las fotos embebidas que no la tienen, para que se vean en el editor"
  task completar_urls_de_fotos: :environment do
    helpers = Rails.application.routes.url_helpers
    total = 0

    ActionText::RichText.find_each do |rich_text|
      fragment = Nokogiri::HTML5.fragment(rich_text.body.to_html)
      changed = 0

      fragment.css("action-text-attachment:not([url])").each do |node|
        blob = GlobalID::Locator.locate_signed(node["sgid"], for: "attachable")
        next unless blob.is_a?(ActiveStorage::Blob)

        node["url"] = helpers.rails_blob_path(blob, only_path: true)
        changed += 1
      end

      next if changed.zero?

      rich_text.update!(body: fragment.to_html)
      total += changed
      puts "#{rich_text.record_type} ##{rich_text.record_id} (#{rich_text.name}): #{changed} foto(s)"
    end

    puts total.zero? ? "Nada para completar." : "Listo: #{total} foto(s) con url."
  end
end
