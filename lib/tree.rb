class NodeTree
  attr_accessor :data, :left, :right

  def initialize data
    @data = data
    @left = nil
    @right = nil
  end


end

class Tree

  attr_reader :root

  def initialize array
    hash = HashSet.new
    array.each do |element|
      hash.set element
    end
    @root = build_tree(hash.entries.sort)
  end

  def build_tree linked_list
    return nil if linked_list.nil? || linked_list.size == 0
    return NodeTree.new(linked_list.head.value) if linked_list.size == 1

    middle = linked_list.size / 2
    root = NodeTree.new(linked_list.at(middle).value)
    root.left = build_tree(linked_list.split(0, middle-1))
    root.right = build_tree(linked_list.split(middle+1, -1))
    root
  end

  def insert(value)
    # Handle the case where the tree is empty
    if @root.nil?
      @root = NodeTree.new(value)
      return
    end
  
    node = @root
  
    # Traverse the tree to find the correct position
    loop do
      if value == node.data
        return # Value already exists in the tree, do nothing
      elsif value > node.data
        # Go right
        if node.right.nil?
          node.right = NodeTree.new(value)
          return
        else
          node = node.right
        end
      else
        # Go left
        if node.left.nil?
          node.left = NodeTree.new(value)
          return
        else
          node = node.left
        end
      end
    end
  end
  

  def delete value

    node = @root
    parent = nil
    direction = ''

    until node.data == value
      if node.left.nil? && node.right.nil?
        return
      elsif value > node.data
        return if node.right.nil?
        parent = node
        node = node.right
        direction = 'right'
      elsif value < node.data
        return if node.left.nil?
        parent = node
        node = node.left
        direction = 'left'
      end
    end

    #Case 1: Node is a leaf (no children)
    if node.left.nil? && node.right.nil?
      case direction
      when 'right'
        parent.right = nil
      when 'left'
        parent.left = nil
      else
        @root = nil # Special case: Deleting the root when it's the only node
      end

    #Case 2: One Child
    elsif node.left.nil? || node.right.nil?
      child = node.left.nil? ? node.right : node.left
      case direction
      when 'right'
        parent.right = child
      when 'left'
        parent.left = child
      else
        @root = child # Special case: Deleting the root with one child
      end
    
    #Case 3: Two Children
    else
      # Find in-order successor (smallest in right subtree)
      successor_parent = node
      successor = node.right
      until successor.left.nil?
        successor_parent = successor
        successor = successor.left
      end

      # Replace node's value with successor's value
      node.data = successor.data

      # Delete the successor (which will now have at most one child)
      if successor_parent == node
        # Successor is the direct child of the node being deleted
        successor_parent.right = successor.right
      else
        # Successor is deeper in the subtree
        successor_parent.left = successor.right
      end
    end
  end

  def find value
    node = @root
    until node == nil
      if value == node.data
        return node
      elsif value > node.data
        node = node.right
      elsif value < node.data
        node = node.left
      end
    end

    nil
    
  end

  def level_order
    node = nil
    array = []
    queue = LinkedList.new
    queue.prepend @root.dup
    until queue.size == 0
      if block_given?
        node = queue.pop.value
        yield node
        queue.prepend node.left unless node.left.nil?
        queue.prepend node.right unless node.right.nil?
      else
        node = queue.pop.value
        array << node.data
        queue.prepend node.left unless node.left.nil?
        queue.prepend node.right unless node.right.nil?
      end
    end
    if array.length > 0
      return array
    else
      return true
    end
  end

  def inorder(node = @root, array = [], &block)
    return if node.nil?
  
    inorder(node.left, array, &block)
    if block_given?
      yield node
    else
      array << node.data
    end
    inorder(node.right, array, &block)
  
    array unless block_given?
  end

  def preorder(node = @root, array = [], &block)
    return if node.nil?
  
    if block_given?
      yield node
    else
      array << node.data
    end
    preorder(node.left, array, &block)
    preorder(node.right, array, &block)
  
    array unless block_given?
  end

  def postorder(node = @root, array = [], &block)
    return if node.nil?
  
    postorder(node.left, array, &block)
    postorder(node.right, array, &block)
    if block_given?
      yield node
    else
      array << node.data
    end
  
    array unless block_given?
  end

  def height(node)
    return -1 if node.nil? # Base case: height of nil is -1
  
    left_height = height(node.left)  # Recursively calculate left subtree height
    right_height = height(node.right) # Recursively calculate right subtree height
  
    [left_height, right_height].max + 1 # Add 1 for the edge connecting to the parent
  end

  def depth(node, current_node = @root, current_depth = 0)
    return -1 if current_node.nil? # Node not found in the tree
  
    if current_node == node
      current_depth
    elsif node.data < current_node.data
      depth(node, current_node.left, current_depth + 1) # Traverse left
    else
      depth(node, current_node.right, current_depth + 1) # Traverse right
    end
  end

  def balanced?(node = @root)
    return true if node.nil? # An empty tree is balanced
  
    left_height = height(node.left)
    right_height = height(node.right)
  
    # Check the height difference of the current node
    height_difference = (left_height - right_height).abs
  
    # The tree is balanced if:
    # - Height difference is <= 1
    # - Both left and right subtrees are balanced
    height_difference <= 1 && balanced?(node.left) && balanced?(node.right)
  end

  def rebalance
    new_tree = Tree.new(self.inorder)
    @root = new_tree.root
  end


  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end


 

end
