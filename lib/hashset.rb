module Prime
  def next_prime(n)
    n += 1
    n += 1 until prime?(n)
    n
  end
  
  def prime?(n)
    return false if n < 2
    (2..Math.sqrt(n)).none? { |i| n % i == 0 }
  end
end

class HashSet

  include Prime
  
  def initialize
    @load_factor = 0.75
    @capacity = 13
    @buckets = Array.new(@capacity) { LinkedList.new }
  end

  def hash(key)

    hash_code = 0
    prime_number = 31
       
    key.to_s.each_char { |char| hash_code = prime_number * hash_code + char.ord }

    hash_code ^= (hash_code >> 16)
    hash_code *= 0x85ebca6b
    hash_code ^= (hash_code >> 13)
       
    hash_code
  end

  def code key
    self.hash(key) % @capacity
  end

  def set key

    if self.size >= (@capacity * @load_factor)
      data = self.entries.dup
      @capacity = next_prime(@capacity * 2)
      self.clear
      data.each do |keys|
        code = self.code(keys)
        @buckets[code].append keys
      end
    end

    code = self.code(key)

    @buckets[code].each do |keys|
      if keys == nil
        @buckets[code].append key
        return
      elsif keys == key
        return
      end
    end

    @buckets[code].append(key)


  end

  def get key
    code = self.code(key)
    @buckets[code].each do |keys|
      if keys == key
        return keys
      end
    end
  end

  def has? key
    code = self.code(key)
    @buckets[code].each do |keys|
      if keys == key
        return true
      end
    end
    false
  end

  def remove key

    if self.has?(key) == false
      return nil
    end

    code = self.code key
    i = 0
    @buckets[code].each do |keys|
      if keys == key
        value = keys.dup
        @buckets[code].delete_at i
        return value
      end
      i+=1
    end
  end

  def size
    i = 0
    @buckets.each do |bucket|
      i+=bucket.size
    end
    i
  end

  def clear
    @buckets = Array.new(@capacity) { LinkedList.new }
  end

  def entries
    entries_list = LinkedList.new
    @buckets.each do |bucket|
      unless bucket == nil
        bucket.each do |keys|
          entries_list.append keys unless keys == nil
        end
      end
    end
    entries_list
  end

  def to_s
    @buckets.each {|b| puts b}
  end
end