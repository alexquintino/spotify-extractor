require 'uri'
require "typhoeus"

class HttpAdapter
  def self.get(url, params)
    uri = URI(url)
    uri.query = URI.encode_www_form(params)

    request = Typhoeus::Request.new(uri.to_s, followlocation: true)

    request.on_complete do |response|
      raise ConnectionError.new("Something is wrong with your connection") if response.code == 0
      raise NotFoundError if response.code == 404
      raise UnknownHttpError unless response.success?
    end

    request.run
    request.response
  end
end

class ConnectionError < StandardError
end

class NotFoundError < StandardError
end

class UnknownHttpError < StandardError
end
