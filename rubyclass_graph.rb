require "graphaz"

ga = GraphAz.new(:RubyClasses)
ga[:label] = "Ruby Class Map"
ga[:fontsize] = 20
ga[:fontcolor] = 'darkviolet'
ga[:bgcolor] = "whitesmoke"

gnode_set = {
  :shape => 'Mrecord',
  :style => 'filled',
  :height => 0.8,
  :width => 1,
  :fontcolor => 'white'
}

gnode_set.each { |attr, val| ga.gnode[attr] = val }
ga.gedge[:style] = 'dotted'

obj, mod, cla, sta, ins_a, ins_b, ins_c, ker, modA, modB =
  "Object\nclass", "Module\nclass", "Class\nclass", "Standard\nclass", "Instance a", "Instance b", "Instance c", "Kernel\nmodule", "module A", "module B"
  
routes = [
  "#{obj} => #{mod} => #{cla}",
  "#{cla} => #{sta}",
  "#{cla} => #{obj}",
  "#{cla} => #{mod}",
  "#{sta} => #{ins_a}",
  "#{sta} => #{ins_b}",
  "#{sta} => #{ins_c}",
  "#{mod} => #{ker}",
  "#{mod} => #{modA}",
  "#{mod} => #{modB}",
  "#{ker} => #{obj}"
]

def fill_with(color)
  {:style => 'filled', :fillcolor => color }
end

routes.each { |route| ga.add route }

ga.node( ins_a, ins_b, ins_c, modA, modB, ker, :height => 0.5, :width => 0.7, :shape => 'ellipse' )
ga.lap

ga.node( cla, fill_with(:steelblue) )
ga.lap

ga.edge( "#{cla}_#{mod}", "#{cla}_#{obj}", "#{cla}_#{sta}", :style => 'bold', :color => 'steelblue' )
ga.lap

ga.node( obj, mod, sta, fill_with(:steelblue) )
ga.lap

ga.edge( "#{sta}_#{ins_a}", "#{sta}_#{ins_b}", "#{sta}_#{ins_c}", "#{mod}_#{modA}", "#{mod}_#{modB}", "#{mod}_#{ker}", :style => 'bold', :color => 'steelblue' )
ga.lap

ga.node( ins_a, ins_b, ins_c, modA, modB, ker, fill_with(:lightblue).merge(:fontcolor => 'midnightblue') )
ga.lap

ga.edge( "#{ker}_#{obj}", :style => 'none', :color => 'darkviolet' )
ga.lap

ga.node( cla, fill_with(:steelblue) )
ga.lap

ga.node( obj, fill_with(:maroon) )
ga.lap

ga.edge( "#{obj}_#{mod}", :style => 'bold', :color => 'maroon' )
ga.lap

ga.node( mod, fill_with(:maroon) )
ga.lap

ga.edge( "#{mod}_#{cla}", :style => 'bold', :color => 'maroon' )
ga.lap

ga.node( cla, fill_with(:maroon) )
ga.lap

ga.write
