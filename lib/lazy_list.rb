# /lib/lazy_list.rb
require 'set'

class LazyList < Enumerator
  alias_method :all, :to_a

  def select(&block)
    LazyList.new do |yielder|
      self.each do |val|
        yielder.yield(val) if block.call(val)
      end
    end
  end

  def map(&block)
    LazyList.new do |yielder|
      self.each do |val|
        yielder.yield block.call(val)
      end
    end
  end

  def take_while(&block)
    result = []
    enum = self.select { |n| true }
    begin
      val = enum.next
      while block.call(val)
        result << val
        val = enum.next
      end
    rescue StopIteration
    end
    result
  end

  def uniq
    unique_set = Set.new
    LazyList.new do |yielder|
      self.each do |val|
        next if unique_set.include?(val)
        yielder.yield val
        unique_set << val
      end
    end
  end
end