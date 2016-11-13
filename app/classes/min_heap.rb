class MinHeap

  # The children of an element at a given index i will always be in 2i and 2i + 1.
  # The same way, the parent of this node will be at the index i/2.
  # MinHeap has the property that all nodes are larger than their parent
  # smallest element of the minheap is at the root

  attr_accessor :elements, :element_position_map

  # initialize an empty array with nil at the 0 index (to make math easier)
  def initialize
    @elements = [nil]
    @element_position_map = Hash.new
  end

  # override add to array method - preserve the min heap property
  def <<(element)
    @elements << element
    @element_position_map[element.node_data] = @elements.size - 1

    sift_up(@elements.size - 1)
  end


  # this method ensures the min-heap property is retained
  def sift_up(index)

    # we get the parent of the index so we can see if it is larger than the new node
    parent_index = (index / 2)

    # if the index is 1 - no need to continue
    return if index <= 1

    # if the element's parent is less than the current element we return (the min heap property is preserved)
    return if @elements[index] >= @elements[parent_index]

    #otherwise we exchange the two - the smaller element goes into the parent location
    exchange(index, parent_index)

    # and we recursively call this method to keep sifting up the smaller element
    sift_up(parent_index)

  end

  # get the minimum value from the heap
  def peek_min
    return @elements[1]
  end

  # return the actual elements and re-heapify the minheap
  def extract_min

    # exchange the minimum element with the last one in the list
    exchange(1, @elements.size - 1)

    # remove the last element
    min_element = @elements.pop
    @element_position_map.delete(min_element.node_data)


    # make sure the tree is ordered - call the helper method to sift down the new root node into appropriate position
    sift_down(1)

    # return the min element
    return min_element

  end


  def delete_element(element)

    element_position = @element_position_map[element.node_data]

    # exchange the minimum element with the last one in the list
    exchange(element_position, @elements.size - 1)

    # remove the last element
    min_element = @elements.pop
    @element_position_map.delete(min_element.node_data)

    # make sure the tree is ordered - call the helper method to sift down the new root node into appropriate position
    sift_down(element_position)

    return min_element
    #print_heap
  end


  def sift_down(index)

    # get the first child (the left child)
    child_index = (index * 2)

    # if the child index is greater than the size of the array it does not exist and we can return
    return if child_index > @elements.size - 1

    # determine the greater of the two children (if they both exist - and set the child index)
    not_the_last_element = child_index < @elements.size - 1
    left_child = @elements[child_index]
    right_child = @elements[child_index + 1]

    # find the smallest of the two children
    if not_the_last_element && right_child < left_child
      child_index += 1
    end

    # if the element at the current index is smaller than the children, return
    return if @elements[index] <= @elements[child_index]

    #exchange the larger index with the smaller child
    exchange(index, child_index)

    #keep sifting down, this time from the farther along child index
    sift_down(child_index)

  end

  def print_heap
    puts "printing min heap"
    @elements.each do |element|
      if element.nil?
        puts " nil "
      else
        puts element.node_data
      end

    end
  end

  # exchange two elements within the minheap
  def exchange(source_index, target_index)

    tmp_source = @elements[source_index]
    tmp_target = @elements[target_index]

    source_element_position = @element_position_map[tmp_source.node_data]
    target_element_position = @element_position_map[tmp_target.node_data]

    @elements[source_index] = tmp_target
    @elements[target_index] = tmp_source

    @element_position_map[tmp_source.node_data] = target_element_position
    @element_position_map[tmp_target.node_data] = source_element_position

  end

end