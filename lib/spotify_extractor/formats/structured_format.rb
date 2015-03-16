class StructuredFormat

  def format(track)
    {artists: track.artists.map(&:name), name: track.name}
  end

end
