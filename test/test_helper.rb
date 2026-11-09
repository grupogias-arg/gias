ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    parallelize(workers: :number_of_processors)

    # Reemplaza un método de clase mientras corre el bloque. Minitest 6 ya no
    # trae `stub`, y alcanza con esto para no salir a internet (Crossref).
    def stubbing(object, method_name, implementation)
      original = object.method(method_name)
      object.define_singleton_method(method_name, &implementation)
      yield
    ensure
      object.define_singleton_method(method_name, original)
    end
  end
end

class ActionDispatch::IntegrationTest
  def sign_in
    User.create!(name: "Prueba", email_address: "prueba@example.com", password: "secreto-123")
    post admin_session_path, params: { email_address: "prueba@example.com", password: "secreto-123" }
  end
end
