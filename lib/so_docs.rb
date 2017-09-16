require 'json'
require 'httparty'

class SODocs
  def initialize()
    @topics = []
    @examples = []
    @doctags = []
    @contributors = []
    @contributortypes = []
    @topichistories = []
    @display_names = {}
  end

  def load_json (file)
    # A little meta programming here to simplify things.
    eval("@#{file} = JSON.parse(IO.read('#{file}.json')) if @#{file}.empty?")
    return eval("@#{file}")
  end
                                          
  def index (array, index)
    lookup = {}
    Array(load_json(array)).each do | node |
      lookup[node[index]] = node
    end
    return lookup
  end

  def multi_index (array, index)
    lookup = {}
    Array(load_json(array)).each do | node |
      lookup[node[index]] ||= []
      lookup[node[index]].push(node)
    end
    return lookup
  end
  
  def fetch_display_names(user_ids)
    user_ids.each do | id |
      # Default to userXXXX in case we can't find the user via the API
      @display_names[id] ||= "user#{id}"
    end

    # The API only supports 100 user_ids at a time: http://api.stackexchange.com/docs/users-by-ids
    user_ids.each_slice(100) do | a |
      ids = a.join(';')
      uri = URI("http://api.stackexchange.com/2.2/users/#{ids}")
      params = { :site     => 'stackoverflow',
                 :pagesize => 100 }
      params[:key] = 'vff6LW*9JQzZOECmU1FK1g((' # This is not considered a secret.
      uri.query = URI.encode_www_form(params)
      response = HTTParty.get(uri)
      case response.code
      when 200
        users = JSON.parse(response.body)['items']
        users.each do | user |
          @display_names[user['user_id']] = user['display_name']
        end
      else
        STDERR.puts uri, uri.to_s.length, response.code
        STDERR.puts response
      end
    end
    return @display_names
  end
end
