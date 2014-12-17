require "track_parser"
require "pry"

class ArtistsOnlyOutput

  def initialize(output_folder: "output")
    @output = output_folder
    @seen_list = []
  end

  def filename(playlist)
    "artists.list"
  end

  def handle_track(playlist, track)
    open_file(playlist) if @file.nil?
    result = TrackParser::Parser.do({artists: track.artists.map(&:name), name: track.name})
    result.artists.each { |artist| add(artist) }
    result.featuring.each { |artist| add(artist) } if result.featuring
    result.remixer.each { |artist| add(artist) } if result.remixer
  end

  def add(artist)
    if !@seen_list.include?(artist)
      @seen_list << artist
      @file.puts(artist)
    end
  end

  def open_file(playlist)
    @file = File.open(@output + "/" +filename(playlist), 'a+t')
  end

  def finalize
    @file.close
    @file = nil
  end
end
