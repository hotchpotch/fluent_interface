
module FluentInterface
  module ClassMethods
    def fluent(method_name, fluent_method_name = nil, arg_names = nil)
      if fluent_method_name.nil? || method_name == fluent_method_name
        alias_method_name = "__fluent__#{method_name}".intern
        return if method_defined? alias_method_name
        alias_method alias_method_name, method_name
        fluent_method_name = method_name
        method_name = alias_method_name
      end

      define_method(fluent_method_name) do
        self.fluent method_name, arg_names
      end
    end
  end

  def fluent(method_name, arg_names = nil)
    FluentProxy.new self, method_name, arg_names
  end

  class << self
    def included(base)
      base.extend ClassMethods
    end

    def fluent(target, method_name, arg_names = nil)
      FluentProxy.new target, method_name, arg_names
    end
  end

  class FluentProxy
    def initialize(target, method_name, arg_names = nil)
      @target = target
      @method_name = method_name
      @arguments = {}
      @arg_names = arg_names
      if arg_names
        arg_names = [arg_names] unless arg_names.kind_of?(Array)
        arg_names.each do |arg_name|
          arg_name = arg_name.to_sym
          (class << self;self end).__send__(:define_method, arg_name, lambda {|*args|
            if args.length > 0
              @arguments[arg_name] = args.first
              __clone__
            else
              @arguments[arg_name]
            end
          })
        end
        class << self
          undef_method :method_missing
        end
      end
    end

    def execute(*args)
      args << @arguments
      @target.__send__(@method_name, *args)
    end

    def method_missing(name, *args)
      if args.length > 0
        @arguments[name] = args.first
        __clone__
      else
        @arguments[name]
      end
    end

    def inspect
      "#<#{self.class.name}:@target=#{@target.inspect},@method_name=<#{@method_name}>,@arguments=<#{@arguments.inspect}>>"
    end

    def __clone__
      i = self.class.new(@target, @method_name, @arg_names)
      i.instance_variable_get('@arguments'.intern).update(@arguments)
      i
    end

    IGNORE_METHODS = %w(object_id execute inspect class instance_variable_get)
    Object.instance_methods.each do |m|
      next if m.to_s =~ /(^__|^nil\?|^#{IGNORE_METHODS.join('$|^')}$)/
      undef_method m
    end
  end
end
