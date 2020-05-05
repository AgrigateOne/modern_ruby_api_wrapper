# frozen_string_literal: true
require 'open-uri'
require 'net/https'

# Implement methods that receive input, call APIs and return results
class ApiDefinitions
  def check_state
    'The Modern Ruby API wrapper is running'
  end

  def run_api_request_get(url, use_ssl, headers = {})
    uri, http       = setup_http(url, use_ssl)
    api_request     = Net::HTTP::Get.new(uri.request_uri)
    headers.each do |key, val|
      api_request.add_field(key.to_s, val.to_s)
    end

    response = http.request(api_request)
    [response.code, response.body]
  end

  def run_api_request_post(url, use_ssl, params, headers = {})
    uri, http       = setup_http(url, use_ssl)
    api_request     = Net::HTTP::Post.new(uri.request_uri)
    headers.each do |key, val|
      api_request.add_field(key.to_s, val.to_s)
    end

    api_request.set_form_data(params)
    response = http.request(api_request)
    [response.code, response.body]
  end

  private

  def setup_http(url, use_ssl)
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)

    http.open_timeout = 2
    http.read_timeout = 600
    http.use_ssl = true if use_ssl

    [uri, http]
  end
end
