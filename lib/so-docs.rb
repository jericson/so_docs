require 'json'


class SODocs
  def initialize()
    @examples = []
    @contributors = []
  end

  def load_json (file)
    eval("@#{file} = JSON.parse(IO.read('#{file}.json')) if @#{file}.empty?")
  end
                                          
  def index (array, index)
    lookup = {}
    array.each do | node |
      lookup[node[index]] = node
    end
    return lookup
  end

  def multi_index (array, index)
    lookup = {}
    array.each do | node |
      lookup[node[index]] ||= []
      lookup[node[index]].push(node)
    end
    return lookup
  end
  
  def index_examples (index)
    load_json('examples')
    return index(@examples, index)
  end

  def index_contributors (index)
    load_json('contributors')
    return multi_index(@contributors, index)
  end
end
