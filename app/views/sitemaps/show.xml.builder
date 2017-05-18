def site_map_xml(element, xml)
  xml_return = ""
  element.each do |el|
    e = el.last
    if e[:href] == true
      xml_return << xml.tag!("url") do
        xml.loc e[:loc]
        xml.lastmod e[:lastmod]
        xml.priority e[:priority]
      end
    end
    e[:elements].each do |elem|
      xml_return << site_map_xml(elem, xml)
    end
  end
  xml_return
end

xml.instruct! :xml, :version => '1.0'
xml.tag! 'urlset', 'xmlns' => 'http://www.sitemaps.org/schemas/sitemap/0.9' do
  @site_map.each do |element|
    site_map_xml(element, xml)
  end
end
