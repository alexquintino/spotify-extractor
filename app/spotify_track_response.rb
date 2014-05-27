class SpotifyTrackResponse
  
  def initialize(data)
    @data = data
  end

  def artist_name
    artists.first["name"]
  end

  def artists
    @data["artists"]
  end

  def name
    @data["name"]
  end
end