require_relative "spotify_adapter"

class SpotifyExtractor
  def self.extract(filename)
    contents = File.readlines(filename)
    contents.map do |content| 
      track = SpotifyAdapter.get_track(content.chomp)
      if block_given?
        yield(track)
      else
        puts "#{track.artist_name} - #{track.name}"
      end
    end
  end

end