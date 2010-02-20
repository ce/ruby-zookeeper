# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{ruby-zookeeper}
  s.version = "0.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Ruben Nine", "Brett Eisenberg", "Shane Mignins", "Andrew Reynhout"]
  s.date = %q{2010-02-20}
  s.description = %q{Ruby bindings for Apache ZooKeeper}
  s.email = %q{github@creationengines.net}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = [
    ".document",
     ".gitignore",
     "LICENSE",
     "README.rdoc",
     "Rakefile",
     "VERSION",
     "examples/common.rb",
     "examples/create.rb",
     "examples/exists.rb",
     "examples/get-async.rb",
     "examples/get_children-async.rb",
     "examples/watcher.rb",
     "generated/zookeeper_wrap.rb",
     "generated/zookeeper_wrap.xml",
     "interfaces/proto.h",
     "interfaces/recordio.h",
     "interfaces/zookeeper.h",
     "interfaces/zookeeper.i",
     "interfaces/zookeeper.jute.h",
     "interfaces/zookeeper.rb",
     "interfaces/zookeeper_version.h",
     "lib/zookeeper.rb",
     "lib/zookeeper/callbacks.rb",
     "lib/zookeeper/keeper_exception.rb",
     "lib/zookeeper/zookeeper.rb",
     "lib/zookeeper_ffi.rb",
     "spec/spec.opts",
     "spec/spec_helper.rb",
     "spec/zookeeper_spec.rb",
     "spec/zookeeper_test_server.rb",
     "zk/LICENSE.txt",
     "zk/bin/zkCleanup.sh",
     "zk/bin/zkCli.sh",
     "zk/bin/zkEnv.sh",
     "zk/bin/zkServer.sh",
     "zk/conf/configuration.xsl",
     "zk/conf/log4j.properties",
     "zk/conf/zoo.cfg",
     "zk/lib/Null.java",
     "zk/lib/README.txt",
     "zk/lib/cobertura/README.txt",
     "zk/lib/jdiff-1.0.9.jar",
     "zk/lib/jdiff/zookeeper_3.2.2.xml",
     "zk/lib/jline-0.9.94.LICENSE.txt",
     "zk/lib/jline-0.9.94.jar",
     "zk/lib/junit-4.4.LICENSE.txt",
     "zk/lib/junit-4.4.jar",
     "zk/lib/log4j-1.2.15.LICENSE.txt",
     "zk/lib/log4j-1.2.15.NOTICE.txt",
     "zk/lib/log4j-1.2.15.jar",
     "zk/lib/xerces-1.4.4.jar",
     "zk/src/c/ChangeLog",
     "zk/src/c/INSTALL",
     "zk/src/c/LICENSE",
     "zk/src/c/Makefile.am",
     "zk/src/c/Makefile.in",
     "zk/src/c/README",
     "zk/src/c/acinclude.m4",
     "zk/src/c/aclocal.m4",
     "zk/src/c/aminclude.am",
     "zk/src/c/c-doc.Doxyfile",
     "zk/src/c/compile",
     "zk/src/c/config.guess",
     "zk/src/c/config.h.in",
     "zk/src/c/config.sub",
     "zk/src/c/configure",
     "zk/src/c/configure.ac",
     "zk/src/c/depcomp",
     "zk/src/c/generated/zookeeper.jute.c",
     "zk/src/c/generated/zookeeper.jute.h",
     "zk/src/c/include/proto.h",
     "zk/src/c/include/recordio.h",
     "zk/src/c/include/zookeeper.h",
     "zk/src/c/include/zookeeper_log.h",
     "zk/src/c/include/zookeeper_version.h",
     "zk/src/c/install-sh",
     "zk/src/c/ltmain.sh",
     "zk/src/c/missing",
     "zk/src/c/src/cli.c",
     "zk/src/c/src/hashtable/LICENSE.txt",
     "zk/src/c/src/hashtable/hashtable.c",
     "zk/src/c/src/hashtable/hashtable.h",
     "zk/src/c/src/hashtable/hashtable_itr.c",
     "zk/src/c/src/hashtable/hashtable_itr.h",
     "zk/src/c/src/hashtable/hashtable_private.h",
     "zk/src/c/src/load_gen.c",
     "zk/src/c/src/mt_adaptor.c",
     "zk/src/c/src/recordio.c",
     "zk/src/c/src/st_adaptor.c",
     "zk/src/c/src/zk_adaptor.h",
     "zk/src/c/src/zk_hashtable.c",
     "zk/src/c/src/zk_hashtable.h",
     "zk/src/c/src/zk_log.c",
     "zk/src/c/src/zookeeper.c",
     "zk/src/c/tests/CollectionUtil.h",
     "zk/src/c/tests/CppAssertHelper.h",
     "zk/src/c/tests/LibCMocks.cc",
     "zk/src/c/tests/LibCMocks.h",
     "zk/src/c/tests/LibCSymTable.cc",
     "zk/src/c/tests/LibCSymTable.h",
     "zk/src/c/tests/MocksBase.cc",
     "zk/src/c/tests/MocksBase.h",
     "zk/src/c/tests/PthreadMocks.cc",
     "zk/src/c/tests/PthreadMocks.h",
     "zk/src/c/tests/TestClient.cc",
     "zk/src/c/tests/TestClientRetry.cc",
     "zk/src/c/tests/TestDriver.cc",
     "zk/src/c/tests/TestOperations.cc",
     "zk/src/c/tests/TestWatchers.cc",
     "zk/src/c/tests/TestZookeeperClose.cc",
     "zk/src/c/tests/TestZookeeperInit.cc",
     "zk/src/c/tests/ThreadingUtil.cc",
     "zk/src/c/tests/ThreadingUtil.h",
     "zk/src/c/tests/Util.cc",
     "zk/src/c/tests/Util.h",
     "zk/src/c/tests/Vector.h",
     "zk/src/c/tests/ZKMocks.cc",
     "zk/src/c/tests/ZKMocks.h",
     "zk/src/c/tests/wrappers-mt.opt",
     "zk/src/c/tests/wrappers.opt",
     "zk/src/c/tests/zkServer.sh",
     "zk/zookeeper-3.2.2.jar",
     "zookeeper.gemspec"
  ]
  s.homepage = %q{http://github.com/ce/ruby-zookeeper}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{ruby-zookeeper}
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{Ruby bindings for Apache ZooKeeper}
  s.test_files = [
    "spec/spec_helper.rb",
     "spec/zookeeper_spec.rb",
     "spec/zookeeper_test_server.rb",
     "examples/common.rb",
     "examples/create.rb",
     "examples/exists.rb",
     "examples/get-async.rb",
     "examples/get_children-async.rb",
     "examples/watcher.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<ffi>, [">= 0.4.0"])
      s.add_development_dependency(%q<ffi-swig-generator>, [">= 0.3.2"])
    else
      s.add_dependency(%q<ffi>, [">= 0.4.0"])
      s.add_dependency(%q<ffi-swig-generator>, [">= 0.3.2"])
    end
  else
    s.add_dependency(%q<ffi>, [">= 0.4.0"])
    s.add_dependency(%q<ffi-swig-generator>, [">= 0.3.2"])
  end
end

