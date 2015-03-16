class ResultsOutputter

  def initialize
    @output = {}
  end

  def add(playlist_name, elements)
    @output[playlist_name] = elements
  end

  def output
    @output
  end
end
