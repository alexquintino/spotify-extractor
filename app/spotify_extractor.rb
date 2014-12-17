require_relative "spotify_adapter"
require_relative "outputs/simple_output"
require_relative "outputs/structured_output"
require "json"

class SpotifyExtractor

  OUTPUT_MAPPING = {
    simple: SimpleOutput,
    structured: StructuredOutput,
  }

  def self.extract(options)
    self.new(options).extract
  end

  def initialize(options)
    @spotify = SpotifyAdapter.new(options[:client_id], options[:client_secret])
    @outputter = OUTPUT_MAPPING[options[:output]].new
    @user_id = options[:user_id]
  end

  def extract
    playlists = @spotify.users_playlists(@user_id)
    playlists.each do |playlist|
      puts "Fetching tracks for playlist: #{playlist.name}"
      create_folder
      File.open filename(playlist.name), 'w+t' do |file|
        @outputter.set_file(file)
        @spotify.all_tracks_for_playlist(playlist).each do |track|
          @outputter.handle_track(track)
        end
        @outputter.finalize
      end
    end
    puts "Done! Check the output folder"
  end

  def create_folder
    FileUtils.mkdir_p("output")
  end

  def filename(playlist_name)
    "output/" + @outputter.filename(playlist_name)
  end

end
