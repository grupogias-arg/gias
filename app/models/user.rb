# Quien carga contenido desde /admin (Fiorela y el grupo).
#
# No hay registro público ni "olvidé mi contraseña": no hay proveedor de mails
# configurado (el envío de mails quedó para la etapa 2). Los usuarios se crean
# y las contraseñas se cambian con `bin/rails admin:usuario` (lib/tasks/admin.rake).
class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  validates :name, presence: true
  validates :email_address, presence: true, uniqueness: true
  validates :password, length: { minimum: 10 }, allow_nil: true
end
