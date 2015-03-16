class SimpleFormat

  def format(track)
    artists = track.artists.map(&:name).join(" & ")
   "#{artists} - #{track.name}"
  end
end
