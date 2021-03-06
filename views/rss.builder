xml.instruct! :xml, :version => '1.0'
xml.rss :version => "2.0" do
  xml.channel do
    xml.title @title
    xml.description @description
    xml.link @link

    @posts.each do |post|
      xml.item do
        xml.title post[:title]
        xml.link post[:link]
        xml.description post[:body]
        xml.pubDate Time.parse(post[:created_at].to_s).rfc822()
        xml.guid post[:guid]
      end
    end
  end
end
