xml.instruct! :xml, :version => '1.0', :encoding => 'UTF-8'
xml.rss :version => '2.0', 'xmlns:itunes' => 'http://www.itunes.com/dtds/podcast-1.0.dtd' do
  xml.channel do
    xml.title 'The Civic Commons Podcast'
    xml.link root_url
    xml.description 'The Civic Commons podcast is a dynamic half-hour public affairs program airing Saturday mornings on 88.7 FM, WJCU, featuring citizen voices more than talking heads, citizen commentaries instead of expert drones and hosts who are always looking for different ways to set the stage for discussion.'
    xml.copyright "(c) Copyright #{Date.today.strftime('%Y')} The Civic Commons"
    xml.image do
      xml.url url_for '/images/cc_podcast_small.jpg'
      xml.title 'The Civic Commons Podcast'
      xml.url root_url
    end
    xml.language 'en-us'
    xml.pubDate DateTime.now.strftime('%a, %d %B %Y %H:%M:%S EST')
    xml.lastBuildDate DateTime.now.strftime('%a, %d %B %Y %H:%M:%S EST')
    xml.tag!('itunes:summary', 'The Civic Commons podcast is a dynamic half-hour public affairs program airing Saturday mornings on 88.7 FM, WJCU, featuring citizen voices more than talking heads, citizen commentaries instead of expert drones and hosts who are always looking for different ways to set the stage for discussion.')
	xml.tag!('itunes:subtitle', 'Weekly Radio Show Podcast')
	xml.tag!('itunes:author', 'The Civic Commons')
    xml.tag!('itunes:owner') do
      xml.tag!('itunes:name', 'The Civic Commons')
      xml.tag!('itunes:email', 'suggestions@theciviccommons.com')
    end
    xml.tag!('itunes:category', :text => 'News &amp; Politics')
    xml.tag!('itunes:image', :href => '/images/cc_podcast.jpg')
	xml.tag!('itunes:explicit', 'No')
    for show in @radioshows
      xml.item do
        xml.title show.title
        xml.link radioshow_url(show)
        xml.guid radioshow_url(show)
        xml.description show.summary
        xml.pubDate show.published.to_s(:rfc822)
        xml.enclosure :url => '@radioshow.external_link', :length => '17159756', :type =>'audio/mpeg' 
		xml.tag!('itunes:author', 'The Civic Commons')
		xml.tag!('itunes:summary', show.summary)
      end
    end
  end
end