class AddYearsAndEstimatedCoordsToCampaigns < ActiveRecord::Migration[8.1]
  def change
    # Las campañas del grupo vienen fechadas por año, y varias abarcan un rango
    # ("2013-2015"). Una `date` no puede expresar eso sin inventar un día, así
    # que se usan años como en Project, que ya resuelve lo mismo. `date` queda
    # para las pocas campañas con fecha exacta conocida.
    add_column :campaigns, :year_start, :integer
    add_column :campaigns, :year_end, :integer

    # Las coordenadas cargadas a partir de la localidad son aproximadas: el
    # grupo todavía no pasó las reales. El sitio tiene que poder decirlo en vez
    # de mostrar un punto como si fuera exacto.
    add_column :campaigns, :coords_estimated, :boolean, null: false, default: false

    add_index :campaigns, :year_start
  end
end
