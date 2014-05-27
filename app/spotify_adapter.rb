require_relative "spotify_response"
require_relative "http_adapter"
require 'json'

class SpotifyAdapter

  LOOKUP_URL = "http://ws.spotify.com/lookup/1/.json"
  
  def self.get_track(id)
    begin
      response = HttpAdapter.get(LOOKUP_URL, {uri: id})
    rescue NotFoundError
      raise TrackNotFound.new("Couldn't find track #{id}")
    end

    SpotifyResponse.for(JSON.parse(response.body))
  end
end

class TrackNotFound < StandardError
end