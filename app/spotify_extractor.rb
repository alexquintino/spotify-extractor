require_relative "spotify_adapter"

class SpotifyExtractor
  def self.extract(filename)
    contents = File.readlines(filename)
    tracks = contents.map do |content| 
      SpotifyAdapter.get_track(content.chomp)
    end

    tracks.each { |track| puts "#{track.artist_name} - #{track.name}" }
  end

end