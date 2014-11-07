require 'rspotify'

class SpotifyAdapter

  def initialize(client_id, client_secret)
    RSpotify.authenticate(client_id, client_secret)
  end

  def users_playlists(user_id)
    RSpotify::User.find(user_id).playlists
  end

  def all_tracks_for_playlist(playlist)
    results = []
    offset = 0
    limit = 100
    Enumerator.new do |yielder|
      loop do
        results = playlist.tracks(offset: offset, limit: limit)
        results.each { |track| yielder.yield track}
        offset += results.size
        raise StopIteration if results.size < limit
      end
    end
  end
end

class TrackNotFound < StandardError
end
