require_relative 'lib/hashset'
require_relative 'lib/linked_list'
require_relative 'lib/tree'

hash = HashSet.new

hash.set 1
hash.set 3
hash.set 6
hash.set 4
hash.set 5
hash.set 2
hash.set 9
hash.set 3
hash.set 2
hash.set 3
hash.set 7
hash.set 8
hash.set 10
hash.set 12
hash.set 13
hash.set 14
hash.set 15
hash.set 0
hash.set 11
hash.set 77

list = hash.entries

puts list
list.sort
puts list.sort
