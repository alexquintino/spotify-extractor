require 'rspotify'

class SpotifyAdapter

  def get_tracks(track_ids)
    track_ids.each do |spotify_track_id|
      parts = spotify_track_id.split(":")
      next if parts[1] == "local" # skip local tracks
      id = parts[2] # alphanumeric part
      yield get_track(id)
    end
  end

  private

  def get_track(id)
    begin
      RSpotify::Track.find(id)
    rescue RestClient::ResourceNotFound
      raise TrackNotFound.new("Couldn't find track #{id}")
    end
  end
end

class TrackNotFound < StandardError
end