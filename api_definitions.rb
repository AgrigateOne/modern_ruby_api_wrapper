# frozen_string_literal: true
require 'open-uri'
require 'net/https'

# Implement methods that receive input, call APIs and return results
class ApiDefinitions
  def check_state
    'The Modern Ruby API wrapper is running'
  end

  def setup_http(url)
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)

    http.open_timeout = 2
    http.read_timeout = 600
    http.use_ssl = true

    [uri, http]
  end

  def run_api_request_get(url, request_fields = {})
    uri, http       = setup_http(url)
    api_request     = Net::HTTP::Get.new(uri.request_uri)
    request_fields.each do |key, val|
      api_request.add_field(key.to_s, val.to_s)
    end

    http.request(api_request)
  end

  def run_api_request_post(url, params, request_fields = {})
    uri, http       = setup_http(url)
    api_request     = Net::HTTP::Post.new(uri.request_uri)
    request_fields.each do |key, val|
      api_request.add_field(key.to_s, val.to_s)
    end

    api_request.set_form_data(params)
    http.request(api_request)
  end
end
