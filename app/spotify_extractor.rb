require_relative "spotify_adapter"

class SpotifyExtractor

  def initialize(client_id: '', client_secret: '')
    @spotify = SpotifyAdapter.new(client_id, client_secret)
  end

  def extract(user_id: '')
    playlists = @spotify.users_playlists(user_id)
    playlists.each do |playlist|
      puts "Fetching tracks for playlist: #{playlist.name}"
      create_folder
      File.open path(playlist.name), 'w+t' do |file|
        @spotify.all_tracks_for_playlist(playlist).each do |track|
          artists = track.artists.map(&:name).join(" & ")
          file.puts "#{artists} - #{track.name}"
        end
      end
    end
  end

  def path(playlist_name)
    "output/" + playlist_name.downcase.gsub(' ', '_') + ".playlist"
  end

  def create_folder
    FileUtils.mkdir_p("output")
  end

end
