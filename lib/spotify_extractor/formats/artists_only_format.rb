require "track_parser"

class ArtistsOnlyFormat

  def initialize
    @seen_list = []
  end

  def format(track)
    result = TrackParser::Parser.do({artists: track.artists.map(&:name), name: track.name})
    all_artists(result).map { |artist| add(artist) }.compact
  end

  def add(artist)
    downcased = artist.downcase
    if !@seen_list.include?(downcased)
      @seen_list << downcased
      return artist
    end
  end

  def all_artists(parsed_track)
    (parsed_track.artists.to_a + parsed_track.featuring.to_a + parsed_track.remixer.to_a).compact
  end

end
