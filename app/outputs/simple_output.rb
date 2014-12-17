class SimpleOutput

  def set_file(file)
    @file = file
  end

  def filename(playlist)
    playlist.downcase.gsub(' ', '_') + ".playlist"
  end

  def handle_track(track)
    artists = track.artists.map(&:name).join(" & ")
    @file.puts "#{artists} - #{track.name}"
  end

  def finalize
  end
end
