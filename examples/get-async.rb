#!/opt/local/bin/ruby1.9

require 'common'

zk = ZooKeeper.new(:host => "#{ZK_HOST}:#{ZK_PORT}")
wait_until { zk.connected? }

if zk.connected?
  cb = ZooKeeper::DataCallback.new do
    logit "------------------- data callback fired"
    logit "return_code #{cb.return_code}"
    logit "stat #{cb.stat.inspect}"
    sleep 2
  end

  rc = zk.get(:path => ZK_PATH, :callback => cb, :context => 'la')
  wait_until { cb.completed? }
end

zk.close
wait_until { zk.closed? }
