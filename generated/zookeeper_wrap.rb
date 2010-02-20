
module ZooKeeperFFI
  extend FFI::Library

  paths = Array(ENV['ZOOKEEPER_LIB'] || %w{
      /opt/local/lib/libzookeeper_mt.dylib
      /opt/local/lib/libzookeeper_mt.so
      /usr/local/lib/libzookeeper_mt.dylib
      /usr/local/lib/libzookeeper_mt.so
  })

  path = paths.find { |path| File.exist?(path) }

 raise "Couldn't find libzookeeper_mt in /opt/local/lib or /usr/local/lib" unless path
 ffi_lib(path)
  ZOO_MAJOR_VERSION = 3
  ZOO_MINOR_VERSION = 1
  ZOO_PATCH_VERSION = 1
  class Buffer < FFI::Struct
    layout(
           :len, :int,
           :buff, :pointer
    )
    def buff=(str)
      @buff = FFI::MemoryPointer.from_string(str)
      self[:buff] = @buff
    end
    def buff
      @buff.get_string(0)
    end

  end
  attach_function :deallocate_String, [ :pointer ], :void
  attach_function :deallocate_Buffer, [ :pointer ], :void
  class Iarchive < FFI::Struct
    layout(
           :start_record, callback([ :pointer, :string ], :int),
           :end_record, callback([ :pointer, :string ], :int),
           :start_vector, callback([ :pointer, :string, :pointer ], :int),
           :end_vector, callback([ :pointer, :string ], :int),
           :deserialize_Bool, callback([ :pointer, :string, :pointer ], :int),
           :deserialize_Int, callback([ :pointer, :string, :pointer ], :int),
           :deserialize_Long, callback([ :pointer, :string, :pointer ], :int),
           :deserialize_Buffer, callback([ :pointer, :string, :pointer ], :int),
           :deserialize_String, callback([ :pointer, :string, :pointer ], :int),
           :priv, :pointer
    )
    def start_record=(cb)
      @start_record = cb
      self[:start_record] = @start_record
    end
    def start_record
      @start_record
    end
    def end_record=(cb)
      @end_record = cb
      self[:end_record] = @end_record
    end
    def end_record
      @end_record
    end
    def start_vector=(cb)
      @start_vector = cb
      self[:start_vector] = @start_vector
    end
    def start_vector
      @start_vector
    end
    def end_vector=(cb)
      @end_vector = cb
      self[:end_vector] = @end_vector
    end
    def end_vector
      @end_vector
    end
    def deserialize_Bool=(cb)
      @deserialize_Bool = cb
      self[:deserialize_Bool] = @deserialize_Bool
    end
    def deserialize_Bool
      @deserialize_Bool
    end
    def deserialize_Int=(cb)
      @deserialize_Int = cb
      self[:deserialize_Int] = @deserialize_Int
    end
    def deserialize_Int
      @deserialize_Int
    end
    def deserialize_Long=(cb)
      @deserialize_Long = cb
      self[:deserialize_Long] = @deserialize_Long
    end
    def deserialize_Long
      @deserialize_Long
    end
    def deserialize_Buffer=(cb)
      @deserialize_Buffer = cb
      self[:deserialize_Buffer] = @deserialize_Buffer
    end
    def deserialize_Buffer
      @deserialize_Buffer
    end
    def deserialize_String=(cb)
      @deserialize_String = cb
      self[:deserialize_String] = @deserialize_String
    end
    def deserialize_String
      @deserialize_String
    end

  end
  class Oarchive < FFI::Struct
    layout(
           :start_record, callback([ :pointer, :string ], :int),
           :end_record, callback([ :pointer, :string ], :int),
           :start_vector, callback([ :pointer, :string, :pointer ], :int),
           :end_vector, callback([ :pointer, :string ], :int),
           :serialize_Bool, callback([ :pointer, :string, :pointer ], :int),
           :serialize_Int, callback([ :pointer, :string, :pointer ], :int),
           :serialize_Long, callback([ :pointer, :string, :pointer ], :int),
           :serialize_Buffer, callback([ :pointer, :string, :pointer ], :int),
           :serialize_String, callback([ :pointer, :string, :pointer ], :int),
           :priv, :pointer
    )
    def start_record=(cb)
      @start_record = cb
      self[:start_record] = @start_record
    end
    def start_record
      @start_record
    end
    def end_record=(cb)
      @end_record = cb
      self[:end_record] = @end_record
    end
    def end_record
      @end_record
    end
    def start_vector=(cb)
      @start_vector = cb
      self[:start_vector] = @start_vector
    end
    def start_vector
      @start_vector
    end
    def end_vector=(cb)
      @end_vector = cb
      self[:end_vector] = @end_vector
    end
    def end_vector
      @end_vector
    end
    def serialize_Bool=(cb)
      @serialize_Bool = cb
      self[:serialize_Bool] = @serialize_Bool
    end
    def serialize_Bool
      @serialize_Bool
    end
    def serialize_Int=(cb)
      @serialize_Int = cb
      self[:serialize_Int] = @serialize_Int
    end
    def serialize_Int
      @serialize_Int
    end
    def serialize_Long=(cb)
      @serialize_Long = cb
      self[:serialize_Long] = @serialize_Long
    end
    def serialize_Long
      @serialize_Long
    end
    def serialize_Buffer=(cb)
      @serialize_Buffer = cb
      self[:serialize_Buffer] = @serialize_Buffer
    end
    def serialize_Buffer
      @serialize_Buffer
    end
    def serialize_String=(cb)
      @serialize_String = cb
      self[:serialize_String] = @serialize_String
    end
    def serialize_String
      @serialize_String
    end

  end
  attach_function :create_buffer_oarchive, [  ], :pointer
  attach_function :close_buffer_oarchive, [ :pointer, :int ], :void
  attach_function :create_buffer_iarchive, [ :string, :int ], :pointer
  attach_function :close_buffer_iarchive, [ :pointer ], :void
  attach_function :get_buffer, [ :pointer ], :string
  attach_function :get_buffer_len, [ :pointer ], :int
  attach_function :htonll, [ :long_long ], :long_long
  class Id < FFI::Struct
    layout(
           :scheme, :pointer,
           :id, :pointer
    )
    def scheme=(str)
      @scheme = FFI::MemoryPointer.from_string(str)
      self[:scheme] = @scheme
    end
    def scheme
      @scheme.get_string(0)
    end
    def id=(str)
      @id = FFI::MemoryPointer.from_string(str)
      self[:id] = @id
    end
    def id
      @id.get_string(0)
    end

  end
  attach_function :serialize_Id, [ :pointer, :string, :pointer ], :int
  attach_function :deserialize_Id, [ :pointer, :string, :pointer ], :int
  attach_function :deallocate_Id, [ :pointer ], :void
  class ACL < FFI::Struct
    layout(
           :perms, :int,
           :id, Id
    )
  end
  attach_function :serialize_ACL, [ :pointer, :string, :pointer ], :int
  attach_function :deserialize_ACL, [ :pointer, :string, :pointer ], :int
  attach_function :deallocate_ACL, [ :pointer ], :void
  class Stat < FFI::Struct
    layout(
           :czxid, :long_long,
           :mzxid, :long_long,
           :ctime, :long_long,
           :mtime, :long_long,
           :version, :int,
           :cversion, :int,
           :aversion, :int,
           :ephemeralOwner, :long_long,
           :dataLength, :int,
           :numChildren, :int,
           :pzxid, :long_long
    )
  end
  attach_function :serialize_Stat, [ :pointer, :string, :pointer ], :int
  attach_function :deserialize_Stat, [ :pointer, :string, :pointer ], :int
  attach_function :deallocate_Stat, [ :pointer ], :void
  class StatPersisted < FFI::Struct
    layout(
           :czxid, :long_long,
           :mzxid, :long_long,
           :ctime, :long_long,
           :mtime, :long_long,
           :version, :int,
           :cversion, :int,
           :aversion, :int,
           :ephemeralOwner, :long_long,
           :pzxid, :long_long
    )
  end
  attach_function :serialize_StatPersisted, [ :pointer, :string, :pointer ], :int
  attach_function :deserialize_StatPersisted, [ :pointer, :string, :pointer ], :int
  attach_function :deallocate_StatPersisted, [ :pointer ], :void
  class StatPersistedV1 < FFI::Struct
    layout(
           :czxid, :long_long,
           :mzxid, :long_long,
           :ctime, :long_long,
           :mtime, :long_long,
           :version, :int,
           :cversion, :int,
           :aversion, :int,
           :ephemeralOwner, :long_long
    )
  end
  attach_function :serialize_StatPersistedV1, [ :pointer, :string, :pointer ], :int
  attach_function :deserialize_StatPersistedV1, [ :pointer, :string, :pointer ], :int
  attach_function :deallocate_StatPersistedV1, [ :pointer ], :void
  class OpResultT < FFI::Struct
    layout(
           :rc, :int,
           :op, :int,
           :response, Buffer
    )
  end
  attach_function :serialize_op_result_t, [ :pointer, :string, :pointer ], :int
  attach_function :deserialize_op_result_t, [ :pointer, :string, :pointer ], :int
  attach_function :deallocate_op_result_t, [ :pointer ], :void
  class ConnectRequest < FFI::Struct
    layout(
           :protocolVersion, :int,
           :lastZxidSeen, :long_long,
           :timeOut, :int,
           :sessionId, :long_long,
           :passwd, Buffer
    )
  end
  attach_function :serialize_ConnectRequest, [ :pointer, :string, :pointer ], :int
  attach_function :deserialize_ConnectRequest, [ :pointer, :string, :pointer ], :int
  attach_function :deallocate_ConnectRequest, [ :pointer ], :void
  class ConnectResponse < FFI::Struct
    layout(
           :protocolVersion, :int,
           :timeOut, :int,
           :sessionId, :long_long,
           :passwd, Buffer
    )
  end
  attach_function :serialize_ConnectResponse, [ :pointer, :string, :pointer ], :int
  attach_function :deserialize_ConnectResponse, [ :pointer, :string, :pointer ], :int
  attach_function :deallocate_ConnectResponse, [ :pointer ], :void
  class StringVector < FFI::Struct
    layout(
           :count, :int,
           :data, :pointer
    )
  end
  attach_function :serialize_String_vector, [ :pointer, :string, :pointer ], :int
  attach_function :deserialize_String_vector, [ :pointer, :string, :pointer ], :int
  attach_function :allocate_String_vector, [ :pointer, :int ], :int
  attach_function :deallocate_String_vector, [ :pointer ], :int
  class SetWatches < FFI::Struct
    layout(
           :relativeZxid, :long_long,
           :dataWatches, StringVector,
           :existWatches, StringVector,
           :childWatches, StringVector
    )
  end
  attach_function :serialize_SetWatches, [ :pointer, :string, :pointer ], :int
  attach_function :deserialize_SetWatches, [ :pointer, :string, :pointer ], :int
  attach_function :deallocate_SetWatches, [ :pointer ], :void
  class RequestHeader < FFI::Struct
    layout(
           :xid, :int,
           :type, :int
    )
  end
  attach_function :serialize_RequestHeader, [ :pointer, :string, :pointer ], :int
  attach_function :deserialize_RequestHeader, [ :pointer, :string, :pointer ], :int
  attach_function :deallocate_RequestHeader, [ :pointer ], :void
  class AuthPacket < FFI::Struct
    layout(
           :type, :int,
           :scheme, :pointer,
           :auth, Buffer
    )
    def scheme=(str)
      @scheme = FFI::MemoryPointer.from_string(str)
      self[:scheme] = @scheme
    end
    def scheme
      @scheme.get_string(0)
    end

  end
  attach_function :serialize_AuthPacket, [ :pointer, :string, :pointer ], :int
  attach_function :deserialize_AuthPacket, [ :pointer, :string, :pointer ], :int
  attach_function :deallocate_AuthPacket, [ :pointer ], :void
  class ReplyHeader < FFI::Struct
    layout(
           :xid, :int,
           :zxid, :long_long,
           :err, :int
    )
  end
  attach_function :serialize_ReplyHeader, [ :pointer, :string, :pointer ], :int
  attach_function :deserialize_ReplyHeader, [ :pointer, :string, :pointer ], :int
  attach_function :deallocate_ReplyHeader, [ :pointer ], :void
  class GetDataRequest < FFI::Struct
    layout(
           :path, :pointer,
           :watch, :int
    )
    def path=(str)
      @path = FFI::MemoryPointer.from_string(str)
      self[:path] = @path
    end
    def path
      @path.get_string(0)
    end

  end
  attach_function :serialize_GetDataRequest, [ :pointer, :string, :pointer ], :int
  attach_function :deserialize_GetDataRequest, [ :pointer, :string, :pointer ], :int
  attach_function :deallocate_GetDataRequest, [ :pointer ], :void
  class SetDataRequest < FFI::Struct
    layout(
           :path, :pointer,
           :data, Buffer,
           :version, :int
    )
    def path=(str)
      @path = FFI::MemoryPointer.from_string(str)
      self[:path] = @path
    end
    def path
      @path.get_string(0)
    end

  end
  attach_function :serialize_SetDataRequest, [ :pointer, :string, :pointer ], :int
  attach_function :deserialize_SetDataRequest, [ :pointer, :string, :pointer ], :int
  attach_function :deallocate_SetDataRequest, [ :pointer ], :void
  class SetDataResponse < FFI::Struct
    layout(
           :stat, Stat
    )
  end
  attach_function :serialize_SetDataResponse, [ :pointer, :string, :pointer ], :int
  attach_function :deserialize_SetDataResponse, [ :pointer, :string, :pointer ], :int
  attach_function :deallocate_SetDataResponse, [ :pointer ], :void
  class ACLVector < FFI::Struct
    layout(
           :count, :int,
           :data, :pointer
    )
  end
  attach_function :serialize_ACL_vector, [ :pointer, :string, :pointer ], :int
  attach_function :deserialize_ACL_vector, [ :pointer, :string, :pointer ], :int
  attach_function :allocate_ACL_vector, [ :pointer, :int ], :int
  attach_function :deallocate_ACL_vector, [ :pointer ], :int
  class CreateRequest < FFI::Struct
    layout(
           :path, :pointer,
           :data, Buffer,
           :acl, ACLVector,
           :flags, :int
    )
    def path=(str)
      @path = FFI::MemoryPointer.from_string(str)
      self[:path] = @path
    end
    def path
      @path.get_string(0)
    end

  end
  attach_function :serialize_CreateRequest, [ :pointer, :string, :pointer ], :int
  attach_function :deserialize_CreateRequest, [ :pointer, :string, :pointer ], :int
  attach_function :deallocate_CreateRequest, [ :pointer ], :void
  class DeleteRequest < FFI::Struct
    layout(
           :path, :pointer,
           :version, :int
    )
    def path=(str)
      @path = FFI::MemoryPointer.from_string(str)
      self[:path] = @path
    end
    def path
      @path.get_string(0)
    end

  end
  attach_function :serialize_DeleteRequest, [ :pointer, :string, :pointer ], :int
  attach_function :deserialize_DeleteRequest, [ :pointer, :string, :pointer ], :int
  attach_function :deallocate_DeleteRequest, [ :pointer ], :void
  class GetChildrenRequest < FFI::Struct
    layout(
           :path, :pointer,
           :watch, :int
    )
    def path=(str)
      @path = FFI::MemoryPointer.from_string(str)
      self[:path] = @path
    end
    def path
      @path.get_string(0)
    end

  end
  attach_function :serialize_GetChildrenRequest, [ :pointer, :string, :pointer ], :int
  attach_function :deserialize_GetChildrenRequest, [ :pointer, :string, :pointer ], :int
  attach_function :deallocate_GetChildrenRequest, [ :pointer ], :void
  class GetMaxChildrenRequest < FFI::Struct
    layout(
           :path, :pointer
    )
    def path=(str)
      @path = FFI::MemoryPointer.from_string(str)
      self[:path] = @path
    end
    def path
      @path.get_string(0)
    end

  end
  attach_function :serialize_GetMaxChildrenRequest, [ :pointer, :string, :pointer ], :int
  attach_function :deserialize_GetMaxChildrenRequest, [ :pointer, :string, :pointer ], :int
  attach_function :deallocate_GetMaxChildrenRequest, [ :pointer ], :void
  class GetMaxChildrenResponse < FFI::Struct
    layout(
           :max, :int
    )
  end
  attach_function :serialize_GetMaxChildrenResponse, [ :pointer, :string, :pointer ], :int
  attach_function :deserialize_GetMaxChildrenResponse, [ :pointer, :string, :pointer ], :int
  attach_function :deallocate_GetMaxChildrenResponse, [ :pointer ], :void
  class SetMaxChildrenRequest < FFI::Struct
    layout(
           :path, :pointer,
           :max, :int
    )
    def path=(str)
      @path = FFI::MemoryPointer.from_string(str)
      self[:path] = @path
    end
    def path
      @path.get_string(0)
    end

  end
  attach_function :serialize_SetMaxChildrenRequest, [ :pointer, :string, :pointer ], :int
  attach_function :deserialize_SetMaxChildrenRequest, [ :pointer, :string, :pointer ], :int
  attach_function :deallocate_SetMaxChildrenRequest, [ :pointer ], :void
  class SyncRequest < FFI::Struct
    layout(
           :path, :pointer
    )
    def path=(str)
      @path = FFI::MemoryPointer.from_string(str)
      self[:path] = @path
    end
    def path
      @path.get_string(0)
    end

  end
  attach_function :serialize_SyncRequest, [ :pointer, :string, :pointer ], :int
  attach_function :deserialize_SyncRequest, [ :pointer, :string, :pointer ], :int
  attach_function :deallocate_SyncRequest, [ :pointer ], :void
  class SyncResponse < FFI::Struct
    layout(
           :path, :pointer
    )
    def path=(str)
      @path = FFI::MemoryPointer.from_string(str)
      self[:path] = @path
    end
    def path
      @path.get_string(0)
    end

  end
  attach_function :serialize_SyncResponse, [ :pointer, :string, :pointer ], :int
  attach_function :deserialize_SyncResponse, [ :pointer, :string, :pointer ], :int
  attach_function :deallocate_SyncResponse, [ :pointer ], :void
  class GetACLRequest < FFI::Struct
    layout(
           :path, :pointer
    )
    def path=(str)
      @path = FFI::MemoryPointer.from_string(str)
      self[:path] = @path
    end
    def path
      @path.get_string(0)
    end

  end
  attach_function :serialize_GetACLRequest, [ :pointer, :string, :pointer ], :int
  attach_function :deserialize_GetACLRequest, [ :pointer, :string, :pointer ], :int
  attach_function :deallocate_GetACLRequest, [ :pointer ], :void
  class SetACLRequest < FFI::Struct
    layout(
           :path, :pointer,
           :acl, ACLVector,
           :version, :int
    )
    def path=(str)
      @path = FFI::MemoryPointer.from_string(str)
      self[:path] = @path
    end
    def path
      @path.get_string(0)
    end

  end
  attach_function :serialize_SetACLRequest, [ :pointer, :string, :pointer ], :int
  attach_function :deserialize_SetACLRequest, [ :pointer, :string, :pointer ], :int
  attach_function :deallocate_SetACLRequest, [ :pointer ], :void
  class SetACLResponse < FFI::Struct
    layout(
           :stat, Stat
    )
  end
  attach_function :serialize_SetACLResponse, [ :pointer, :string, :pointer ], :int
  attach_function :deserialize_SetACLResponse, [ :pointer, :string, :pointer ], :int
  attach_function :deallocate_SetACLResponse, [ :pointer ], :void
  class WatcherEvent < FFI::Struct
    layout(
           :type, :int,
           :state, :int,
           :path, :pointer
    )
    def path=(str)
      @path = FFI::MemoryPointer.from_string(str)
      self[:path] = @path
    end
    def path
      @path.get_string(0)
    end

  end
  attach_function :serialize_WatcherEvent, [ :pointer, :string, :pointer ], :int
  attach_function :deserialize_WatcherEvent, [ :pointer, :string, :pointer ], :int
  attach_function :deallocate_WatcherEvent, [ :pointer ], :void
  class CreateResponse < FFI::Struct
    layout(
           :path, :pointer
    )
    def path=(str)
      @path = FFI::MemoryPointer.from_string(str)
      self[:path] = @path
    end
    def path
      @path.get_string(0)
    end

  end
  attach_function :serialize_CreateResponse, [ :pointer, :string, :pointer ], :int
  attach_function :deserialize_CreateResponse, [ :pointer, :string, :pointer ], :int
  attach_function :deallocate_CreateResponse, [ :pointer ], :void
  class ExistsRequest < FFI::Struct
    layout(
           :path, :pointer,
           :watch, :int
    )
    def path=(str)
      @path = FFI::MemoryPointer.from_string(str)
      self[:path] = @path
    end
    def path
      @path.get_string(0)
    end

  end
  attach_function :serialize_ExistsRequest, [ :pointer, :string, :pointer ], :int
  attach_function :deserialize_ExistsRequest, [ :pointer, :string, :pointer ], :int
  attach_function :deallocate_ExistsRequest, [ :pointer ], :void
  class ExistsResponse < FFI::Struct
    layout(
           :stat, Stat
    )
  end
  attach_function :serialize_ExistsResponse, [ :pointer, :string, :pointer ], :int
  attach_function :deserialize_ExistsResponse, [ :pointer, :string, :pointer ], :int
  attach_function :deallocate_ExistsResponse, [ :pointer ], :void
  class GetDataResponse < FFI::Struct
    layout(
           :data, Buffer,
           :stat, Stat
    )
  end
  attach_function :serialize_GetDataResponse, [ :pointer, :string, :pointer ], :int
  attach_function :deserialize_GetDataResponse, [ :pointer, :string, :pointer ], :int
  attach_function :deallocate_GetDataResponse, [ :pointer ], :void
  class GetChildrenResponse < FFI::Struct
    layout(
           :children, StringVector
    )
  end
  attach_function :serialize_GetChildrenResponse, [ :pointer, :string, :pointer ], :int
  attach_function :deserialize_GetChildrenResponse, [ :pointer, :string, :pointer ], :int
  attach_function :deallocate_GetChildrenResponse, [ :pointer ], :void
  class GetACLResponse < FFI::Struct
    layout(
           :acl, ACLVector,
           :stat, Stat
    )
  end
  attach_function :serialize_GetACLResponse, [ :pointer, :string, :pointer ], :int
  attach_function :deserialize_GetACLResponse, [ :pointer, :string, :pointer ], :int
  attach_function :deallocate_GetACLResponse, [ :pointer ], :void
  class IdVector < FFI::Struct
    layout(
           :count, :int,
           :data, :pointer
    )
  end
  attach_function :serialize_Id_vector, [ :pointer, :string, :pointer ], :int
  attach_function :deserialize_Id_vector, [ :pointer, :string, :pointer ], :int
  attach_function :allocate_Id_vector, [ :pointer, :int ], :int
  attach_function :deallocate_Id_vector, [ :pointer ], :int
  class QuorumPacket < FFI::Struct
    layout(
           :type, :int,
           :zxid, :long_long,
           :data, Buffer,
           :authinfo, IdVector
    )
  end
  attach_function :serialize_QuorumPacket, [ :pointer, :string, :pointer ], :int
  attach_function :deserialize_QuorumPacket, [ :pointer, :string, :pointer ], :int
  attach_function :deallocate_QuorumPacket, [ :pointer ], :void
  class FileHeader < FFI::Struct
    layout(
           :magic, :int,
           :version, :int,
           :dbid, :long_long
    )
  end
  attach_function :serialize_FileHeader, [ :pointer, :string, :pointer ], :int
  attach_function :deserialize_FileHeader, [ :pointer, :string, :pointer ], :int
  attach_function :deallocate_FileHeader, [ :pointer ], :void
  class TxnHeader < FFI::Struct
    layout(
           :clientId, :long_long,
           :cxid, :int,
           :zxid, :long_long,
           :time, :long_long,
           :type, :int
    )
  end
  attach_function :serialize_TxnHeader, [ :pointer, :string, :pointer ], :int
  attach_function :deserialize_TxnHeader, [ :pointer, :string, :pointer ], :int
  attach_function :deallocate_TxnHeader, [ :pointer ], :void
  class CreateTxn < FFI::Struct
    layout(
           :path, :pointer,
           :data, Buffer,
           :acl, ACLVector,
           :ephemeral, :int
    )
    def path=(str)
      @path = FFI::MemoryPointer.from_string(str)
      self[:path] = @path
    end
    def path
      @path.get_string(0)
    end

  end
  attach_function :serialize_CreateTxn, [ :pointer, :string, :pointer ], :int
  attach_function :deserialize_CreateTxn, [ :pointer, :string, :pointer ], :int
  attach_function :deallocate_CreateTxn, [ :pointer ], :void
  class DeleteTxn < FFI::Struct
    layout(
           :path, :pointer
    )
    def path=(str)
      @path = FFI::MemoryPointer.from_string(str)
      self[:path] = @path
    end
    def path
      @path.get_string(0)
    end

  end
  attach_function :serialize_DeleteTxn, [ :pointer, :string, :pointer ], :int
  attach_function :deserialize_DeleteTxn, [ :pointer, :string, :pointer ], :int
  attach_function :deallocate_DeleteTxn, [ :pointer ], :void
  class SetDataTxn < FFI::Struct
    layout(
           :path, :pointer,
           :data, Buffer,
           :version, :int
    )
    def path=(str)
      @path = FFI::MemoryPointer.from_string(str)
      self[:path] = @path
    end
    def path
      @path.get_string(0)
    end

  end
  attach_function :serialize_SetDataTxn, [ :pointer, :string, :pointer ], :int
  attach_function :deserialize_SetDataTxn, [ :pointer, :string, :pointer ], :int
  attach_function :deallocate_SetDataTxn, [ :pointer ], :void
  class SetACLTxn < FFI::Struct
    layout(
           :path, :pointer,
           :acl, ACLVector,
           :version, :int
    )
    def path=(str)
      @path = FFI::MemoryPointer.from_string(str)
      self[:path] = @path
    end
    def path
      @path.get_string(0)
    end

  end
  attach_function :serialize_SetACLTxn, [ :pointer, :string, :pointer ], :int
  attach_function :deserialize_SetACLTxn, [ :pointer, :string, :pointer ], :int
  attach_function :deallocate_SetACLTxn, [ :pointer ], :void
  class SetMaxChildrenTxn < FFI::Struct
    layout(
           :path, :pointer,
           :max, :int
    )
    def path=(str)
      @path = FFI::MemoryPointer.from_string(str)
      self[:path] = @path
    end
    def path
      @path.get_string(0)
    end

  end
  attach_function :serialize_SetMaxChildrenTxn, [ :pointer, :string, :pointer ], :int
  attach_function :deserialize_SetMaxChildrenTxn, [ :pointer, :string, :pointer ], :int
  attach_function :deallocate_SetMaxChildrenTxn, [ :pointer ], :void
  class CreateSessionTxn < FFI::Struct
    layout(
           :timeOut, :int
    )
  end
  attach_function :serialize_CreateSessionTxn, [ :pointer, :string, :pointer ], :int
  attach_function :deserialize_CreateSessionTxn, [ :pointer, :string, :pointer ], :int
  attach_function :deallocate_CreateSessionTxn, [ :pointer ], :void
  class ErrorTxn < FFI::Struct
    layout(
           :err, :int
    )
  end
  attach_function :serialize_ErrorTxn, [ :pointer, :string, :pointer ], :int
  attach_function :deserialize_ErrorTxn, [ :pointer, :string, :pointer ], :int
  attach_function :deallocate_ErrorTxn, [ :pointer ], :void
  ZSYSTEMERROR = -1
  ZAPIERROR = -100
  ZNONODE = -101
  ZNOAUTH = -102
  ZBADVERSION = -103
  ZNOCHILDRENFOREPHEMERALS = -108
  ZNODEEXISTS = -110
  ZNOTEMPTY = -111
  ZSESSIONEXPIRED = -112
  ZINVALIDCALLBACK = -113
  ZINVALIDACL = -114
  ZAUTHFAILED = -115
  ZCLOSING = -116
  ZNOTHING = -117
  ZRUNTIMEINCONSISTENCY = -2
  ZDATAINCONSISTENCY = -3
  ZCONNECTIONLOSS = -4
  ZMARSHALLINGERROR = -5
  ZUNIMPLEMENTED = -6
  ZOPERATIONTIMEOUT = -7
  ZBADARGUMENTS = -8
  ZINVALIDSTATE = -9
  ZOK = 0

  ZOO_LOG_LEVEL_ERROR = 1
  ZOO_LOG_LEVEL_WARN = 2
  ZOO_LOG_LEVEL_INFO = 3
  ZOO_LOG_LEVEL_DEBUG = 4

  class ClientidT < FFI::Struct
    layout(
           :client_id, :long_long,
           :passwd, [:char, 16]
    )
  end
  callback(:watcher_fn, [ :pointer, :int, :int, :string, :pointer ], :void)
  attach_function :zookeeper_init, [ :string, :watcher_fn, :int, :pointer, :pointer, :int ], :pointer
  attach_function :zookeeper_close, [ :pointer ], :int
  attach_function :zoo_client_id, [ :pointer ], :pointer
  attach_function :zoo_recv_timeout, [ :pointer ], :int
  attach_function :zoo_get_context, [ :pointer ], :pointer
  attach_function :zoo_set_context, [ :pointer, :pointer ], :void
  attach_function :zoo_set_watcher, [ :pointer, :watcher_fn ], :watcher_fn
  attach_function :zookeeper_interest, [ :pointer, :pointer, :pointer, :pointer ], :int
  attach_function :zookeeper_process, [ :pointer, :int ], :int
  callback(:void_completion_t, [ :int, :pointer ], :void)
  callback(:stat_completion_t, [ :int, :pointer, :pointer ], :void)
  callback(:data_completion_t, [ :int, :string, :int, :pointer, :pointer ], :void)
  callback(:strings_completion_t, [ :int, :pointer, :pointer ], :void)
  callback(:string_completion_t, [ :int, :string, :pointer ], :void)
  callback(:acl_completion_t, [ :int, :pointer, :pointer, :pointer ], :void)
  attach_function :zoo_state, [ :pointer ], :int
  attach_function :zoo_acreate, [ :pointer, :string, :string, :int, :pointer, :int, :string_completion_t, :pointer ], :int
  attach_function :zoo_adelete, [ :pointer, :string, :int, :void_completion_t, :pointer ], :int
  attach_function :zoo_aexists, [ :pointer, :string, :int, :stat_completion_t, :pointer ], :int
  attach_function :zoo_awexists, [ :pointer, :string, :watcher_fn, :pointer, :stat_completion_t, :pointer ], :int
  attach_function :zoo_aget, [ :pointer, :string, :int, :data_completion_t, :pointer ], :int
  attach_function :zoo_awget, [ :pointer, :string, :watcher_fn, :pointer, :data_completion_t, :pointer ], :int
  attach_function :zoo_aset, [ :pointer, :string, :string, :int, :int, :stat_completion_t, :pointer ], :int
  attach_function :zoo_aget_children, [ :pointer, :string, :int, :strings_completion_t, :pointer ], :int
  attach_function :zoo_awget_children, [ :pointer, :string, :watcher_fn, :pointer, :strings_completion_t, :pointer ], :int
  attach_function :zoo_async, [ :pointer, :string, :string_completion_t, :pointer ], :int
  attach_function :zoo_aget_acl, [ :pointer, :string, :acl_completion_t, :pointer ], :int
  attach_function :zoo_aset_acl, [ :pointer, :string, :int, :pointer, :void_completion_t, :pointer ], :int
  attach_function :zerror, [ :int ], :string
  attach_function :zoo_add_auth, [ :pointer, :string, :string, :int, :void_completion_t, :pointer ], :int
  attach_function :is_unrecoverable, [ :pointer ], :int
  attach_function :zoo_set_debug_level, [ :int ], :void
  attach_function :zoo_set_log_stream, [ :pointer ], :void
  attach_function :zoo_deterministic_conn_order, [ :int ], :void
  attach_function :zoo_create, [ :pointer, :pointer, :string, :int, :pointer, :int, :pointer, :int ], :int
  attach_function :zoo_delete, [ :pointer, :string, :int ], :int
  attach_function :zoo_exists, [ :pointer, :string, :int, :pointer ], :int
  attach_function :zoo_wexists, [ :pointer, :string, :watcher_fn, :pointer, :pointer ], :int
  attach_function :zoo_get, [ :pointer, :string, :int, :pointer, :pointer, :pointer ], :int
  #attach_function :zoo_wget, [ :pointer, :string, :watcher_fn, :pointer, :string, :pointer, :pointer ], :int
  attach_function :zoo_wget, [ :pointer, :string, :watcher_fn, :pointer, :pointer, :pointer, :pointer ], :int
  attach_function :zoo_set, [ :pointer, :string, :string, :int, :int ], :int
  attach_function :zoo_set2, [ :pointer, :string, :string, :int, :int, :pointer ], :int
  attach_function :zoo_get_children, [ :pointer, :string, :int, :pointer ], :int
  attach_function :zoo_wget_children, [ :pointer, :string, :watcher_fn, :pointer, :pointer ], :int
  attach_function :zoo_get_acl, [ :pointer, :string, :pointer, :pointer ], :int
  attach_function :zoo_set_acl, [ :pointer, :string, :int, :pointer ], :int

end
