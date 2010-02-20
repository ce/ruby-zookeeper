require '../lib/zookeeper'

#GC.disable
STDOUT.sync = true
#Thread.abort_on_exception = true

ZK_HOST = ENV['ZK_HOST'] ? ENV['ZK_HOST'] : "127.0.0.1"
ZK_PORT = ENV['ZK_PORT'] ? ENV['ZK_PORT'].to_i : 2181

ZooKeeper.debug_level = ENV['ZK_LOG_LEVEL'] ? ENV['ZK_LOG_LEVEL'].to_i : ZooKeeperFFI::ZOO_LOG_LEVEL_DEBUG

ZK_PATH = ARGV[0] || "/zookeeper"

def wait_until(timeout=10, &block)
  time_to_stop = Time.now + timeout
  until yield do
    sleep(0.1)
    if Time.now > time_to_stop
      puts "(timeout)"
      break
    end
  end
end

def logit(msg)
  puts "--- #{Time.now} #{msg}"
end

