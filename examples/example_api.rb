#!/usr/bin/env ruby

require 'pathname'
$LOAD_PATH.unshift Pathname.new(__FILE__).parent.parent.join('lib')
require 'fluent_interface'

class ExampleAPI
  include FluentInterface
  fluent :search, :search_fluent, [:type, :limit]

  def search(word, options = {})
    [word, options]
  end
end

p ExampleAPI.new.search('foo', :type => :dict)
p ExampleAPI.new.search_fluent.type(:dict).execute('foo')
api = ExampleAPI.new
api.search_fluent.order(:desc) #=> undefined method `order' for #<FluentInterface::FluentProxy:0x402c3428>

