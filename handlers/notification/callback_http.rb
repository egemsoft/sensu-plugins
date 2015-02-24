#!/usr/bin/env ruby

require 'rubygems' if RUBY_VERSION < '1.9.0'
require 'sensu-handler'
require 'net/http'
require 'uri'
require 'timeout'
require 'json'


class CallbackHttp < Sensu::Handler

	def handle
		puts "CallbackHttp handler is started..."
		json_config	= config[:json_config]
		output = @event['check']['output']
		status = @event['check']['status']
		kwargs = @event['check']['kwargs']

		puts "output is #{output}"
		puts "status is #{status}"
		puts "kwargs is #{kwargs}"


		if kwargs.has_key?('callback_url')
			callback_url = kwargs['callback_url']
		else
			callback_url = settings['callback_http']['callback_url']
		end

		

		unless callback_url.nil?
			puts "callback url is #{callback_url}/#{status}"
			callback_url = "#{callback_url}/#{status}"
			uri=URI.parse(callback_url)
			http = Net::HTTP.new(uri.host, uri.port)
			uri_config={"host" => uri.host, "port" => uri.port, "path" => uri.path}
			puts "URI is #{uri_config}"

			response=http.post(uri.path,{'output' => output}.to_json,{"Content-Type" => "application/json","Accept" => "application/json"})
			if response.code.to_i < 400
				puts "success for callback url #{callback_url}"
			else
				puts "Error, code #{response.code} for callback url #{callback_url}"
				puts response.message
			end
		end
	end
end		


