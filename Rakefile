require 'rubygems'
require 'rake'
require 'yaml'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "ruby-zookeeper"
    gem.summary = "Ruby bindings for Apache ZooKeeper"
    gem.description = "Ruby bindings for Apache ZooKeeper"
    gem.email = "github@creationengines.net"
    gem.homepage = "http://github.com/ce/ruby-zookeeper"
    gem.authors = ["Ruben Nine", "Brett Eisenberg", "Shane Mignins", "Andrew Reynhout"]
    gem.rubyforge_project = 'ruby-zookeeper'
    gem.add_dependency('ffi', '>= 0.4.0')
    gem.add_development_dependency('ffi-swig-generator', '>= 0.3.2')
  end
  Jeweler::RubyforgeTasks.new
#rescue LoadError
#  puts "Jeweler (or a dependency) not available."
end

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new do |spec|
  spec.libs << 'lib' << 'spec'
  spec.spec_files = FileList['spec/**/*_spec.rb']
  #spec.spec_opts << File.open('spec/spec.opts').read.split.reject{|e| e=~/^#/}
end

desc "Run specs with extra opts"
Spec::Rake::SpecTask.new(:specx) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.spec_files = FileList['spec/**/*_spec.rb']
  spec.spec_opts = ['--colour', '--format progress', '--format failing_examples:.spec_fail']
end
desc "Run specs that failed last time around"
Spec::Rake::SpecTask.new(:specx_fail) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.spec_files = FileList['spec/**/*_spec.rb']
  spec.spec_opts = ['--colour', '--format progress', '--format failing_examples:.spec_fail', '--example .spec_fail']
end

Spec::Rake::SpecTask.new(:rcov) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end


task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  if File.exist?('VERSION.yml')
    config = YAML.load(File.read('VERSION.yml'))
    version = "#{config[:major]}.#{config[:minor]}.#{config[:patch]}"
  else
    version = ""
  end

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "ruby-zookeeper #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

require 'ffi-swig-generator'
FFI::Generator::Task.new do |task|
  task.input_fn = 'interfaces/*.i'
  task.output_dir = 'generated/'
end

desc "Display FIXME"
task :fixme do
  Dir.glob('**/*.rb').each do |fn|
    File.read(fn).scan(/FIXME:(.*?)$/m).each do |fixme|
      puts "FIXME: #{fixme} ...- '#{fn}'"
    end
  end
end

ZK_DIR = File.expand_path(File.join(File.dirname(__FILE__), 'zk'))

namespace :zk do
  desc "Start ZooKeeper"
  task :start do
    Dir.chdir(ZK_DIR) do
      sh "bin/zkServer.sh start"
    end
  end

  desc "Stop ZooKeeper"
  task :stop do
    Dir.chdir(ZK_DIR) do
      sh "bin/zkServer.sh stop"
    end
  end
end
