$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'zookeeper'
require 'zookeeper_test_server'

unless Object.const_defined?(:ZOO_TEST)
  ZOO_TEST = '127.0.0.1:2182'
  ZOO_PATH = '/tmp/zookeeper'
end

Spec::Runner.configure do |config|
  config.before(:all) do
    $num = 0
    # Since we up/down zk during testing, the pidfile is unreliable.
    # Remove this cruft when that's fixed
    %x{  ps -eo pid,args }.each_line do |p|
      next unless p  =~ /(\d+)\s.*java.*org\.apache\.zookeeper\.server.*/
      pid  = $1.to_i
      if pid > 0
        puts "Killing stale ZooKeeper: PID #{pid}"
        Process.kill("SIGKILL", pid)
      end
    end
    FileUtils.remove_dir(ZOO_PATH, true)
    FileUtils.mkdir_p(ZOO_PATH + "/server1/data")
    ZooKeeperTestServer.start
    wait_until { ZooKeeperTestServer.running? }
    @zk = ZooKeeper.new(:host => ZOO_TEST)
    wait_until { @zk.connected? }
  end

  config.after(:all) do
    @zk.close
    wait_until { @zk.closed? }
    ZooKeeperTestServer.stop
    wait_until { !ZooKeeperTestServer.running? }
    FileUtils.remove_dir(ZOO_PATH, true)
  end

  config.before(:each) do
    $num += 1
  end
end

# method to wait until block passed returns true or timeout (default is 10 seconds) is reached
def wait_until(timeout=20, &block)
  time_to_stop = Time.now + timeout
  until yield do
    sleep(0.1) # much less cpu stress
    break if Time.now > time_to_stop
  end
end
