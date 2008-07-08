require 'test/unit'
require File.dirname(__FILE__) + '/../lib/fluent_interface'

module Mock
  class OptionArgsWithoutFluentInterface
    def option(*args)
      args
    end
  end
  class OptionArgs < OptionArgsWithoutFluentInterface
    include FluentInterface
    fluent :option, :option_fluent
  end

  class OptionArgsOverride < OptionArgsWithoutFluentInterface
    include FluentInterface
    fluent :option
  end

  class OptionArgsSettingArgs < OptionArgsWithoutFluentInterface
    include FluentInterface
    fluent :option, :option, [:foo, :bar]
  end


  class NewArgsWithoutFluentInterface
    attr_reader :options
    def initialize(options)
      @options = options
    end
  end

  class NewArgs < NewArgsWithoutFluentInterface
    include FluentInterface
  end
end
