$LOAD_PATH.unshift(File.join(File.dirname(__FILE__)))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'generated'))
require 'rubygems'
require 'ffi'
require 'zookeeper_wrap'
require 'zookeeper_ffi'

# require 'zookeeper/id'
# require 'zookeeper/permission'
# require 'zookeeper/acl'
# require 'zookeeper/stat'
require 'zookeeper/zookeeper'
require 'zookeeper/keeper_exception'
require 'zookeeper/callbacks'
# require 'zookeeper/watcher_event'
# require 'zookeeper/sync_primitive'
# require 'zookeeper/queue'
# require 'zookeeper/logging'

ENV['RUBY_MRI_VERSION'] = RUBY_VERSION unless defined?(JRUBY_VERSION)
