require 'net/http'
require 'json'
require_relative "spotify_response"

class SpotifyAdapter

  LOOKUP_URL = "http://ws.spotify.com/lookup/1/.json"
  
  def self.get_track(id)
    uri = URI(LOOKUP_URL)
    params = {uri: id}
    uri.query = URI.encode_www_form(params)
    response = Net::HTTP.get_response(uri)
    SpotifyResponse.for(JSON.parse(response.body))
  end

end