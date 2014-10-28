require 'faraday'
require 'faraday_middleware'

module Allegro

  class Client
    def initialize
      fd_options = {
        headers: { "Accept" => "application/json",
                   "access_token" => ENV["allegro_access_token"] },
        ssl: { verify: false },
        url: ENV["allegro_base_url"]
      }

      @responses = []

      @connection = Faraday.new(fd_options) do |fd|
        fd.request :url_encoded
        fd.use FaradayMiddleware::ParseJson
        fd.adapter :net_http
      end

      @connection
    end

    # def set_access_token(access_token)
    #   fd_options = {
    #     headers: { "Accept" => "application/json",
    #                "Api-Key" => APP_CONFIG["TRIPFOLIO_CLIENT_ID"],
    #                "Authorization" => "Bearer "+ access_token },
    #     ssl: { verify: false },
    #     url: APP_CONFIG["TRIPFOLIO_API_URL"]
    #   }
    #
    #   @connection = Faraday.new(fd_options) do |fd|
    #     fd.request :url_encoded
    #     fd.use FaradayMiddleware::ParseJson
    #     fd.adapter :net_http
    #   end
    #
    #   @connection
    # end

    def request(end_point, http_method, params = {})
      data = nil
      data = params.to_json unless params.empty?

      request_url = ENV["allegro_base_url"] + end_point
      response = @connection.send(http_method, request_url.to_s, data)

      @responses = []

      if response.body
        @response_body = response.body
        @responses << @response_body
      else
        @response_body = nil
        @responses << @response_body
      end

      @responses[0]
    end

  end

end
