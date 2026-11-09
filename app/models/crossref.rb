require "net/http"

# Cliente de la API pública de Crossref (api.crossref.org). No pide key.
#
# Hoy lo usa el botón "Traer datos" del formulario de publicaciones: se pega un
# DOI y se completan título, autores, año y revista. Más adelante lo reusa la
# sincronización de BICYT para buscar el DOI de los trabajos que no lo traen
# (CLAUDE.md, "Sincronización automática").
#
#   Crossref.work("10.13156/arac.2024.19.7.973")
#   # => { title: "The identity of…", authors: "Nicoletta M., Ferretti N.",
#   #      year: 2024, journal: "Arachnology", doi: "10.13156/arac.2024.19.7.973" }
#
# Devuelve nil si el DOI no existe en Crossref. Si Crossref no responde, levanta
# Crossref::Error: quien llama decide si avisa o reintenta.
class Crossref
  class Error < StandardError; end

  BASE_URL = "https://api.crossref.org".freeze
  TIMEOUT = 8 # segundos: es un botón, alguien está esperando

  class << self
    def work(doi)
      response = get("/works/#{ERB::Util.url_encode(doi)}")
      return if response.is_a?(Net::HTTPNotFound)
      raise Error, "Crossref respondió #{response.code}" unless response.is_a?(Net::HTTPSuccess)

      parse(JSON.parse(response.body).fetch("message"))
    rescue JSON::ParserError, KeyError => error
      raise Error, "Respuesta inesperada de Crossref: #{error.message}"
    end

    private
      def get(path)
        uri = URI(BASE_URL + path)

        Net::HTTP.start(uri.host, uri.port, use_ssl: true, open_timeout: TIMEOUT, read_timeout: TIMEOUT) do |http|
          http.get(uri.request_uri, "User-Agent" => user_agent, "Accept" => "application/json")
        end
      rescue Net::OpenTimeout, Net::ReadTimeout, SocketError, SystemCallError, OpenSSL::SSL::SSLError => error
        raise Error, "No se pudo conectar con Crossref: #{error.message}"
      end

      # Crossref pide un mail de contacto en el User-Agent ("polite pool"): con
      # eso atiende más rápido y avisa ahí si algo anda mal. Va el del grupo.
      def user_agent
        mail = Rails.application.config.site[:email]
        [ "GIAS/1.0 (https://gias.com.ar", (" mailto:#{mail}" if mail), ")" ].join
      end

      def parse(message)
        {
          doi: message["DOI"],
          title: clean(Array(message["title"]).first),
          authors: authors(message["author"]),
          year: year(message),
          journal: clean(Array(message["container-title"]).first)
        }
      end

      # Algunas editoriales mandan el título con marcas (<i>, <scp>) y entidades
      # HTML. Se guarda texto plano: la itálica de los taxones la pone sci_text.
      def clean(text)
        return if text.blank?

        CGI.unescapeHTML(ActionController::Base.helpers.strip_tags(text)).squish
      end

      # "Ferretti N., Schwerdt L.", como sugiere la ayuda del formulario.
      # Los autores institucionales vienen con "name" en vez de "family".
      def authors(list)
        names = Array(list).map do |author|
          next clean(author["name"]) if author["family"].blank?

          initials = author["given"].to_s.split(/[\s.]+/).compact_blank.map { |given| "#{given[0]}." }.join
          [ clean(author["family"]), initials.presence ].compact.join(" ")
        end

        names.compact_blank.join(", ").presence
      end

      # "issued" es la primera fecha conocida (impresa u online).
      def year(message)
        %w[issued published-print published-online].each do |key|
          year = message.dig(key, "date-parts", 0, 0)
          return year if year
        end
        nil
      end
  end
end
