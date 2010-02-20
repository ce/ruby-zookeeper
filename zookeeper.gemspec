# Generated by jeweler
# DO NOT EDIT THIS FILE
# Instead, edit Jeweler::Tasks in Rakefile, and run `rake gemspec`
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{zookeeper}
  s.version = "0.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Ruben Nine", "Brett Eisenberg", "Shane Mignins", "Andrew Reynhout"]
  s.date = %q{2009-08-18}
  s.description = %q{A Ruby library for Apache ZooKeeper}
  s.email = %q{foo@bar.com}
  s.extra_rdoc_files = [
    "README.rdoc"
  ]
  s.files = [
    ".document",
     ".gitignore",
     "README.rdoc",
     "Rakefile",
     "VERSION",
     "commands/aget_children.rb",
     "commands/create.rb",
     "commands/create_using_class.rb",
     "commands/exists-watchertest.rb",
     "commands/exists.rb",
     "commands/get.rb",
     "commands/get_children.rb",
     "commands/watcher.rb",
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
     "patches/README",
     "patches/zookeeper-320.diff",
     "spec/spec.opts",
     "spec/spec_helper.rb",
     "spec/test_file.txt",
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
     "zk/lib/jdiff/zookeeper_3.1.1.xml",
     "zk/lib/jdiff/zookeeper_3.2.0.xml",
     "zk/lib/jline-0.9.94.LICENSE.txt",
     "zk/lib/jline-0.9.94.jar",
     "zk/lib/junit-4.4.LICENSE.txt",
     "zk/lib/junit-4.4.jar",
     "zk/lib/log4j-1.2.15.LICENSE.txt",
     "zk/lib/log4j-1.2.15.NOTICE.txt",
     "zk/lib/log4j-1.2.15.jar",
     "zk/lib/xerces-1.4.4.jar",
     "zk/zookeeper-3.2.0.jar",
     "zookeeper.gemspec"
  ]
  s.homepage = %q{http://github.com/brett/zookeeper}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{zookeeper}
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{ruby bindings for ZooKeeper}
  s.test_files = [
    "spec/spec_helper.rb",
     "spec/zookeeper_spec.rb",
     "spec/zookeeper_test_server.rb"
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
