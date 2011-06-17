Factory.define :curated_feed_item do |f|
  f.update_embedly_on_save false
  f.original_url "http://blog.cleveland.com/metro/2011/05/global_cleveland_will_launch_w.html"
  f.provider_url "http://blog.cleveland.com/"
  f.title "Global Cleveland will launch with a multicultural party at City Hall"
  f.description "Tuesday, hundreds of people are expected to converge on Cleveland City Hall to declare that being a multicultural city is okay with them. The region's two leading public officials--Mayor Frank Jackson and Cuyahoga County Executive Ed FitzGerald--will join them to announce that Greater Cleveland is again willing to welcome the world."
  f.pub_date 1.day.ago
  f.raw File.open("#{File.dirname(__FILE__)}/../fixtures/curated_feed_objectify.json", 'rb') { |f| f.read }
  f.association :curated_feed, :factory => :curated_feed
end
