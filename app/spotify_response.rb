require_relative "spotify_track_response"

class SpotifyResponse
  
  def self.for(data)
    if track?(data)
      SpotifyTrackResponse.new(data["track"])
    end   
  end

  def self.track?(data)
    data["info"]["type"] == "track"
  end
end