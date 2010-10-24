require "test/unit"

require_relative "graphaz"

class TestGraphaz < Test::Unit::TestCase
  def setup
    @ga = GraphAz.new
  end

  def test_add_node
    names = [":hello => :world => :of => :ruby", ":hello => :goodbye", ":world => :is => :over"]
    expects = names.join(" => ").split(" => ").map { |n| n[/\w+/] }
    names.each { |name| @ga.add name }
    actuals = @ga.nodes.inject([]) { |mem, node| mem << node.id }
    assert_equal(expects, actuals)
  end

end
