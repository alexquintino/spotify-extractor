class StructuredOutput

  def initialize
    @tracks = []
  end

  def set_file(file)
    @file = file
  end

  def filename(playlist)
    playlist.downcase.gsub(' ', '_') + ".json"
  end

  def handle_track(track)
    @tracks << {artists: track.artists.map(&:name), name: track.name}
  end

  def finalize
    @file.write(@tracks.to_json)
  end
end
