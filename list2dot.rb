# list2dot
# take a list of nodes and create appropriate dot markup
# input: string of nodes ("1 2\n3 4\n")
# output: nodes marked up to be graphed as dot
# options
#   - leading:  first entry in list is the number of nodes and edges
#               if there is a mismatch, raise error
#   - directed: create a directed graph from list
#   - weights:  third value in entry to be considered as weight and draw
def list2dot(list, options = {})
  return unless list

  entries = list.split("\n")
  return unless entries.count > 0

  if options[:leading]
    options[:nodes], options[:edges] = entries.shift.split(' ').map(&:to_i)
  end

  output = options[:directed] ? "digraph {\n" : "graph {\n"

  list_output, options = make_dot_entries(entries, options)

  output += list_output + '}'

  check_nodes(options)
  check_edges(options)

  output
end

def make_dot_entries(entries, options)
  list_output          = ''
  options[:edge_count] = 0
  options[:node_list]  = {}
  operand              = options[:directed] ? '->' : '--'

  entries.each do |e|
    source, destination, weight = e.split(' ')

    options[:edge_count]       += 1
    options[:node_list][source] = options[:node_list][destination] = 1

    list_output += "#{source} #{operand} #{destination}"
    list_output += " [label=\"#{weight}\"]" if options[:weights] && weight
    list_output += ";\n"
  end

  [list_output, options]
end

def check_nodes(options)
  return unless options[:leading]
  raise ArgumentError unless options[:node_list].keys.count == options[:nodes]
end

def check_edges(options)
  return unless options[:leading]
  raise ArgumentError unless options[:edge_count] == options[:edges]
end
