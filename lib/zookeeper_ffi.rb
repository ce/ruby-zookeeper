# additional stuff that is missing in generated/zookeeper_wrap goes here...
module ZooKeeperFFI
  ZOOKEEPER_WRITE = 1
  ZOOKEEPER_READ  = 2

  ZOO_EPHEMERAL   = 1
  ZOO_SEQUENCE    = 2

  ZOO_CLOSED_STATE          = 0
  ZOO_CONNECTING_STATE      = 1
  ZOO_ASSOCIATING_STATE     = 2
  ZOO_CONNECTED_STATE       = 3
  ZOO_EXPIRED_SESSION_STATE = -112
  ZOO_AUTH_FAILED_STATE_DEF = -113
  ZOO_INVALID_ACL           = -114

  ZOO_ERROR_EVENT       = 0
  ZOO_CREATED_EVENT     = 1
  ZOO_DELETED_EVENT     = 2
  ZOO_CHANGED_EVENT     = 3
  ZOO_CHILD_EVENT       = 4
  ZOO_SESSION_EVENT     = -1
  ZOO_NOTWATCHING_EVENT = -2

  ZOO_PERM_READ   = 0x01
  ZOO_PERM_WRITE  = 0x02
  ZOO_PERM_CREATE = 0x04
  ZOO_PERM_DELETE = 0x08
  ZOO_PERM_ADMIN  = 0x10
  ZOO_PERM_ALL    = 0x1f

  def event_by_value(v)
    ZooKeeperFFI::constants.each do |c|
      next unless c =~ /^ZOO..*EVENT$/
      if eval("ZooKeeperFFI::#{c}") == v
        return c
      end
    end
  end

  class ACL
    def eql?(other)
      perms == other.perms and scheme == other.scheme and id == other.id
    end
    def perms
      self[:perms]
    end
    def scheme
      self[:id][:scheme].read_string
    end
    def id
      self[:id][:id].read_string
    end
    def to_hash
      { :perms => perms, :scheme => scheme, :id => id }
    end
  end

  class ACLVector
    def eql?(other)
      #puts "--- ACLVector#eql? --------------"
      #puts "self  #{self.inspect} #{self[:count]} "#{self.to_array}"
      #puts "other #{other.inspect} #{other[:count]} #{other.to_array}"
      return false unless self[:count] == other[:count]
      self.to_array.eql? other.to_array
    end
    def to_array
      rval = []
      self[:count].times do |x|
        ## FIXME: make work for ACLVectors with multiple ACLs
        ## FIXME: allocation in here is dumb dumb dumb
        #puts "self[:data] #{self[:data].inspect}"
        next if self[:data].null?
        rval << ACL.new(self[:data]).to_hash
      end
      rval
    end
    def to_s
      self.to_array.to_s
    end
  end

  module ACLVectors
    # Until I can find a feasible way to have a const ACLVector survive the GC,
    # having functions instantiating new ACLVectors will do.
    # Not ideal, but does the trick preventing segfaults.
    # -Ruben

    #static struct ACL _OPEN_ACL_UNSAFE_ACL[] = {{0x1f, {"world", "anyone"}}};
    #struct ACL_vector ZOO_OPEN_ACL_UNSAFE = { 1, _OPEN_ACL_UNSAFE_ACL};
    def self.openACLUnsafe
      acl = ACL.new(FFI::MemoryPointer.new(ACL))
      acl[:perms] = ZOO_PERM_ALL
      acl[:id].scheme = "world"
      acl[:id].id = "anyone"

      acl_vtr = ACLVector.new
      acl_vtr[:count] = 1
      acl_vtr[:data] = acl

      return acl_vtr
    end

    #static struct ACL _READ_ACL_UNSAFE_ACL[] = {{0x01, {"world", "anyone"}}};
    #struct ACL_vector ZOO_READ_ACL_UNSAFE = { 1, _READ_ACL_UNSAFE_ACL};
    def self.readACLUnsafe
      acl = ACL.new(FFI::MemoryPointer.new(ACL))
      acl[:perms] = ZOO_PERM_READ
      acl[:id].scheme = "world"
      acl[:id].id = "anyone"

      acl_vtr = ACLVector.new
      acl_vtr[:count] = 1
      acl_vtr[:data] = acl

      return acl_vtr
    end

    #static struct ACL _CREATOR_ALL_ACL_ACL[] = {{0x1f, {"auth", ""}}};
    #struct ACL_vector ZOO_CREATOR_ALL_ACL = { 1, _CREATOR_ALL_ACL_ACL};
    def self.creatorACLUnsafe
      acl = ACL.new(FFI::MemoryPointer.new(ACL))
      acl[:perms] = ZOO_PERM_ALL
      acl[:id].scheme = "auth"
      acl[:id].id = ""

      acl_vtr = ACLVector.new
      acl_vtr[:count] = 1
      acl_vtr[:data] = acl

      return acl_vtr
    end
  end
end
