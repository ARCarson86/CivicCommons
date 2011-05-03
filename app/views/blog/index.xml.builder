xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0", 'xmlns:atom' => "http://www.w3.org/2005/Atom" do
  xml.channel do
    xml.tag!('atom:link', :href => blog_index_url(:format => :xml), :rel => "self", :type => "application/rss+xml")
    xml.title "The Civic Commons: Common Blog"
    xml.description "The Civic Commons is a new way to bring communities together with conversation and emerging technology. We’re focused on building conversations and connections that have the power to become informed, productive collective civic action."
    xml.copyright "(c) Copyright #{Date.today.strftime('%Y')} The Civic Commons"
    xml.link blog_index_url(:format => :xml)
    xml.language "en-us"
    for post in @blog_posts
      xml.item do
        xml.title post.title
        xml.link blog_url(post)
        xml.guid blog_url(post)
        xml.description post.summary
        xml.pubDate post.published.to_s(:rfc822)
      end
    end
  end
end
