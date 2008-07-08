require File.dirname(__FILE__) + '/test_helper.rb'

require "test/unit"

class FluentInterfaceTest < Test::Unit::TestCase
  include Mock
  def setup
  end

  def test_option
    mock = OptionArgs.new
    execute mock.option_fluent
    execute mock.fluent(:option)
  end

  def test_option_override
    mock = OptionArgsOverride.new
    execute mock.option
  end

  def test_option_setting_args
    mock = OptionArgsSettingArgs.new
    assert_raise(NoMethodError) {mock.option.no_method(:bar)} 
    assert_equal FluentInterface::FluentProxy, mock.option.foo(:bar).class
  end


  def test_option_extend_fluent
    mock = OptionArgsWithoutFluentInterface.new
    mock.extend FluentInterface
    execute(mock.fluent(:option))
  end

  def test_option_without_fluent
    mock = OptionArgsWithoutFluentInterface.new
    o = FluentInterface.fluent(mock, :option)
    execute(o)
  end

  def test_new
    mock = FluentInterface.fluent(NewArgsWithoutFluentInterface, :new)
    assert_equal mock.foo(:bar).bar(:baz).execute.options, {:foo => :bar, :bar => :baz}
  end

  def test_hash
    mock = FluentInterface.fluent(Hash.new, :update)
    assert_equal mock.foo(:bar).bar(:baz).execute, {:foo => :bar, :bar => :baz}
  end

  def test_hash_getter
    mock = FluentInterface.fluent(Hash.new, :update)
    mock = mock.foo(:bar).bar(:baz) 
    assert_equal mock.foo, :bar
    assert_equal mock.bar, :baz
    assert_not_equal mock.bar, :ba

    mock = FluentInterface.fluent(Hash.new, :update)
    mock = mock.foo(:bar)
    assert_equal mock.foo, :bar
    assert_not_equal mock.bar, :baz
  end

  def test_hash_methodnames
    mock = FluentInterface.fluent(NewArgsWithoutFluentInterface, :new, [:foo, :bar])
    assert_equal mock.foo(:bar).bar(:baz).execute.options, {:foo => :bar, :bar => :baz}
    assert_raise(NoMethodError) {mock.no_method(:bar)} 
  end

  def execute(mock)
    execute_args = []
    assert_equal execute_args.clone.concat([{:foo => :bar, :bar => :baz}]), mock.foo(:bar).bar(:baz).execute(*execute_args)
    assert_not_equal mock.foo(:ba).bar(:baz).execute(*execute_args), execute_args.clone.concat([{:foo => :bar, :bar => :baz}])
    execute_args = [:foo, :bar]
    assert_equal mock.foo(:bar).bar(:baz).execute(*execute_args), execute_args.clone.concat([{:foo => :bar, :bar => :baz}])
    assert_not_equal mock.foo(:ba).bar(:baz).execute(*execute_args), execute_args.clone.concat([{:foo => :bar, :bar => :baz}])
  end
end
