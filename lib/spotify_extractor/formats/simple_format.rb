class SimpleFormat

  def initialize(output_folder: "output")
    @output = output_folder
  end

  def filename(playlist)
    playlist.downcase.gsub(' ', '_') + ".playlist"
  end

  def handle_track(playlist, track)
    open_file(playlist) if @file.nil?
    artists = track.artists.map(&:name).join(" & ")
    @file.puts "#{artists} - #{track.name}"
  end

  def open_file(playlist)
    @file = File.open(@output + "/" +filename(playlist), 'w+t')
  end

  def finalize
    @file.close
    @file = nil
  end
end
