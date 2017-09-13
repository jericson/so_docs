require 'json'
require 'httparty'

class Wayback
  def initialize (url)
    @url = url
    @snapshots = {}
    
  end
  
  def check_status
    # Based on https://blog.archive.org/2013/10/24/web-archive-404-handler-for-webmasters/
    check_url = URI('https://archive.org/wayback/available.php?url=' + @url)
    response = HTTParty.get(check_url)
    puts check_url
    
    @snapshots = JSON.parse(response.body)['archived_snapshots']

    return !@snapshots.empty? && @snapshots['closest']['available']
  end

  def save_page
    # Don't try it save if the source is missing
    response = HTTParty.get(@url)
    puts @url, response.code#, response.message, response.headers.inspect
    return false if response.code != 200

    # Don't try to save if the Wayback Machine has a copy available
    # TODO: implement a force option to skip this check.
    return true if check_status()

    save_url = URI('https://web.archive.org/save/' + @url)
    puts save_url

    response = HTTParty.get(save_url)
    puts response.code, response.message, response.headers.inspect

    # Verify that the save operation worked
    return false unless response.code == 200
    return check_status()
  end

  def archive_url
    return @snapshots['closest']['url']
  end
end
