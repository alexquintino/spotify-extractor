require_relative "spotify_adapter"

class SpotifyExtractor

  def initialize
    @spotify = SpotifyAdapter.new()
  end

  def extract(filename)
    contents = File.readlines(filename)
    contents = contents.map(&:chomp)
    @spotify.get_tracks(contents) do |track|
      puts "#{track.artist_name} - #{track.name}"
    end
  end

end