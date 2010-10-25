require "test/unit"
require_relative "graphaz"

@@result = []
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
    @ga.group("lang", :parent => "one world", :style => 'filled', :color => 'lightgrey')
    @ga.group("nolang", :parent => "one world", :style => 'filled', :color => 'yellow')
    @ga.add(":ruby => :is => :programming => :language", :group => "lang", :style => 'filled', :color => 'maroon')
    @ga.add(":pearl => :is\nnot => :language", :group => "nolang")
    @ga.add(":I => :like => :lisp", :group => "lang")
    @ga.add(":java => javascript", :group => "one world")
    @ga.print_graph(:dot => 'out.dot')
  end

  def test_set_attribute_for_group_node
    @ga.add(":hello\ngoodbye => :world", :group => "Salute")
    @ga.node("hello\ngoodbye", :shape => 'circle', :style => 'filled', :color => 'green')
    @ga.print_graph(:png => 'hello.png')
  end
end

END{END{
  p @@result
}}