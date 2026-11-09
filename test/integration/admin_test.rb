require "test_helper"

# Recorre el panel como lo usa Fiorela: listar, crear, editar, ordenar y
# borrar en cada sección.
class AdminTest < ActionDispatch::IntegrationTest
  setup do
    sign_in

    @ana = Member.create!(name: "Ana", position: 1)
    @beto = Member.create!(name: "Beto", position: 2, photo: foto)
    @paper = Publication.create!(kind: "cientifica", title: "Paper", doi: "10.1111/x.1")
    @project = Project.create!(title: "Proyecto", funder: "pict", year_start: 2020, photo: foto)
    @campaign = Campaign.create!(name: "Campaña", year_start: 2020, photos: [ foto, foto ])
    @playlist = OutreachItem.create!(kind: "playlist", title: "Lista", youtube_id: "PLabc", position: 1)
  end

  test "pide login" do
    delete admin_session_path
    get admin_members_path
    assert_redirected_to new_admin_session_path
  end

  test "todas las páginas cargan" do
    [ admin_members_path, admin_publications_path, admin_projects_path, admin_campaigns_path,
      admin_outreach_items_path, admin_cover_photos_path, admin_posts_path,
      new_admin_member_path, new_admin_publication_path, new_admin_project_path,
      new_admin_campaign_path, new_admin_outreach_item_path,
      edit_admin_member_path(@beto), edit_admin_publication_path(@paper), edit_admin_project_path(@project),
      edit_admin_campaign_path(@campaign), edit_admin_outreach_item_path(@playlist) ].each do |path|
      get path
      assert_response :success, path
    end
  end

  test "el menú resalta la sección también al editar" do
    get edit_admin_member_path(@ana)
    assert_select "nav a.bg-structure", text: "Equipo"
  end

  test "equipo: alta al final, orden con flechas y baja" do
    post admin_members_path, params: { member: { name: "", email: "x" } }
    assert_response :unprocessable_entity

    post admin_members_path, params: { member: { name: "Caro" } }
    assert_redirected_to admin_members_path
    assert_equal 3, Member.find_by!(name: "Caro").position

    patch move_admin_member_path(@ana, direction: "despues")
    assert_equal %w[Beto Ana Caro], Member.ordered.pluck(:name)

    delete admin_member_path(@ana)
    assert_not Member.exists?(@ana.id)
  end

  test "foto única: el campo vacío no la borra, la casilla sí" do
    patch admin_project_path(@project), params: { project: { title: "Otro título", photo: "" } }
    assert @project.reload.photo.attached?

    patch admin_project_path(@project), params: { sacar_photo: "1", project: { title: "Otro título" } }
    assert_not @project.reload.photo.attached?

    patch admin_project_path(@project), params: { sacar_photo: "1", project: { photo: foto } }
    assert @project.reload.photo.attached?, "si se elige una foto nueva, gana la nueva"
  end

  test "proyectos: el año de cierre no puede ser anterior al de inicio" do
    post admin_projects_path, params: { project: { title: "P", funder: "pict", year_start: 2020, year_end: 2019 } }
    assert_response :unprocessable_entity
    assert_select ".admin-error"
  end

  test "publicaciones: el DOI se puede pegar como link" do
    post admin_publications_path, params: { publication: { kind: "cientifica", title: "T", doi: "https://doi.org/10.1234/Abc.99" } }
    assert_redirected_to admin_publications_path
    assert_equal "10.1234/Abc.99", Publication.find_by!(title: "T").doi

    post admin_publications_path, params: { publication: { kind: "cientifica", title: "Sin DOI" } }
    assert_response :unprocessable_entity

    post admin_publications_path, params: { publication: { kind: "divulgacion", title: "Divulgación", doi: "" } }
    assert_nil Publication.find_by!(title: "Divulgación").doi
  end

  test "campañas: coordenadas completas y fotos que se sacan destildando" do
    post admin_campaigns_path, params: { campaign: { name: "C", lat: "-38.1", lng: "" } }
    assert_response :unprocessable_entity

    queda = @campaign.photos.first
    patch admin_campaign_path(@campaign), params: { campaign: { photos: [ "", queda.signed_id ] } }
    assert_equal [ queda.blob_id ], @campaign.reload.photos.map(&:blob_id)

    patch admin_campaign_path(@campaign), params: { campaign: { photos: [ "", queda.signed_id, foto ] } }
    assert_equal 2, @campaign.reload.photos.count
  end

  test "divulgación: se pega el link de YouTube" do
    {
      "https://www.youtube.com/watch?v=dQw4w9WgXcQ&list=PLx&si=abc" => [ "video", "dQw4w9WgXcQ" ],
      "https://youtu.be/abcDEF123_-?si=zz" => [ "video", "abcDEF123_-" ],
      "https://www.youtube.com/shorts/xyz987" => [ "video", "xyz987" ],
      "dQw4w9WgXcQ" => [ "video", "dQw4w9WgXcQ" ],
      "https://youtube.com/playlist?list=PLabc123&si=x" => [ "playlist", "PLabc123" ]
    }.each_with_index do |(link, (kind, id)), index|
      post admin_outreach_items_path, params: { outreach_item: { kind: kind, title: "V#{index}", youtube_id: link } }
      assert_redirected_to admin_outreach_items_path
      assert_equal id, OutreachItem.find_by!(title: "V#{index}").youtube_id, link
    end

    get edit_admin_outreach_item_path(@playlist)
    assert_select "input[name='outreach_item[youtube_id]'][value='https://www.youtube.com/playlist?list=PLabc']"

    post admin_outreach_items_path, params: { outreach_item: { kind: "articulo", title: "Sin link" } }
    assert_response :unprocessable_entity
  end

  test "divulgación: orden con flechas" do
    nuevo = OutreachItem.create!(kind: "articulo", title: "Artículo", url: "https://example.com", position: 2)
    patch move_admin_outreach_item_path(nuevo, direction: "antes")
    assert_equal %w[Artículo Lista], OutreachItem.ordered.pluck(:title)
  end

  test "crossref: trae los datos del DOI" do
    work = { doi: "10.5555/ok", title: "T", authors: "Ferretti N.", year: 2020, journal: "J" }

    stubbing(Crossref, :work, ->(doi) { work if doi == "10.5555/ok" }) do
      get crossref_admin_publications_path, params: { doi: "https://doi.org/10.5555/ok" }
      assert_response :success
      assert_equal "T", response.parsed_body["title"]

      get crossref_admin_publications_path, params: { doi: "hola" }
      assert_response :unprocessable_entity

      get crossref_admin_publications_path, params: { doi: "10.5555/nada" }
      assert_response :not_found
    end
  end

  test "crossref: avisa si el DOI ya está cargado, salvo en la misma publicación" do
    stubbing(Crossref, :work, ->(_doi) { nil }) do
      get crossref_admin_publications_path, params: { doi: "10.1111/X.1" }
      assert_response :conflict
      assert_includes response.parsed_body["error"], "Paper"

      get crossref_admin_publications_path, params: { doi: "10.1111/x.1", id: @paper.id }
      assert_response :not_found
    end
  end

  test "crossref: si no responde, avisa sin romper" do
    stubbing(Crossref, :work, ->(_doi) { raise Crossref::Error, "caído" }) do
      get crossref_admin_publications_path, params: { doi: "10.5555/ok" }
      assert_response :bad_gateway
    end
  end

  private
    def foto
      fixture_file_upload("foto.png", "image/png")
    end
end
