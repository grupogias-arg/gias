# Flechas "antes" / "después" de los listados que tienen un orden a mano
# (portada, equipo, divulgación). Intercambia el registro con su vecino. Antes
# se renumera todo, por si quedaron posiciones repetidas o salteadas.
#
#   class Admin::MembersController < Admin::BaseController
#     include Admin::Reorderable
#     reorders Member, back_to: :admin_members_path
#   end
module Admin::Reorderable
  extend ActiveSupport::Concern

  class_methods do
    def reorders(model, back_to:)
      define_method(:reorderable_model) { model }
      define_method(:reorderable_index_path) { public_send(back_to) }
    end
  end

  def move
    records = reorderable_model.ordered.to_a
    index = records.index { |record| record.id == params[:id].to_i }
    target = params[:direction] == "antes" ? index - 1 : index + 1 if index

    if index && target.between?(0, records.size - 1)
      records[index], records[target] = records[target], records[index]

      reorderable_model.transaction do
        records.each.with_index(1) { |record, position| record.update_column(:position, position) }
      end
    end

    redirect_to reorderable_index_path, status: :see_other
  end

  private
    # Lo nuevo entra al final del listado.
    def next_position
      (reorderable_model.maximum(:position) || 0) + 1
    end
end
