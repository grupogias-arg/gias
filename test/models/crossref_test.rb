require "test_helper"

# El armado de los datos a partir de la respuesta de Crossref, sin salir a
# internet. La forma de la respuesta es la de api.crossref.org/works/<doi>.
class CrossrefTest < ActiveSupport::TestCase
  test "arma título, autores, año y revista" do
    work = parse(
      "DOI" => "10.13156/arac.2024.19.7.973",
      "title" => [ "The identity of <i>Heterothele caudicula</i> (Araneae: Theraphosidae) from Argentina" ],
      "author" => [ { "given" => "Micaela", "family" => "Nicoletta" }, { "given" => "Nelson E.", "family" => "Ferretti" } ],
      "container-title" => [ "Arachnology" ],
      "issued" => { "date-parts" => [ [ 2024, 3, 8 ] ] }
    )

    assert_equal "The identity of Heterothele caudicula (Araneae: Theraphosidae) from Argentina", work[:title]
    assert_equal "Nicoletta M., Ferretti N.E.", work[:authors]
    assert_equal 2024, work[:year]
    assert_equal "Arachnology", work[:journal]
  end

  test "autores institucionales y datos que faltan" do
    work = parse("DOI" => "10.1/x", "author" => [ { "name" => "Grupo &amp; Cía" } ], "published-online" => { "date-parts" => [ [ 2019 ] ] })

    assert_equal "Grupo & Cía", work[:authors]
    assert_equal 2019, work[:year]
    assert_nil work[:title]
    assert_nil work[:journal]
  end

  private
    def parse(message) = Crossref.send(:parse, message)
end
