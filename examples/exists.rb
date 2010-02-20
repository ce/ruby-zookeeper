#!/opt/local/bin/ruby1.9

require 'common'

STAT_ATTRS = [ :czxid, :mzxid, :ctime, :mtime, :version, :cversion,
  :aversion, :ephemeralOwner, :dataLength, :numChildren, :pzxid ]

ZWatcher = Proc.new { puts "ZWatcher called" }

zk = ZooKeeper.new(:host => "#{ZK_HOST}:#{ZK_PORT}", :watcher => ZWatcher)
wait_until { zk.connected? }

if zk.connected?
  print "--- checking path #{ZK_PATH} .. boolean exists? returns "
  puts (path_exists = zk.exists?(ZK_PATH)) ? "true" : "false"
  exit 1 unless path_exists

  print "sync .. "
  stat = zk.exists(:path => ZK_PATH)
  puts "done."

  print "async .. "
  callback = ZooKeeper::StatCallback.new
  rc = zk.exists(:path => ZK_PATH, :callback => callback, :context => "yum")
  if rc != ZooKeeper::ZOK
    puts "async failed with code #{rc}"
    exit 1
  end
  print "waiting for callback .. "
  wait_until { callback.completed? }
  puts "done."

  puts "sync returned #{stat ? stat : 'nil'}"
  puts "async callback.return_code #{callback.return_code}"
  exit 1 if ( stat.nil? or rc != ZooKeeper::ZOK )
  puts "async callback.context #{callback.context}"

  printf("%15s %3s %22s %22s\n", "attr", "??", "sync", "async")
  printf("%15s %3s %22s %22s\n", "----", "--", "----", "-----")
  STAT_ATTRS.each do |attr|
    mstr = stat[attr] == callback.stat[attr] ? "OK" : "--"
    printf("%15s %3s %22s %22s\n", attr, mstr, stat[attr], callback.stat[attr])
  end

  zk.close
  wait_until { zk.closed? }
end

