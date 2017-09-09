require 'json'


class SODocs
  def initialize()
    @topics = []
    @examples = []
    @doctags = []
    @contributors = []
    @topichistories = []
    @display_names = {}
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
  
  def index_topics (index)
    load_json('topics')
    return index(@topics, index)
  end

  def index_examples (index)
    load_json('examples')
    return index(@examples, index)
  end

  def index_tags (index)
    load_json('doctags')
    return index(@doctags, index)
  end
  
  def index_contributors (index)
    load_json('contributors')
    return multi_index(@contributors, index)
  end

  def fetch_display_names(user_ids)
    user_ids.each do | id |
      # Default to userXXXX in case we can't find the user via the API
      @display_names[id] ||= "user#{id}"
    end
    
    ids = user_ids.join(';')
    uri = URI("http://api.stackexchange.com/2.2/users/#{ids}?site=stackoverflow")
    response = HTTParty.get(uri)
    case response.code
    when 200
      users = JSON.parse(response.body)['items']
      users.each do | user |
        @display_names[user['user_id']] = user['display_name']
      end
    else
      STDERR.puts uri, response.code
    end
    return @display_names
  end
end
