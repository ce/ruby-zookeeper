%module zookeeper

typedef int int32_t;
typedef unsigned int uint32_t;

typedef long long int64_t;
typedef unsigned long long uint64_t;

%{
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
%}

%include zookeeper_version.h
%include proto.h
%include recordio.h
%include zookeeper.jute.h
%include zookeeper.h

%{
end
%}

