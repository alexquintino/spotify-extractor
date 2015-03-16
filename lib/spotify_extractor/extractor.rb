require "spotify_extractor/outputs/simple_output"
require "spotify_extractor/outputs/structured_output"
require "spotify_extractor/outputs/artists_only_output"
require "spotify_extractor/spotify_adapter"

module SpotifyExtractor
  class Extractor
    OUTPUT_MAPPING = {
      simple: SimpleOutput,
      structured: StructuredOutput,
      artists_only: ArtistsOnlyOutput
    }


    def initialize(options)
      @spotify = SpotifyAdapter.new(options[:client_id], options[:client_secret])
      @outputter = OUTPUT_MAPPING[options[:output]].new(output_folder: "output")
      @user_id = options[:user_id]
      create_folder
    end

    def extract
      playlists = @spotify.users_playlists(@user_id)
      playlists.each do |playlist|
        puts "Fetching tracks for playlist: #{playlist.name}"
        @spotify.all_tracks_for_playlist(playlist).each do |track|
          @outputter.handle_track(playlist.name, track)
        end
        @outputter.finalize
      end
      puts "Done! Check the output folder"
    end

    def create_folder
      FileUtils.mkdir_p("output")
    end
  end
end
