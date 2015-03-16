require "spotify_extractor/version"
require "spotify_extractor/extractor"

module SpotifyExtractor

  def self.extract(options)
    Extractor.new(options).extract
  end

end
