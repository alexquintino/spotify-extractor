require "spotify_extractor/formats/simple_format"
require "spotify_extractor/formats/structured_format"
require "spotify_extractor/formats/artists_only_format"
require "spotify_extractor/spotify_adapter"
require "spotify_extractor/file_outputter"
require "spotify_extractor/results_outputter"

module SpotifyExtractor
  class Extractor
    FORMAT_MAPPING = {
      simple: SimpleFormat,
      structured: StructuredFormat,
      artists_only: ArtistsOnlyFormat
    }

    def initialize(options)
      @spotify = SpotifyAdapter.new(options[:client_id], options[:client_secret])
      @formatter = FORMAT_MAPPING[options[:format]].new
      @outputter = options[:output] == :file ? FileOutputter.new(options[:format]) : ResultsOutputter.new
      @user_id = options[:user_id]
      @log = options[:log]
    end

    def extract_playlists
      playlists = @spotify.users_playlists(@user_id)
    end

    def extract
      playlists = @spotify.users_playlists(@user_id)
      playlists.each do |playlist|
        log "Fetching tracks for playlist: #{playlist.name}"
        tracks = @spotify
          .all_tracks_for_playlist(playlist)
          .map { |track| @formatter.format(track) }
        @outputter.add(playlist.name, tracks)
      end
      log "Done! Check the output folder"
      return @outputter.output
    end

    def log(text)
      puts text if @log
    end
  end
end
