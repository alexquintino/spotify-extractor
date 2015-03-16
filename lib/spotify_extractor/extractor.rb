require "spotify_extractor/formats/simple_format"
require "spotify_extractor/formats/structured_format"
require "spotify_extractor/formats/artists_only_format"
require "spotify_extractor/spotify_adapter"

module SpotifyExtractor
  class Extractor
    FORMAT_MAPPING = {
      simple: SimpleFormat,
      structured: StructuredFormat,
      artists_only: ArtistsOnlyFormat
    }

    def initialize(options)
      @spotify = SpotifyAdapter.new(options[:client_id], options[:client_secret])
      @formatter = FORMAT_MAPPING[options[:format]].new(output_folder: "output")
      @user_id = options[:user_id]
      create_folder
    end

    def extract
      playlists = @spotify.users_playlists(@user_id)
      playlists.each do |playlist|
        puts "Fetching tracks for playlist: #{playlist.name}"
        @spotify.all_tracks_for_playlist(playlist).each do |track|
          @formatter.handle_track(playlist.name, track)
        end
        @formatter.finalize
      end
      puts "Done! Check the output folder"
    end

    def create_folder
      FileUtils.mkdir_p("output")
    end
  end
end
