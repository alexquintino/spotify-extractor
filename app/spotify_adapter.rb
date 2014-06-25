require_relative "spotify_response"
require_relative "http_adapter"

class SpotifyAdapter

  LOOKUP_URL = "http://ws.spotify.com/lookup/1/.json"
  SPOTIFY_THROTTLE_LIMIT_PER_SECONDS = 10

  def initialize
    @http_adapter = HttpAdapter.new
  end

  def get_tracks(track_ids)
    while track_ids.size != 0
      batch = track_ids.take(SPOTIFY_THROTTLE_LIMIT_PER_SECONDS)
      track_ids -= batch
      batch.each do |id|
       get_track(id) do |track|
         yield track
       end
      end
      @http_adapter.execute
    end
  end

  private

  def get_track(id)
    begin
      @http_adapter.get(LOOKUP_URL, {uri: id}) do |response|
        yield SpotifyResponse.for(response)
      end
    rescue NotFoundError
      raise TrackNotFound.new("Couldn't find track #{id}")
    end
  end
end

class TrackNotFound < StandardError
end