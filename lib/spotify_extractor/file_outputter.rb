require "spotify_extractor/results_outputter"
require "json"

class FileOutputter

  OUTPUT_FOLDER = "output"

  def initialize(format)
    create_folder
    @format = format
    @results_outputter = ResultsOutputter.new
  end

  def add(playlist_name, elements)
    @results_outputter.add(playlist_name, elements)
  end

  def output
    output = @results_outputter.output
    case @format
    when :simple
      simple_output(output)
    when :structured
      structured_output(output)
    when :artists_only
      artists_only_output(output)
    end
  end

  private
  def simple_output(output)
    output.keys.each do |playlist|
      file = open_file(playlist)
      output[playlist].each { |track| file.puts(track)}
      file.close
    end
  end

  def structured_output(output)
    output.keys.each do |playlist|
      file = open_file(playlist)
      output[playlist].each { |track| file.puts(track.to_json)}
      file.close
    end
  end

  def artists_only_output(output)
    file = open_file
    output.each { |artist| file.puts(artist)}
    file.close
  end

  def create_folder
    FileUtils.mkdir_p(OUTPUT_FOLDER)
  end

  def clean
    FileUtils.rm Dir.glob("#{OUTPUT_FOLDER}/*")
  end

  def open_file(playlist = nil)
    File.open("#{OUTPUT_FOLDER}/" +filename(playlist), "w+t")
  end

  def filename(playlist)
    case @format
    when :simple
      playlist.downcase.gsub(' ', '_') + ".playlist"
    when :structured
      playlist.downcase.gsub(' ', '_') + ".json"
    when :artists_only
      "artists.list"
    end
  end
end
