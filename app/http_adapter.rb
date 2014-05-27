require 'net/http'

class HttpAdapter
  def self.get(url, params)
    uri = URI(url)
    uri.query = URI.encode_www_form(params)
    begin
      response = Net::HTTP.get_response(uri)
    rescue SocketError
      raise ConnectionError.new("Something is wrong with your connection")
    end
    raise NotFoundError if response.is_a? Net::HTTPNotFound
    return response if response.is_a? Net::HTTPSuccess
    raise UnknownHttpError
  end
end

class ConnectionError < StandardError
end

class NotFoundError < StandardError
end

class UnknownHttpError < StandardError
end
