class ZooKeeper
  ## TODO: namespace under ZooKeeper::Callback ?
  class WatcherCallback
    ## wexists, awexists, wget, awget, wget_children, awget_children
    attr_reader :zh, :type, :state, :path, :context
    attr_reader :proc, :completed

    def initialize
      @completed = false
      @proc = Proc.new do |zh, type, state, path, context|
        @zh, @type, @state, @path = zh, type, state, path
        @context = YAML.load(context.read_string) if context
        yield if block_given?
        @completed = true
      end
    end
    def call(*args)
      @proc.call(*args)
    end

    def completed?
      @completed
    end
  end

  class DataCallback
    ## aget, awget
    attr_reader :return_code, :value, :value_len, :stat, :context
    attr_reader :proc, :completed

    def initialize
      @completed = false
      @proc = Proc.new do |return_code, value, value_len, stat, context|
        @return_code = return_code
        @value = value
        @value_len = value_len
        @stat = ZooKeeper::Stat.new(stat)
        @context = YAML.load(context.read_string) if context
        yield if block_given?
        @completed = true
      end
    end

    def completed?
      @completed
    end
  end

  class StringCallback
    ## acreate, async
    attr_reader :return_code, :path, :context
    attr_reader :proc, :completed

    def initialize
      @completed = false
      @proc = Proc.new do |return_code, path, context|
        @return_code = return_code
        @path = path
        @context = YAML.load(context.read_string) if context
        yield if block_given?
        @completed = true
      end
    end

    def completed?
      @completed
    end
  end

  class StringsCallback
    ## aget_children, awget_children
    attr_reader :return_code, :strings, :context
    attr_reader :proc, :completed
    attr_reader :children

    def initialize
      @completed = false
      @proc = Proc.new do |return_code, strings, context|
        @return_code = return_code
        @context = YAML.load(context.read_string) if context
        unless strings.null?
          str_v = ZooKeeperFFI::StringVector.new(strings)
          entries = str_v[:data].read_array_of_pointer(str_v[:count])
          @children = entries.map { |e| e.read_string }
        end
        yield if block_given?
        @completed = true
      end
    end
    def completed?
      @completed
    end
  end

  class StatCallback
    ## aset, aexists, awexists
    attr_reader :return_code, :stat, :context
    attr_reader :proc, :completed

    def initialize
      @completed = false
      @proc = Proc.new do |return_code, stat, context|
        @return_code = return_code
        @stat = ZooKeeper::Stat.new(stat)
        @context = YAML.load(context.read_string) if context
        yield if block_given?
        @completed = true
      end
    end

    def completed?
      @completed
    end
  end

  class VoidCallback
    ## adelete, aset_acl, add_auth
    attr_reader :return_code, :context
    attr_reader :proc, :completed

    def initialize
      @completed = false
      @proc = Proc.new do |return_code, context|
        @return_code = return_code
        @context = YAML.load(context.read_string) if context
        yield if block_given?
        @completed = true
      end
    end

    def completed?
      @completed
    end
  end

  class ACLCallback
    ## aget_acl
    attr_reader :return_code, :acl, :stat, :context
    attr_reader :proc, :completed

    def initialize
      @completed = false
      @proc = Proc.new do |return_code, acl, stat, context|
        @return_code = return_code
        @acl = ZooKeeper::ACLVector.new(acl)
        @stat = ZooKeeper::Stat.new(stat)
        @context = YAML.load(context.read_string) if context
        yield if block_given?
        @completed = true
      end
    end

    def completed?
      @completed
    end
  end

end
