require 'sensu-plugin/check/cli'
require 'json'
class CheckIndexCount < Sensu::Plugin::Check::CLI

  option :warn,
         :short => '-w WARN',
         :proc => proc {|a| a.to_i },
         :default => 295995

  option :crit,
         :short => '-c CRIT',
         :proc => proc {|a| a.to_i },
         :default => 0

  def run
    count = 0

    `curl -XGET 'http://ttsearch:8080/ipam_cyanite_paths/_count'`.split("\n").drop(0).each do |res|
      count = JSON.parse(res)["count"]
    end

    critical if count == config[:crit]
    warning if count == config[:warn]
    ok
  end
end