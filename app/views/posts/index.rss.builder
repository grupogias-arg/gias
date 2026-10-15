# Feed RSS de novedades.
#
# Reemplaza a la suscripción por mail, que quedó para una etapa 2 (CLAUDE.md).
# Quien quiera seguir al grupo se suscribe acá sin que haya que administrar
# una lista de direcciones ni mandar correos.
xml.instruct! :xml, version: "1.0"
xml.rss version: "2.0", "xmlns:atom": "http://www.w3.org/2005/Atom" do
  xml.channel do
    xml.title "#{t('site.name')} — #{t('novedades.title')}"
    xml.description t("novedades.subtitle")
    xml.link posts_url
    xml.language I18n.locale.to_s
    xml.tag! "atom:link", rel: "self", type: "application/rss+xml", href: posts_url(format: :rss)

    @posts.each do |post|
      xml.item do
        xml.title post.localized_title
        xml.description post.localized_excerpt
        xml.pubDate post.published_at.to_fs(:rfc822)
        xml.link post_url(slug: post)
        xml.guid post_url(slug: post), isPermaLink: "true"
      end
    end
  end
end
