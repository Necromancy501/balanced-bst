module MergeSort
  def merge_sort linked_list
    return linked_list if linked_list.size == 1
    middle = linked_list.size / 2
    merge merge_sort(linked_list.split(0, middle-1)), merge_sort(linked_list.split(middle, -1))
  end
  
  def merge(left, right)
    result = LinkedList.new
    until left.size == 0 || right.size == 0 do
      a = left.head.value
      b = right.head.value
      result.append( a <= b ? left.delete_at(0).value : right.delete_at(0).value)
    end
    result + left + right
  end
end

class LinkedList

  attr_accessor :head

  include MergeSort

  def initialize
    @head = Node.new
  end

  def each
    aux_ptr = @head
    until aux_ptr == nil
      yield aux_ptr.value
      aux_ptr = aux_ptr.next_node
    end    
  end

  def append value

    if @head.value == nil
      @head.value = value
      return
    end

    aux_ptr = @head
    until aux_ptr.next_node == nil
      aux_ptr = aux_ptr.next_node
    end
    aux_ptr.next_node = Node.new value

  end

  def prepend value
    aux_ptr = @head.dup
    @head = Node.new value
    @head.next_node = aux_ptr
  end

  def size
    aux_ptr = @head
    i=0
    until aux_ptr == nil
      i+=1 unless aux_ptr.value == nil
      aux_ptr = aux_ptr.next_node
    end
    i
  end

  def tail
    aux_ptr = @head
    until aux_ptr.next_node == nil
      aux_ptr = aux_ptr.next_node
    end
    aux_ptr
  end

  def at index
    i = 0
    aux_ptr = @head
    until i >= index || aux_ptr.next_node == nil
      aux_ptr = aux_ptr.next_node
      i+=1
    end
    aux_ptr
  end

  def pop

    if self.size == 1
      value = @head.dup
      @head = Node.new
      return value
    end

    aux_ptr = @head
    i = 0
    until aux_ptr.next_node == nil
      aux_ptr = aux_ptr.next_node
      i+=1
    end

    self.at(i-1).next_node = nil
    aux_ptr

  end

  def contains? value
    aux_ptr = @head
    until aux_ptr == nil
      if aux_ptr.value == value
        return true
      else
        aux_ptr = aux_ptr.next_node
      end
    end
    false
  end

  def find value
    aux_ptr = @head
    i = 0
    until aux_ptr == nil
      if aux_ptr.value == value
        return i
      else
        aux_ptr = aux_ptr.next_node
        i+=1
      end
    end
    nil
  end

  def insert_at value, index

    aux_ptr = self.at(index).dup

    case index
    when 0
      self.prepend value
    when -1, self.size
      self.append value
    else
      self.at(index-1).next_node = Node.new value
      self.at(index).next_node = aux_ptr
    end

  end

  def delete_at index

    node_copy = self.at(index).dup

    case index
    when 0
      if @head.next_node == nil
        self.pop
        return node_copy
      end
      @head = @head.next_node
    when -1, self.size
      self.pop
    else
      self.at(index-1).next_node = self.at(index).next_node 
    end
    node_copy
  end

  def split(index_s, index_e)
    index_e = index_e == -1 ? self.size - 1 : index_e
    new_list = LinkedList.new
    current = self.at(index_s)
    while current && index_s <= index_e
      new_list.append(current.value)
      current = current.next_node
      index_s += 1
    end
  new_list
  end

  def +(other)

    if self.size == 0
      return other
    elsif other.size == 0
      return self
    end

    new_list = LinkedList.new
    self.each { |value| new_list.append(value) }
    other.each { |value| new_list.append(value) }
    new_list

  end

  def to_s
    aux_ptr = @head
    string = ""
    until aux_ptr == nil
      string += " [#{aux_ptr.value}] ->"
      aux_ptr = aux_ptr.next_node
    end
    return string += " nil"
  end

  def sort
    merge_sort self
  end
end

class Node

  attr_accessor :next_node, :value

  def initialize value=nil
    @value = value 
    @next_node = nil
  end

end