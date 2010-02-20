#!/opt/local/bin/ruby1.9

require 'common'

def watcher_callback_handler(w)
  logit "watcher_callback_handler starting\n" +
        "  #{w.zh},#{w.type},#{w.state},#{w.path},#{w.context}\n" +
        "  zh      #{w.zh.inspect}\n" +
        "  type    #{w.type.inspect}\n" +
        "  state   #{w.state.inspect}\n" +
        "  path    #{w.path.inspect}\n" +
        "  context #{w.context.inspect}\n"
  logit "watcher_callback_handler complete"
end

Thread.new { while true do print '#'; sleep 1; end } ## heartbeat

zk = ZooKeeper.new(:host => "#{ZK_HOST}:#{ZK_PORT}")
wait_until { zk.connected? }

if zk.connected?
  (1..3).each do |i|
    @zwatcher = ZooKeeper::WatcherCallback.new do
      watcher_callback_handler(@zwatcher)
    end

    logit "setting @zwatcher #{i}..."
    zk.exists(:path => ZK_PATH, :watcher => @zwatcher)

    time_to_stop = Time.now.to_i + 20
    while time_to_stop > Time.now.to_i and not @zwatcher.completed? do
      print '.'
      sleep 0.2
    end
  end
end

zk.close
wait_until { zk.closed? }
