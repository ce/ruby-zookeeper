class ZooKeeperTestServer

  @@log_level_set = false
  @@serverIO = nil

  def self.running?
    Process.getpgid(@@serverIO.pid) rescue return false
    true
  end

  def self.start
    set_log_level
    @@serverIO = IO.popen('zk/bin/zkServer.sh start', 'r')
  end

  def self.stop
    @@serverIO.close
    `zk/bin/zkServer.sh stop`
  end

  def self.set_log_level
    return if @@log_level_set
    # 0 = OFF, 1 = ERROR, 2 = WARN, 3 = INFO, 4 = DEBUG
    ZooKeeper.debug_level = ENV['ZK_LOG_LEVEL'] ? ENV['ZK_LOG_LEVEL'].to_i : 0
    @@log_level_set = true
  end

end
