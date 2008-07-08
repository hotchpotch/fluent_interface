
module FluentInterface
  module ClassMethods
    def fluent(method_name, fluent_method_name = nil)
      if fluent_method_name.nil?
        alias_method_name = "__fluent__#{method_name}".intern
        return if method_defined? alias_method_name
        alias_method alias_method_name, method_name
        fluent_method_name = method_name
        method_name = alias_method_name
      end

      define_method(fluent_method_name) do
        self.fluent(method_name)
      end
    end
  end

  def fluent(method_name)
    FluentProxy.new self, method_name
  end

  class << self
    def included(base)
      base.extend ClassMethods
    end

    def fluent(target, method_name)
      FluentProxy.new target, method_name
    end
  end

  class FluentProxy
    def initialize(target, method_name)
      @target = target
      @method_name = method_name
      @arguments = {}
    end

    def execute(*args)
      args << @arguments
      @target.__send__(@method_name, *args)
    end

    def method_missing(name, *args)
      @arguments[name] = args.first
      self
    end

    def inspect
      "#<#{self.class.name}:@target=#{@target.inspect},@method_name=<#{@method_name}>,@arguments=<#{@arguments.inspect}>>"
    end

    Object.instance_methods.each do |m|
      next if m.to_s =~ /(^__|^nil\?|^object_id$|^execute$|^inspect$|^class$)/
      undef_method m
    end
  end
end
