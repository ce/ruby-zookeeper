#!/opt/local/bin/ruby1.9

require 'common'

zk = ZooKeeper.new(:host => "#{ZK_HOST}:#{ZK_PORT}")
wait_until { zk.connected? }

if zk.connected?
  puts "++ 1st test"
  puts "'/not-existent' exists? #{zk.exists?('/not-existent')}"
  puts "'/zookeeper' exists? #{zk.exists?('/zookeeper')}"

  createdPath = zk.create(:path => "/something-ephemeral-with-seq", :data => "content", 
                          :ephemeral => true, :sequence => true)
  puts "createdPath = #{createdPath.inspect}"
  puts "#{createdPath} exists? #{zk.exists?(createdPath)}"
  puts "createdPath content is #{zk.get(createdPath).inspect}"
  zk.close
  wait_until { zk.closed? }
end

GC.start # shouldn't crash after this

zk = ZooKeeper.new(:host => "#{ZK_HOST}:#{ZK_PORT}")
wait_until { zk.connected? }

if zk.connected?
  puts "++ 2nd test"
  puts "#{createdPath} exists? #{zk.exists?(createdPath)}"
  zk.close
  wait_until { zk.closed? }
end

zk = ZooKeeper.new(:host => "#{ZK_HOST}:#{ZK_PORT}")
wait_until { zk.connected? }

if zk.connected?
  puts "++ 3rd test"
  createdPath = zk.create(:path => "/something-ephemeral-with-seq", :data => "content", 
                          :ephemeral => true, :sequence => true)
  puts "createdPath = #{createdPath.inspect}"
  puts "#{createdPath} exists? #{zk.exists?(createdPath)}"
  puts "createdPath content is #{zk.get(createdPath).inspect}"
  zk.close
  wait_until { zk.closed? }
end
