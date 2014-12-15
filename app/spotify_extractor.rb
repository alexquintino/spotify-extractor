require_relative "spotify_adapter"
require "json"

class SpotifyExtractor

  def self.extract(options)
    self.new(options).extract
  end

  def initialize(options)
    @spotify = SpotifyAdapter.new(options[:client_id], options[:client_secret])
    @output_type_method = options[:structured] ? self.method(:structured_output) : self.method(:simple_output)
    @user_id = options[:user_id]
    @tracks = []
  end

  def extract
    playlists = @spotify.users_playlists(@user_id)
    playlists.each do |playlist|
      puts "Fetching tracks for playlist: #{playlist.name}"
      create_folder
      File.open file_name(playlist.name), 'w+t' do |file|
        @spotify.all_tracks_for_playlist(playlist).each do |track|
          handle_track(file, track)
        end
        finish(file)
      end
    end
    puts "Done! Check the output folder"
  end

  def create_folder
    FileUtils.mkdir_p("output")
  end

  def file_name(playlist_name)
    if simple_output?
      "output/" + playlist_name.downcase.gsub(' ', '_') + ".playlist"
    else
      "output/" + playlist_name.downcase.gsub(' ', '_') + ".json"
    end
  end

  def handle_track(file, track)
    @output_type_method.call file, track
  end

  def simple_output?
    @output_type_method.name == :simple_output
  end

  def structured_output(file, track)
    @tracks << {artists: track.artists.map(&:name), name: track.name}
  end

  def simple_output(file, track)
    artists = track.artists.map(&:name).join(" & ")
    file.puts "#{artists} - #{track.name}"
  end

  def finish(file)
    unless simple_output?
      file.write(@tracks.to_json)
    end
  end
end
