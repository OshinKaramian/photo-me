require "rubygems"
require "instagram"
require "fb_graph"

CLIENT_KEY = ""
ACCESS_TOKEN = ""
EVENT_ID = ""
INSTAGRAM_HASH = ""
FACEBOOK_ID = ""

# All methods require authentication (either by client ID or access token).
# To get your Instagram OAuth credentials, register an app at http://instagr.am/oauth/client/register/
Instagram.configure do |config|
  config.client_id = CLIENT_KEY 
  config.access_token = ACCESS_TOKEN 
end

def current_event_links
  hash_list = Hash.new
  puts event = FbGraph::Event.fetch(EVENT_ID, :access_token => FACEBOOK_ID)
  
  for post in event.feed
    hash_list[post.link] = "1"
  end
  
  return hash_list
end

def main
  event_link_hash = current_event_links()    
  puts event = FbGraph::Event.fetch(EVENT_ID, :access_token => FACEBOOK_ID)

  # Search for users on instagram, by name or username
  for post in Instagram.tag_recent_media(INSTAGRAM_HASH).data do
    if !event_link_hash.has_key?(post.link)
      if post.caption.respond_to?('text')
        puts event.feed!(
         :link => post.link,
         :message => post.caption.text
        )
      end
    end
  end
end

loop do
  main()
  sleep(600)
end

