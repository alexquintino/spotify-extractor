require_relative "spotify_adapter"

class SpotifyExtractor

  def self.extract(options)
    self.new(options).extract(options[:user_id])
  end

  def initialize(options)
    @spotify = SpotifyAdapter.new(options[:client_id], options[:client_secret])
  end

  def extract(user_id)
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
      puts "Done! Check the output folder"
    end
  end

  def path(playlist_name)
    "output/" + playlist_name.downcase.gsub(' ', '_') + ".playlist"
  end

  def create_folder
    FileUtils.mkdir_p("output")
  end

end
