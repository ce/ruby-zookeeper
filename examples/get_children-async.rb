#!/opt/local/bin/ruby1.9

require 'common'

def children_callback_handler(w)
  logit "children_callback_handler starting\n" +
        "  return_code #{w.return_code.inspect}\n" +
        "  children    #{w.children.inspect}\n" +
        "  context     #{w.context.inspect}\n"
  logit "children_callback_handler complete"
end

Thread.new { while true do print '#'; sleep 1; end } ## heartbeat

zk = ZooKeeper.new(:host => "#{ZK_HOST}:#{ZK_PORT}")
wait_until { zk.connected? }

if zk.connected?
  @cb = ZooKeeper::StringsCallback.new do
    children_callback_handler(@cb)
  end

  zk.get_children(:path => ZK_PATH, :callback => @cb)

  time_to_stop = Time.now.to_i + 20
  while time_to_stop > Time.now.to_i and not @cb.completed? do
    print '.'
    sleep 0.2
  end
end

zk.close
wait_until { zk.closed? }
