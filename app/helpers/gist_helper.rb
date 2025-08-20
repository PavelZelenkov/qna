module GistHelper
  require 'net/http'
  require 'json'

  def gist_line_count(gist_url)
    gist_id = gist_url.split('/').last
    api_url = URI("https://api.github.com/gists/#{gist_id}")
    json = JSON.parse(Net::HTTP.get(api_url))
    file = json['files'].values.first
    file['content'].lines.count
  end
end
