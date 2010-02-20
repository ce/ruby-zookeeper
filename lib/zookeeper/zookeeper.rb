require 'yaml'
## NOTE: blindly YAML.dump'ing contexts means that the data passed into
## ZK C is always a string and never nil.  This is artificial, but might
## be OK because contexts are inherently artificial from ZK's pov.

class ZooKeeper
  include ZooKeeperFFI

  DEFAULTS = {
    :timeout => 10000
  }

  def initialize(args)
    # TODO: allow authentication when passing :session_passwd
    args  = {:host => args} unless args.is_a?(Hash)
    args.replace(DEFAULTS.merge(args)) # reverse merge default options
    assert_supported_keys(args, [:host, :watcher, :timeout, :session_id])
    assert_required_keys(args, [:host])

    @zk_handle = zookeeper_init(args[:host], args[:watcher], args[:timeout], args[:session_id], nil, 0)
  end

  def close
    zookeeper_close(@zk_handle) if connected?
  end

  def state
    zoo_state(@zk_handle)
  end

  def connected?
    state == ZOO_CONNECTED_STATE
  end

  def closed?
    state == ZOO_CLOSED_STATE
  end

  def recv_timeout
    zoo_recv_timeout(@zk_handle)
  end

  # Set the global watcher
  def set_watcher(watcher)
    zoo_set_watcher(@zk_handle, watcher)
  end

  def self.debug_level=(level)
    ZooKeeperFFI.zoo_set_debug_level(level)
  end

  # create a znode,
  #  synchronously or asynchronously
  #
  # arguments
  # * :path (required)
  # * :data
  # * :acl
  # * :ephemeral (this znode will be removed when client disconnects)
  # * :sequence (ZK will append a unique, sequential, 10 digit number to path)
  # * :callback (StringCallback, if set call will be asynchronous)
  # * :context
  #
  def create(args)
    args = {:path => args} unless args.is_a?(Hash)
    assert_supported_keys(args, [:path, :data, :acl, :ephemeral, :sequence, :callback, :context])
    assert_required_keys(args, [:path])

    flags = 0
    flags |= ZOO_EPHEMERAL if args[:ephemeral]
    flags |= ZOO_SEQUENCE  if args[:sequence]

    data_len = args[:data] ? args[:data].length : -1

    ## FIXME: this is wrong, but convenient for now
    args[:acl] ||= ACLVectors.openACLUnsafe

    if args[:callback] ## asynchronous
      raise KeeperException::BadArguments unless args[:callback].kind_of?(StringCallback)
      return zoo_acreate(@zk_handle, args[:path], args[:data], data_len, args[:acl], flags, args[:callback].proc, YAML.dump(args[:context]))
    end

    ## synchronous
    # allocate memory for returned path value.  pad 10b for ZOO_SEQUENCE
    # ...does ZK accept unicode in paths?
    path_len = args[:path].size + 1
    path_len += 10 if args[:sequence] == true
    path_ptr = FFI::MemoryPointer.new(:char, path_len)

    rc = zoo_create(@zk_handle, args[:path], args[:data], data_len, args[:acl], flags, path_ptr, path_len)
    raise KeeperException.by_code(rc), ZooKeeperFFI::zerror(rc) unless rc == ZOK
    return path_ptr.read_string
  end

  # get/read a znode,
  #  synchronously or asynchronously,
  #  optionally set a watcher on the path
  #
  # arguments
  # * :path (required)
  # * :callback (StatCallback, if set call will be asynchronous)
  # * :context
  # * :watcher
  # * :watcher_context
  #
  def get(args)
    args = {:path => args} unless args.is_a?(Hash)
    assert_supported_keys(args, [:path, :watcher, :watcher_context, :callback, :context])
    assert_required_keys(args, [:path])

    if args[:callback] ## asynchronous
      raise KeeperException::BadArguments unless args[:callback].kind_of?(DataCallback)
      #puts "\n---------- calling zoo_awget -------"
      #puts "@zk_handle is #{@zk_handle.inspect}"
      #puts "args[:path] is #{args[:path].inspect}"
      #puts "args[:watcher] is #{args[:watcher].inspect}"
      #puts "args[:watcher_context] is #{args[:watcher_context].inspect}"
      #puts "args[:callback] is #{args[:callback].inspect}"
      #puts "args[:callback].proc is #{args[:callback].proc.inspect}"
      #puts "args[:context] is #{args[:context].inspect}"
      #puts "----------"
      return zoo_awget(@zk_handle, args[:path], args[:watcher], YAML.dump(args[:watcher_context]), args[:callback].proc, YAML.dump(args[:context]))
    end

    ## synchronous
    buf_len = 1024
    buf_ptr = FFI::MemoryPointer.new(:char, buf_len)
    buf_len_ptr = FFI::Buffer.alloc_inout(:int)
    buf_len_ptr.put_int(0, buf_len)
    stat = Stat.new(FFI::MemoryPointer.new(Stat))
    rc = zoo_wget(@zk_handle, args[:path], args[:watcher], YAML.dump(args[:watcher_context]), buf_ptr, buf_len_ptr, stat)
    raise KeeperException.by_code(rc), ZooKeeperFFI::zerror(rc) unless rc == ZOK
    value = buf_ptr.get_bytes(0, buf_len_ptr.get_int(0))
    return [value, stat]
  end

  # set/update a znode,
  #  synchronously or asynchronously
  #
  # arguments
  # * :path (required)
  # * :data
  # * :version
  # * :callback (StatCallback, if set call will be asynchronous)
  # * :context
  #
  # returns
  # * return_code
  # * stat object of resulting znode
  #
  def set(args)
    args = {:path => args} unless args.is_a?(Hash)
    assert_supported_keys(args, [:path, :data, :version, :callback, :context])
    assert_required_keys(args, [:path])
    args[:version] ||= -1

    data_len = args[:data] ? args[:data].length : -1

    if args[:callback] ## asynchronous
      raise KeeperException::BadArguments unless args[:callback].kind_of?(StatCallback)
      return zoo_aset(@zk_handle, args[:path], args[:data], data_len, args[:version], args[:callback].proc, YAML.dump(args[:context]))
    end

    ## synchronous
    rc = zoo_set(@zk_handle, args[:path], args[:data], data_len, args[:version])
    raise KeeperException.by_code(rc), ZooKeeperFFI::zerror(rc) unless rc == ZOK
    return rc
  end

  # delete a znode,
  #  synchronously or asynchronously
  #
  # arguments
  # * :path (required)
  # * :version
  # * :callback (VoidCallback, if set call will be asynchronous)
  # * :context
  #
  def delete(args)
    args = {:path => args} unless args.is_a?(Hash)
    assert_supported_keys(args, [:path, :version, :callback, :context])
    assert_required_keys(args, [:path])
    args[:version] ||= -1

    if args[:callback] ## asynchronous
      raise KeeperException::BadArguments unless args[:callback].kind_of?(VoidCallback)
      return zoo_adelete(@zk_handle, args[:path], args[:version], args[:callback].proc, YAML.dump(args[:context]))
    end

    ## synchronous
    rc = zoo_delete(@zk_handle, args[:path], args[:version])
    raise KeeperException.by_code(rc), ZooKeeperFFI::zerror(rc) unless rc == ZOK
    return rc
  end

  # check for existence of a znode,
  #  synchronously or asynchronously,
  #  optionally set a watcher on the path
  #
  # arguments
  # * :path (required)
  # * :callback (StatCallback, if set call will be asynchronous)
  # * :context
  # * :watcher
  # * :watcher_context
  #
  def exists(args)
    args = {:path => args} unless args.is_a?(Hash)
    assert_supported_keys(args, [:path, :watcher, :watcher_context, :callback, :context])
    assert_required_keys(args, [:path])

    if args[:callback] ## asynchronous
      raise KeeperException::BadArguments unless args[:callback].kind_of?(StatCallback)
      return zoo_awexists(@zk_handle, args[:path], args[:watcher], YAML.dump(args[:watcher_context]), args[:callback].proc, YAML.dump(args[:context]))
    end

    ## synchronous
    stat = Stat.new(FFI::MemoryPointer.new(Stat))
    rc = zoo_wexists(@zk_handle, args[:path], args[:watcher], YAML.dump(args[:watcher_context]), stat)
    return nil if rc == ZNONODE
    raise KeeperException.by_code(rc), ZooKeeperFFI::zerror(rc) unless rc == ZOK
    return stat
  end
  alias stat exists

  # boolean exists
  def exists?(args)
    args = {:path => args} unless args.is_a?(Hash)
    assert_supported_keys(args, [:path])
    assert_required_keys(args, [:path])
    exists(args).kind_of?(Stat)
  end

  # get_children of znode,
  #  synchronously or asynchronously,
  #  optionally set a watcher on the path
  #
  # arguments
  # * :path (required)
  # * :callback (StringCallback, if set call will be asynchronous)
  # * :context
  # * :watcher
  # * :watcher_context
  #
  def get_children(args)
    args = {:path => args} unless args.is_a?(Hash)
    assert_supported_keys(args, [:path, :watcher, :watcher_context, :callback, :context])
    assert_required_keys(args, [:path])

    if args[:callback] ## asynchronous
      raise KeeperException::BadArguments unless args[:callback].kind_of?(StringsCallback)
      #puts "\n---------- calling zoo_awget_children -------"
      #puts "@zk_handle is #{@zk_handle.inspect}"
      #puts "args[:path] is #{args[:path].inspect}"
      #puts "args[:watcher] is #{args[:watcher].inspect}"
      #puts "args[:watcher_context] is #{args[:watcher_context].inspect}"
      #puts "args[:callback] is #{args[:callback].inspect}"
      #puts "args[:callback].proc is #{args[:callback].proc.inspect}"
      #puts "args[:context] is #{args[:context].inspect}"
      #puts "----------"
      return zoo_awget_children(@zk_handle, args[:path], args[:watcher], YAML.dump(args[:watcher_context]), args[:callback].proc, YAML.dump(args[:context]))
    end

    ## synchronous
    str_v = StringVector.new(FFI::MemoryPointer.new(StringVector))
    rc = zoo_wget_children(@zk_handle, args[:path], args[:watcher], YAML.dump(args[:watcher_context]), str_v)
    children = str_v[:data].read_array_of_pointer(str_v[:count]).map do |s|
      s.read_string
    end
    raise KeeperException.by_code(rc), ZooKeeperFFI::zerror(rc) unless rc == ZOK
    return children
  end
  alias children get_children

  # get ACL of znode,
  #  synchronously or asynchronously
  #
  # arguments
  # * :path (required)
  # * :callback (ACLCallback, if set call will be asynchronous)
  # * :context
  #
  def get_acl(args)
    args = {:path => args} unless args.is_a?(Hash)
    assert_supported_keys(args, [:path, :callback, :context])
    assert_required_keys(args, [:path])

    if args[:callback] ## asynchronous
      raise KeeperException::BadArguments unless args[:callback].kind_of?(ACLCallback)
      return zoo_aget_acl(@zk_handle, args[:path], args[:callback].proc, YAML.dump(args[:context]))
    end

    ## synchronous
    acl_v = ACLVector.new(FFI::MemoryPointer.new(ACLVector))
    stat = Stat.new(FFI::MemoryPointer.new(Stat))
    rc = zoo_get_acl(@zk_handle, args[:path], acl_v, stat)
    raise KeeperException.by_code(rc), ZooKeeperFFI::zerror(rc) unless rc == ZOK
    #return acl, stat
    return acl_v
  end
  alias acls get_acl
  alias acl get_acl

  # set ACL of znode,
  #  synchronously or asynchronously
  #
  # arguments
  # * :path (required)
  # * :acl (required)
  # * :version
  # * :callback (ACLCallback, if set call will be asynchronous)
  # * :context
  #
  def set_acl(args)
    args = {:path => args} unless args.is_a?(Hash)
    assert_supported_keys(args, [:path, :acl, :version, :callback, :context])
    assert_required_keys(args, [:path, :acl])
    args[:version] ||= -1

    if args[:callback] ## asynchronous
      raise KeeperException::BadArguments unless args[:callback].kind_of?(ACLCallback)
      return zoo_aset_acl(@zk_handle, args[:path], args[:version], args[:acl], args[:callback].proc, YAML.dump(args[:context]))
    end

    ## synchronous
    rc = zoo_set_acl(@zk_handle, args[:path], args[:version], args[:acl])
    raise KeeperException.by_code(rc), ZooKeeperFFI::zerror(rc) unless rc == ZOK
    return rc
  end

  def not_yet_implemented(*args)
    self.not_yet_implemented
  end

  ## global watcher
  alias set_watcher not_yet_implemented
  alias get_context not_yet_implemented
  alias set_context not_yet_implemented
  ## misc
  alias is_unrecoverable not_yet_implemented
  alias client_id not_yet_implemented
  alias add_auth not_yet_implemented

  ## unknown
  alias async not_yet_implemented

  ## n/a, single-threaded only
  alias interest not_yet_implemented
  alias process not_yet_implemented

  def self.not_yet_implemented(*args)
    raise "this zookeeper function is not yet implemented in the Ruby bindings"
  end
  class << self
    alias set_log_stream not_yet_implemented
    alias zoo_deterministic_conn_order not_yet_implemented  ## arg to init?
  end

  private

  def assert_supported_keys(args, supported)
    unless (args.keys - supported).empty?
      raise KeeperException::BadArguments, "Supported arguments are: #{supported.inspect}, but arguments #{args.keys.inspect} were supplied instead"
    end
  end

  def assert_required_keys(args, required)
    unless (required - args.keys).empty?
      raise KeeperException::BadArguments, "Required arguments are: #{required.inspect}, but only the arguments #{args.keys.inspect} were supplied."
    end
  end
end
