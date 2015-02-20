#!/usr/bin/env ruby

require 'rubygems' if RUBY_VERSION < '1.9.0'
require 'sensu-handler'
require 'net/http'
require 'uri'
require 'timeout'


class CallbackHttp < Sensu::Handler

	def handle
		puts "CallbackHttp handler is started..."
		json_config	= config[:json_config]
		output = @event['check']['output']
		status = @event['check']['status']
		kwargs = @event['check']['kwargs']

		if kwargs.has_key?('callback_url')
			callback_url = kwargs['callback_url']
		else
			callback_url = settings['callback_http']['callback_url']
		end

		puts "callback url is #{callback_url}/#{status}"
		unless callback_url.nill?
			uri = URI("#{callback_url}/#{status}")
			Net::HTTP.get(uri)			
		end
	end
end		


