require "json"
class StructuredOutput

  def initialize(output_folder: "output")
    @output = output_folder
    @tracks = []
  end

  def set_file(file)
    @file = file
  end

  def filename(playlist)
    playlist.downcase.gsub(' ', '_') + ".json"
  end

  def handle_track(playlist, track)
    open_file(playlist) if @file.nil?
    @tracks << {artists: track.artists.map(&:name), name: track.name}
  end

  def open_file(playlist)
    @file = File.open(@output + "/" +filename(playlist), 'w+t')
  end

  def finalize
    @file.write(@tracks.to_json)
    @file.close
    @file = nil
  end
end
