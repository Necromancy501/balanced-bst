require_relative 'lib/hashset'
require_relative 'lib/linked_list'
require_relative 'lib/tree'

list = (Array.new(15) { rand(1..100) })
tree = Tree.new list
p tree.balanced?
p tree.level_order, tree.inorder, tree.preorder, tree.postorder

insertions = (Array.new(30) { rand(100..200) })
insertions.each {|number| tree.insert number}

p tree.balanced?
tree.pretty_print
tree.rebalance
p tree.balanced?
tree.pretty_print

p tree.level_order, tree.inorder, tree.preorder, tree.postorder
