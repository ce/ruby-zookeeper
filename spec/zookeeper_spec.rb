require File.join(File.dirname(__FILE__), %w[spec_helper])

describe ZooKeeper, " client" do
  it "should establish connection to the ZooKeeper server" do
    @zk.connected?.should == true
  end

  it "should return Fixnum value from recv_timeout" do
    @zk.recv_timeout.class.should == Fixnum
  end
end

describe ZooKeeper, "#create" do
  before(:each) do
    @node_path = "/node#{$num}"
    @node_data = "test_data#{$num}"
  end

  it "should raise BadArguments exception when called with bad args" do
    lambda { @zk.create(:this => "is a bad arg", :and => "so is this") }.should raise_error(KeeperException::BadArguments)
  end

  it "should raise NodeExists if path exists" do
    @zk.create(:path => @node_path, :data => @node_data).should == @node_path
    lambda { @zk.create(:path => @node_path, :data => @node_data) }.should raise_error(KeeperException::NodeExists)
  end

  it "should create a znode" do
    @zk.create(:path => @node_path, :data => @node_data).should == @node_path
  end

  it "should create a znode with sequence id in path if called with :sequence" do
    @node_path += "-seq"
    @zk.create(:path => @node_path, :data => @node_data, :sequence => true).should =~ /#{@node_path}\d{10}/
  end

  it "should create a znode which is removed when client session ends if called with :ephemeral" do
    @node_path += "-ephemeral"
    @zk2 = ZooKeeper.new(:host => ZOO_TEST)
    wait_until { @zk2.connected? }
    @zk2.create(:path => @node_path, :data => @node_data, :ephemeral => true)
    @zk.exists?(@node_path).should be_true
    @zk2.close
    wait_until { @zk2.closed? }
    sleep 0.5 ## without this pause, spec has ~10% failure rate
    @zk.exists?(@node_path).should be_false
  end

  it "should create a child znode" do
    @zk.create(:path => @node_path, :data => @node_data).should == @node_path
    child_path = "#{@node_path}/child"
    @zk.create(:path => child_path, :data => "child").should == child_path
    @zk.exists?(child_path).should be_true
  end

  it "should create sequential child znodes if called with :sequence" do
    @zk.create(:path => @node_path, :data => @node_data).should == @node_path
    child_path = "#{@node_path}/child"
    child1 = @zk.create(:path => child_path, :data => "ch1", :sequence => true)
    child2 = @zk.create(:path => child_path, :data => "ch2", :sequence => true)
    child1.should =~ /#{child_path}\d{10}/
    child2.should =~ /#{child_path}\d{10}/
    @zk.get_children(@node_path).sort.should eql([ child1.sub(/#{@node_path}\//, ''), child2.sub(/#{@node_path}\//, '')])
  end
end

describe ZooKeeper, "#create async" do
  before(:each) do
    @node_path = "/node#{$num}"
    @node_data = "test_data#{$num}"
  end

  it "should not crash the interpreter when callback has a block" do
    callback = ZooKeeper::StringCallback.new { sleep 1 }
    @zk.create(:path => @node_path, :data => @node_data, :callback => callback)
    wait_until { callback.completed? }
  end

  it "should invoke callback with results" do
    callback = ZooKeeper::StringCallback.new
    context = "This is some context"

    @zk.create(:path => @node_path, :data => @node_data, :callback => callback, :context => context)
    wait_until { callback.completed? }
    callback.return_code.should == ZooKeeper::ZOK
    callback.path.should == @node_path
    callback.context.should == context
  end

  it "callback.return_code should be ZNODEEXISTS if path exists" do
    @zk.create(:path => @node_path, :data => @node_data)
    callback = ZooKeeper::StringCallback.new
    context = "This is some context"

    @zk.create(:path => @node_path, :data => @node_data, :callback => callback, :context => context)
    wait_until { callback.completed? }
    callback.return_code.should == ZooKeeper::ZNODEEXISTS
  end
end

describe ZooKeeper, "#exists" do
  before(:each) do
    @node_path = "/node#{$num}"
    @nonode_path = "/node#{$num}-nonexistent"
    @node_data = "test_data#{$num}"
    @zk.create(:path => @node_path, :data => @node_data)
  end

  it "should return false from boolean exists if path is nonexistent" do
    @zk.exists?(@nonode_path).should be_false
  end

  it "should return nil if path is nonexistent" do
    @zk.exists(@nonode_path).should be_nil
  end

  it "should return true from boolean exists if path exists" do
    @zk.exists?(@node_path).should be_true
  end

  it "should return Stat data if path exists" do
    stat = @zk.exists(@node_path)
    stat.should be_instance_of(ZooKeeper::Stat)
    stat[:ctime].should_not == 0
    ## TODO: check other values in Stat
  end
end

describe ZooKeeper, "#exists async" do
  before(:each) do
    @node_path = "/node#{$num}"
    @nonode_path = "/node#{$num}-nonexistent"
    @node_data = "test_data#{$num}"
    @zk.create(:path => @node_path, :data => @node_data)
  end

  it "should not crash the interpreter when callback has a block" do
    callback = ZooKeeper::StatCallback.new { sleep 1 }
    @zk.exists(:path => @node_path, :callback => callback)
    wait_until { callback.completed? }
  end

  it "callback.return_code should be ZNONODE if path is nonexistent" do
    callback = ZooKeeper::StatCallback.new
    @zk.exists?(:path => @nonode_path).should == false
    @zk.exists(:path => @nonode_path, :callback => callback)
    wait_until { callback.completed? }
    callback.return_code.should == ZooKeeper::ZNONODE
  end

  it "callback.stat should be set if path exists" do
    callback = ZooKeeper::StatCallback.new
    context = "a dark and stormy night"
    @zk.exists(:path => @node_path, :callback => callback, :context => context)
    wait_until { callback.completed? }
    callback.return_code.should == ZooKeeper::ZOK
    callback.context.should == context
    callback.stat.should be_instance_of(ZooKeeper::Stat)
    callback.stat[:ctime].should_not == 0
    callback.stat[:dataLength].should == @node_data.length
  end
end

describe ZooKeeper, "#get" do
  before(:each) do
    @node_path = "/node#{$num}"
    @nonode_path = "/node#{$num}-nonexistent"
    @node_data = "test_data#{$num}"
    @zk.create(:path => @node_path, :data => @node_data)
  end

  it "should raise NoNode if path is nonexistent" do
    lambda { @zk.get(@nonode_path) }.should raise_error(KeeperException::NoNode)
  end

  it "should return data and Stat if path exists" do
    data, stat = @zk.get(:path => @node_path)
    data.should == @node_data
    stat.should be_instance_of(ZooKeeper::Stat)
    stat[:ctime].should_not == 0
  end
end

describe ZooKeeper, "#get async" do
  before(:each) do
    @node_path = "/node#{$num}"
    @nonode_path = "/node#{$num}-nonexistent"
    @node_data = "test_data#{$num}"
    @zk.create(:path => @node_path, :data => @node_data)
  end

  it "should not crash the interpreter when callback has a block" do
    callback = ZooKeeper::DataCallback.new { sleep 1 }
    @zk.get(:path => @node_path, :callback => callback)
    wait_until { callback.completed? }
  end

  it "callback.return_code should be ZNONODE if path is nonexistent" do
    callback = ZooKeeper::DataCallback.new
    rc = @zk.get(:path => @nonode_path, :callback => callback)
    rc.should == ZooKeeper::ZOK
    wait_until { callback.completed? }
    callback.return_code.should == ZooKeeper::ZNONODE
  end

  it "callback.stat and other data should be set if path exists" do
    callback = ZooKeeper::DataCallback.new
    context = "somecontext"
    @zk.get(:path => @node_path, :callback => callback, :context => context)
    wait_until { callback.completed? }
    callback.return_code.should == ZooKeeper::ZOK
    callback.value_len.should == @node_data.length
    callback.context.should == context
    callback.stat.should be_instance_of(ZooKeeper::Stat)
    callback.stat[:ctime].should_not == 0
    callback.stat[:dataLength].should == @node_data.length
  end
end

describe ZooKeeper, "#set" do
  before(:each) do
    @node_path = "/node#{$num}"
    @nonode_path = "/node#{$num}-nonexistent"
    @node_data = "test_data#{$num}"
    @zk.create(:path => @node_path, :data => @node_data)
  end

  it "should raise NoNode if path is nonexistent" do
    lambda { @zk.set(:path => @nonode_path, :data => @node_data) }.should raise_error(KeeperException::NoNode)
  end

  it "should update znode data" do
    data = "new_data#{$num}"
    @zk.set(:path => @node_path, :data => data)
    @zk.get(@node_path).first.should == data
  end

  it "should not update znode if version arg doesn't match" do
    @zk.set(:path => @node_path, :data => @node_data, :version => 0)
    stat = @zk.exists(@node_path)
    stat[:version].should == 1
    lambda { @zk.set(:path => @node_path, :data => @node_data, :version => 99) }.should raise_error(KeeperException::BadVersion)
  end

  it "should increment znode version data" do
    (1..100).each do |x|
      @zk.set(:path => @node_path, :data => "#{@node_data}-v#{x}")
      stat = @zk.exists(@node_path)
      stat[:version].should == x
    end
  end
end

describe ZooKeeper, "#set async" do
  before(:each) do
    @node_path = "/node#{$num}"
    @nonode_path = "/node#{$num}-nonexistent"
    @node_data = "test_data#{$num}"
    @zk.create(:path => @node_path, :data => @node_data)
  end

  it "should not crash the interpreter when callback has a block" do
    callback = ZooKeeper::StatCallback.new { sleep 1 }
    @zk.set(:path => @node_path, :data => @node_data, :callback => callback)
    wait_until { callback.completed? }
  end

  it "should update existing znode data and execute callback" do
    callback = ZooKeeper::StatCallback.new
    context = Time.now
    @zk.set(:path => @node_path, :data => @node_data, :callback => callback, :context => context)
    @zk.get(@node_path).first.should == @node_data
    wait_until { callback.completed? }
    callback.return_code.should == ZooKeeper::ZOK
    callback.context.should == context
    callback.stat.should be_instance_of(ZooKeeper::Stat)
    callback.stat[:ctime].should_not == 0
    callback.stat[:dataLength].should == @node_data.length
  end

  it "callback.return_code should be ZNONODE if path is nonexistent" do
    callback = ZooKeeper::StatCallback.new
    @zk.set(:path => @nonode_path, :data => @node_data, :callback => callback)
    wait_until { callback.completed? }
    callback.return_code.should == ZooKeeper::ZNONODE
  end
end

describe ZooKeeper, "#delete" do
  before(:each) do
    @node_path = "/node#{$num}"
    @nonode_path = "/node#{$num}-nonexistent"
    @node_data = "test_data#{$num}"
    @zk.create(:path => @node_path, :data => @node_data)
  end

  it "should raise NoNode if path is nonexistent" do
    lambda { @zk.delete(@nonode_path) }.should raise_error(KeeperException::NoNode)
  end

  it "should delete a znode" do
    @zk.delete(@node_path)
    @zk.exists?(@node_path).should be_false
  end

  it "should not delete znode if version arg doesn't match" do
    lambda { @zk.delete(:path => @node_path, :version => 99) }.should raise_error(KeeperException::BadVersion)
    @zk.delete(:path => @node_path, :version => 0)
    @zk.exists(@node_path).should be_nil
  end
end

describe ZooKeeper, "#delete async" do
  before(:each) do
    @node_path = "/existent-node#{$num}"
    @node_data = "test_data#{$num}"
    @nonode_path = "/node#{$num}-nonexistent"
    @zk.create(:path => @node_path, :data => @node_data)
  end

  it "should not crash the interpreter when callback has a block" do
    callback = ZooKeeper::VoidCallback.new { sleep 1 }
    @zk.delete(:path => @node_path, :callback => callback)
    wait_until { callback.completed? }
  end

  it "should delete a znode and execute callback" do
    callback = ZooKeeper::VoidCallback.new
    context = Time.now
    @zk.delete(:path => @node_path, :callback => callback, :context => context)
    wait_until { callback.completed? }
    callback.return_code.should == ZooKeeper::ZOK
    callback.context.should == context
    @zk.exists?(@node_path).should be_false
  end

  it "callback.return_code should be ZNONODE if path is nonexistent" do
    callback = ZooKeeper::VoidCallback.new
    @zk.delete(:path => @nonode_path, :callback => callback)
    wait_until { callback.completed? }
    callback.return_code.should == ZooKeeper::ZNONODE
  end
end

describe ZooKeeper, "#get_children" do
  before(:each) do
    @node_path = "/node#{$num}"
    @node_data = "test_data#{$num}"
    @nonode_path = "/node#{$num}-nonexistent"
    @parent_path = "/parent-node#{$num}"
    @zk.create(:path => @parent_path, :data => @node_data)
    @child_name = ('a'..'f').map { |x| "child#{$num}#{x}" }
    @child_name.map { |name| "#{@parent_path}/#{name}" }.each do |path|
      @zk.create(:path => path, :data => "progeny")
    end
  end

  it "should raise NoNode if path is nonexistent" do
    lambda { @zk.get_children(@nonode_path) }.should raise_error(KeeperException::NoNode)
  end

  it "should return an empty list if znode is childless" do
    @zk.create(:path => @node_path, :data => @node_data)
    @zk.get_children(@node_path).should be_empty
  end

  it "should return child list if znode has children" do
    kids = @zk.get_children(@parent_path).sort
    kids.size.should == @child_name.size
    kids.first.should == @child_name.first
    kids.last.should == @child_name.last
  end
end

describe ZooKeeper, "#get_children async" do
  before(:each) do
    @node_path = "/node#{$num}"
    @node_data = "test_data#{$num}"
    @nonode_path = "/node#{$num}-nonexistent"
    @parent_path = "/parent-node#{$num}"
    @zk.create(:path => @parent_path, :data => @node_data)
    @child_name = ('a'..'f').map { |x| "child#{$num}#{x}" }
    @child_name.map { |name| "#{@parent_path}/#{name}" }.each do |path|
      @zk.create(:path => path, :data => "progeny")
    end
  end

  it "should not crash the interpreter when callback has a block" do
    callback = ZooKeeper::StringsCallback.new { sleep 1 }
    @zk.get_children(:path => @parent_path, :callback => callback)
    wait_until { callback.completed? }
  end

  it "callback.return_code should be ZNONODE if path is nonexistent" do
    callback = ZooKeeper::StringsCallback.new
    @zk.get_children(:path => @nonode_path, :callback => callback)
    wait_until { callback.completed? }
    callback.return_code.should == ZooKeeper::ZNONODE
  end

  it "callback.children should be empty if znode is childless" do
    @zk.create(:path => @node_path, :data => @node_data)
    callback = ZooKeeper::StringsCallback.new
    @zk.get_children(:path => @node_path, :callback => callback)
    wait_until { callback.completed? }
    callback.return_code.should == ZooKeeper::ZOK
    callback.children.should be_empty
  end

  it "callback.children should be set if znode has children" do
    callback = ZooKeeper::StringsCallback.new
    context = "CONTEXT_CANARY"
    @zk.get_children(:path => @parent_path, :callback => callback, :context => context).should == ZooKeeper::ZOK
    wait_until { callback.completed? }
    callback.return_code.should == ZooKeeper::ZOK
    #callback.path.should == @parent_path
    callback.context.should == context
    kids = callback.children.sort
    kids.size.should == @child_name.size
    kids.first.should == @child_name.first
    kids.last.should == @child_name.last
  end
end

describe ZooKeeper, "#get_acl" do
  before(:each) do
    @node_path = "/node#{$num}"
    @node_data = "test_data#{$num}"
    @nonode_path = "/node#{$num}-nonexistent"
  end

  it "should raise NoNode if path is nonexistent" do
    lambda { @zk.get_acl(@nonode_path) }.should raise_error(KeeperException::NoNode)
  end

  it "should return ACL of znode, which defaults to parent's" do
    @zk.create(:path => @node_path, :data => @node_data)
    @zk.get_acl(@node_path).should eql(@zk.get_acl('/'))
  end
end

describe ZooKeeper, "#get_acl async" do
  before(:each) do
    @node_path = "/node#{$num}"
    @node_data = "test_data#{$num}"
    @nonode_path = "/node#{$num}-nonexistent"
  end

  it "should not crash the interpreter when callback has a block" do
    callback = ZooKeeper::ACLCallback.new { sleep 1 }
    @zk.get_acl(:path => @node_path, :callback => callback)
    wait_until { callback.completed? }
  end

  it "should get ACL info asynchronously" do
    @zk.create(:path => @node_path, :data => @node_data)
    callback = ZooKeeper::ACLCallback.new
    context = Time.now
    @zk.acl(:path => @node_path, :callback => callback, :context => context)
    wait_until { callback.completed? }
    callback.return_code.should == 0
    callback.context.should == context
    callback.acl.should eql @zk.get_acl('/')
  end

  it "callback.return_code should be ZNONODE if path is nonexistent" do
    callback = ZooKeeper::ACLCallback.new
    @zk.get_acl(:path => @nonode_path, :callback => callback)
    wait_until { callback.completed? }
    callback.return_code.should == ZooKeeper::ZNONODE
  end
end

describe ZooKeeper, "#set_acl" do
  before(:each) do
    @node_path = "/node#{$num}"
    @nonode_path = "/node#{$num}-nonexistent"
    @node_data = "test_data#{$num}"
  end

  it "should raise NoNode if path is nonexistent" do
    ## FIXME: this ACLVectors.openACLUnsafe stuff is sketchy
    acl_v = ZooKeeperFFI::ACLVectors.openACLUnsafe
    lambda { @zk.set_acl(:path => @nonode_path, :acl => acl_v) }.should raise_error(KeeperException::NoNode)
  end

  it "should set new ACL if path exists" do
    @zk.create(:path => @node_path, :data => @node_data)
    acl_v = ZooKeeperFFI::ACLVectors.openACLUnsafe
    @zk.set_acl(:path => @node_path, :acl => acl_v)
    @zk.get_acl(:path => @node_path).should eql acl_v
  end
end

describe ZooKeeper, "#set_acl async" do
  before(:each) do
    @node_path = "/node#{$num}"
    @nonode_path = "/node#{$num}-nonexistent"
    @node_data = "test_data#{$num}"
  end

  it "should not crash the interpreter when callback has a block" do
    @zk.create(:path => @node_path, :data => @node_data)
    callback = ZooKeeper::ACLCallback.new { sleep 1 }
    acl_v = ZooKeeperFFI::ACLVectors.openACLUnsafe
    @zk.set_acl(:path => @node_path, :acl => acl_v, :callback => callback)
    wait_until { callback.completed? }
  end

  it "callback.return_code should be ZNONODE if path is nonexistent" do
    callback = ZooKeeper::ACLCallback.new
    acl_v = ZooKeeperFFI::ACLVectors.openACLUnsafe
    @zk.set_acl(:path => @nonode_path, :acl => acl_v, :callback => callback)
    wait_until { callback.completed? }
    callback.return_code.should == ZooKeeper::ZNONODE
  end

  it "should set new ACL asynchronously if path exists" do
    @zk.create(:path => @node_path, :data => @node_data)
    callback = ZooKeeper::ACLCallback.new
    acl_v = ZooKeeperFFI::ACLVectors.openACLUnsafe
    @zk.set_acl(:path => @node_path, :acl => acl_v, :callback => callback)
    wait_until { callback.completed? }
    @zk.get_acl(:path => @node_path).should eql acl_v
  end
end

describe ZooKeeper, "#create with :acl" do
  before(:all) do
    @zk2 = ZooKeeper.new(:host => ZOO_TEST)
    wait_until { @zk2.connected? }
  end

  after(:all) do
    @zk2.close
    wait_until { @zk2.closed? }
  end

  before(:each) do
    @node_path = "/node#{$num}"
    @node_data = "test_data#{$num}"
  end

#  it "should create a path with READ_ACL_UNSAFE permissions" do
#    #pending "wip"
#    @zk.create(:path => @node_path, :data => @node_data, :acl => ZooKeeper::ACL::READ_ACL_UNSAFE)
#    @zk.acl(@node_path).first.should == ZooKeeper::ACL::READ_ACL_UNSAFE
#  end

#  it "should create a path with CREATOR_ALL_ACL permissions" do
#    pending "wip"
#    @zk.add_auth_info(:scheme => "digest", :auth => "shane:password")
#    @zk.create(:path => @node_path, :data => @node_data, :acl => ZooKeeper::ACL::CREATOR_ALL_ACL)
#    @zk.acl(@node_path).first.should == [ZooKeeper::ACL.new(ZooKeeper::Permission::ALL | ZooKeeper::Permission::ADMIN,
#                                        ZooKeeper::Id.new('digest', 'shane:pgPxAF2N8U79uqcuGPQx3C6J2c8='))]
#  end

#  it "should set creator to read with CREATOR_ALL_ACL permissions" do
#    pending "wip"
#    @zk.add_auth_info(:scheme => "digest", :auth => "shane:password")
#    @zk.create(:path => @node_path, :data => @node_data, :acl => ZooKeeper::ACL::CREATOR_ALL_ACL)
#    #@zk2.add_auth_info(:scheme => "digest", :auth => "shane:password")
#    #@zk2.get(@node_path).first.should == @node_data
#  end

#  it "should create znode with CREATOR_ALL_ACL permissions if no authentcated ids present" do
#    #pending "wip"
#    lambda { @zk.create(:path => @node_path, :data => @node_data, :acl => ZooKeeper::ACL::CREATOR_ALL_ACL) }.should raise_error(KeeperException::InvalidACL)
#  end

#  it "should not allow world to read znode with CREATOR_ALL_ACL permissions" do
#    pending "wip"
#    @zk.add_auth_info(:scheme => "digest", :auth => "shane:password")
#    @zk.create(:path => @node_path, :data => @node_data, :acl => ZooKeeper::ACL::CREATOR_ALL_ACL)
#    lambda { @zk2.get(@node_path) }.should raise_error(KeeperException::NoAuth)
#  end

#  it "should allow world to read with READ_ACL_UNSAFE permissions" do
#    #pending "wip"
#    @zk.create(:path => @node_path, :data => @node_data, :acl => ZooKeeper::ACL::READ_ACL_UNSAFE)
#    @zk2.get(@node_path).first.should == @node_data
#  end

#  it "should not allow world to write with READ_ACL_UNSAFE permissions" do
#    #pending "wip"
#    @zk.create(:path => @node_path, :data => @node_data, :acl => ZooKeeper::ACL::READ_ACL_UNSAFE)
#    lambda { @zk2.set(:path => @node_path, :data => "new_data") }.should raise_error(KeeperException::NoAuth)
#  end
end

describe ZooKeeper, " watcher function" do
  before(:each) do
    @watcher = ZooKeeper::WatcherCallback.new { sleep 1 }
    @node_path = "/node#{$num}"
    @node_data = "test_data#{$num}"
    @zk2 = ZooKeeper.new(:host => ZOO_TEST)
    wait_until { @zk2.connected? }
    @zk.create(:path => @node_path, :data => @node_data)
  end

  after(:each) do
    @zk2.close
    wait_until { @zk2.closed? }
  end

  it "should fire when a znode is created" do
    @zk.exists(:path => "#{@node_path}-new", :watcher => @watcher)
    @zk2.create(:path => "#{@node_path}-new", :data => "la")
    wait_until { @watcher.completed? }
    @watcher.type.should == ZooKeeperFFI::ZOO_CREATED_EVENT
  end

  it "should fire when a znode is updated" do
    @zk.exists(:path => @node_path, :watcher => @watcher, :watcher_context => 'wheee' )
    @zk2.set(:path => @node_path, :data => "foo")
    wait_until { @watcher.completed? }
    @watcher.path.should == @node_path
    @watcher.type.should == ZooKeeperFFI::ZOO_CHANGED_EVENT
    ## TODO: check other attrs
  end

  it "should fire when a znode is deleted" do
    @zk.exists(:path => @node_path, :watcher => @watcher)
    @zk2.delete(:path => @node_path)
    wait_until { @watcher.completed? }
    @watcher.type.should == ZooKeeperFFI::ZOO_DELETED_EVENT
  end

  it "should fire when a child znode is created" do
    @zk.get_children(:path => @node_path, :watcher => @watcher)
    @zk2.create(:path => "#{@node_path}/child-seq", :data => "child1", :sequence => true, :ephemeral => true).should == "#{@node_path}/child-seq0000000000"
    wait_until { @watcher.completed? }
    @watcher.type.should == ZooKeeperFFI::ZOO_CHILD_EVENT
  end
end
