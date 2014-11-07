require_relative "spotify_adapter"

class SpotifyExtractor

  def initialize(client_id: '', client_secret: '')
    @spotify = SpotifyAdapter.new(client_id, client_secret)
  end

  def extract(user_id: '')
    playlists = @spotify.users_playlists(user_id)
    playlists.each do |playlist|
      puts "------------ #{playlist.name} -----------------"
      @spotify.all_tracks_for_playlist(playlist).each do |track|
        puts "#{track.artists.first.name} - #{track.name}"
      end
    end
  end

end
