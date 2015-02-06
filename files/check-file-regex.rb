#!/usr/bin/env ruby
#
# Simple Sensu File Exists Plugin
# ===
#
# Sometimes you just need a simple way to test if your alerting is functioning
# as you've designed it. This test plugin accomplishes just that. But it can
# also be set to check for the existance of any file (provided you have
# read-level permissions for it)
#
# By default it looks in your /tmp folder and looks for the files CRITICAL,
# WARNING or UNKNOWN. If it sees that any of those exists it fires off the
# corresponding status to sensu. Otherwise it fires off an "ok".
#
# This allows you to fire off an alert by doing something as simple as:
# touch /tmp/CRITICAL
#
# And then set it ok again with:
# rm /tmp/CRITICAL
#
# Copyright 2013 Mike Skovgaard <mikesk@gmail.com>
#
# Released under the same terms as Sensu (the MIT license); see LICENSE
# for details.

require 'rubygems' if RUBY_VERSION < '1.9.0'
require 'sensu-plugin/check/cli'

class CheckFileExists < Sensu::Plugin::Check::CLI

  option :prefix,
	short: '-p PREFIX',
	long: '--prefix DIR'

  option :suffix,
	short: '-s SUFFIX',
	long: '--suffix DIR'	

  option :format,
    short: '-f FORMAT',
    long: '--format FORMAT',
    default: '%Y%m%d%H%M'

  option :tp,
    short: '-tp TIMEPERIOD',
    long: '--time-period TIMEPERIOD'

  option :tz,
    short: '-tz TIMEZONE',
    long: '--time-zone TIMEZONE'    


  def run
  	t = Time.now
  	t2 = Time.now

  	if config[:tp]
		t = Time.at(Time.now.to_i - (Time.now.to_i % (config[:tp].to_i*60)))
  	end

  	if config[:tz]
		t = t.utc.strftime(config[:format])
	else
		t = t.localtime.strftime(config[:format])
  	end 

  	f = "#{config[:prefix]}#{t}#{config[:suffix]}" 	
    
    if config[:prefix] && File.exists?(f)
      ok "exists! #{f}"
    elsif config[:unknown] && File.exists?(config[:unknown])
      unknown "#{config[:unknown]} exists!"
    else
      critical "No test files exist #{f}"
    end
  end

end