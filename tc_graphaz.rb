require "test/unit"
require_relative "graphaz"

@@result = nil
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

  def test_cluster
    @ga.group("lang", "world")
    @ga.group("nolang", "world")
    @ga.add(":ruby => :is => :programming => :language", :group => "lang")
    @ga.add(":pearl => :isnot => :language", :group => "nolang")
    @ga.add(":I => :like => :lisp", :group => "lang")
    @ga.add(":java => javascript", :group => "world")
    @ga.print_graph(:dot => 'out.dot')
  end
end

END{END{
  p @@result
}}