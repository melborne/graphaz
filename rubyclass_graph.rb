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

ga.add "Object\nclass => Module\nclass => Class\nclass"
ga.add "Class\nclass => Standard\nclass"
ga.add "Class\nclass => Object\nclass"
ga.add "Class\nclass => Module\nclass"
ga.add "Standard\nclass => Instance a"
ga.add "Standard\nclass => Instance b"
ga.add "Standard\nclass => Instance c"
ga.add "Module\nclass => Kernel\nmodule"
ga.add "Module\nclass => module A"
ga.add "Module\nclass => module B"
ga.add "Kernel\nmodule => Object\nclass"

ga.node( "Instance a", "Instance b", "Instance c",
         "module A", "module B", "Kernel\nmodule",
         :height => 0.5, :width => 0.7, :shape => 'ellipse' )
ga.lap
ga.node( "Class\nclass", :style => 'filled', :fillcolor => 'steelblue' )
ga.lap
ga.edge( "Class\nclass_Module\nclass", "Class\nclass_Object\nclass",
         "Class\nclass_Standard\nclass",
         :style => 'bold', :color => 'steelblue' )
ga.lap
ga.node( "Object\nclass", "Module\nclass", "Standard\nclass",
         :style => 'filled', :fillcolor => 'steelblue' )
ga.lap
ga.edge( "Standard\nclass_Instance a", "Standard\nclass_Instance b",
         "Standard\nclass_Instance c", "Module\nclass_module A",
         "Module\nclass_module B", "Module\nclass_Kernel\nmodule",
         :style => 'filled', :color => 'steelblue' )
ga.lap
ga.node( "Instance a", "Instance b", "Instance c",
         "module A", "module B", "Kernel\nmodule",
         :fillcolor => 'lightblue', :fontcolor => 'midnightblue' )
ga.lap
ga.edge( "Kernel\nmodule_Object\nclass",
         :style => 'none', :color => 'darkviolet' )
ga.lap
ga.node( "Class\nclass", :style => 'filled', :fillcolor => 'steelblue' )
ga.lap
ga.node( "Object\nclass", :style => 'filled', :fillcolor => 'maroon' )
ga.lap
ga.edge( "Object\nclass_Module\nclass", :style => 'bold', :color => 'maroon' )
ga.lap
ga.node( "Module\nclass", :style => 'filled', :fillcolor => 'maroon' )
ga.lap
ga.edge( "Module\nclass_Class\nclass", :style => 'bold', :color => 'maroon' )
ga.lap
ga.node( "Class\nclass", :style => 'filled', :fillcolor => 'maroon' )
ga.lap

ga.write
