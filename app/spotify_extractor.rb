require_relative "spotify_adapter"
require_relative "outputs/simple_output"
require_relative "outputs/structured_output"
require_relative "outputs/artists_only_output"

class SpotifyExtractor

  OUTPUT_MAPPING = {
    simple: SimpleOutput,
    structured: StructuredOutput,
    artists_only: ArtistsOnlyOutput
  }

  def self.extract(options)
    self.new(options).extract
  end

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
