require "graphviz"

class GraphAz
  attr_accessor :graph, :nodes, :edges, :gnode, :gedge
  def initialize(name= :G, *opt, &blk)
    @graph = GraphViz.new(name, *opt, &blk)
    @gnode, @gedge = @graph.node, @graph.edge
    @nodes, @edges = [], {}
    @@lap, @laps = 0, []
    @groups = []
  end

  def [](attr)
    @graph[attr]
  end
  
  def []=(attr, val)
    @graph[attr] = val
  end
  
  def add(s, attrs={})
    if group = attrs.delete(:group)
      add_group(group)
    end
    names = s.split(/\s*=>\s*/).map { |n| n.sub(/^:/, '') }
    #add_node
    nodes = names.inject([]) do |mem, name|
      attrs[:label] = name
      receiver = @graph
      if group
        @graph.send("cluster_#{@groups.index(group)}") do |c|
          c[:label => group]
          receiver = c
        end
      end
      @nodes << node = receiver.add_node(name, attrs)
      mem << node
    end
    #add_edge
    nodes.each_cons(2) do |a, b|
      @edges["#{a.id}_#{b.id}"] = @graph.add_edge(a, b)
    end
    @graph
  end
  
  def node(*nodes, opts)
    nodes.each do |node|
      opts.each { |attr, val| @graph.get_node(node)[attr] = val  }
    end
  end
  
  def edge(*edges, opts)
    @edges.each do |name, edge|
      next unless edges.empty? or edges.include?(name)
      opts.each { |attr, val| edge.set { |e| e.send(attr, val) } }
    end
  end

  #WARN: need to call before add method
  def group(gname, parent=nil)
    add_group(gname)
    receiver = @graph
    if parent #nested group
      add_group(parent)
      @graph.send("cluster_#{@groups.index(parent)}") do |c|
        c[:label => parent]
        receiver = c
      end
    end
    receiver.send("cluster_#{@groups.index(gname)}") { |cl| cl[:label => gname] }
  end

  def add_group(name)
    @groups.none? { |g| g == name } ? @groups << name : nil
  end
  private :add_group

  def print_graph(args={}, &blk)
    @graph.output(args, &blk)
  end

  def lap(args={:png => "out#{@@lap}.png"}, &blk)
    print_graph(args, &blk)
    @@lap += 1
    @laps << args[:png]
  end
  
  def write(opts={})
    require "RMagick"
    puts 'processing...'
    opts = {:delay => 50, :filename => 'out.gif', :delete => true}.merge(opts)
    list = Magick::ImageList.new(*@laps)
    list.delay = opts[:delay]
    list.write(opts[:filename])
    puts "'#{opts[:filename]}' created!"
  rescue Exception => e
    puts "Failed attempt to create animation gif : #{e}"
  ensure
    @laps.each { |f| File.delete(f) if opts[:delete] }
    @laps.clear
  end
end

if __FILE__ == $0
  ga = GraphAz.new(:Dijkstra, :type => 'graph')

  ga['rankdir'] = 'LR'
  ga['label']   = "Dijkstra's Algorithm"
  ga['bgcolor'] = 'whitesmoke'
  routes = [
    ':S => :A => :G',
    ':S => :B => :D => :G',
    ':S => :C => :D',
    ':A => :B => :C' 
  ]

  edge_labels = {
    '2' => ['A_B', 'S_C', 'B_D'],
    '3' => ['B_C'],
    '4' => ['S_B', 'D_G'],
    '5' => ['S_A'],
    '6' => ['C_D', 'A_G']
  }

  routes.each { |route| ga.add route }
  edge_labels.each { |label, edges| ga.edge(*edges, :label => label) }
  ga.lap

  color = 'blueviolet'

  ga.node('S', :style => 'filled', :fillcolor => color)
  ga.lap
  ga.edge('S_B', :color => color)
  ga.lap
  ga.node('B', :style => 'filled', :fillcolor => color)
  ga.lap
  ga.edge('B_D', :color => color)
  ga.lap
  ga.node('D', :style => 'filled', :fillcolor => color)
  ga.lap
  ga.edge('D_G', :color => color)
  ga.lap
  ga.node('G', :style => 'filled', :fillcolor => color)
  ga.lap

  ga.write
end
