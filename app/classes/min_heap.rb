class MinHeap

  # The children of an element at a given index i will always be in 2i and 2i + 1.
  # The same way, the parent of this node will be at the index i/2.
  # MinHeap has the property that all nodes are larger than their parent
  # smallest element of the minheap is at the root

  # initialize an empty array with nil at the 0 index (to make math easier)
  def initialize
    @elements = [nil]
  end

  # override add to array method - preserve the min heap property
  def <<(element)
    @elements << element

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

  # exchange two elements within the minheap
  def exchange(source, target)
    @elements[source], @elements[target] = @elements[target], @elements[source]

  end

  # get the minimum value from the heap
  def peek_min
    return @elements[1]
  end

  # return the actual elements and re-heapify the minheap
  def pop

    # exchange the minimum element with the last one in the list
    exchange(1, @elements.size - 1)

    # remove the last element
    min_element = @elements.pop

    # make sure the tree is ordered - call the helper method to sift down the new root node into appropriate position
    sift_down(1)

    # return the min element
    return min_element

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

    #keep sifting down, this time from the farter along child index
    sift_down(child_index)

  end

end