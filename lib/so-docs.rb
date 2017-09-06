require 'json'


class SODocs

  
  def initialize()
    @examples = []
  end
  
  def load_examples
    @examples = JSON.parse(IO.read('examples.json')) if @examples.empty?
  end
  
  def index (array, index)
    lookup = {}
    array.each do | node |
      lookup[node[index]] = node
    end
    return lookup
  end

  def index_examples (index)
    load_examples
    return index(@examples, index)
  end
end
