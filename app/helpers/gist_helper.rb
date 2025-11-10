module GistHelper
  require 'net/http'
  require 'json'

  def gist_line_count(gist_url)
    gist_id = gist_url.to_s.split("/").last
    return 0 if gist_id.blank?

    api_url = URI("https://api.github.com/gists/#{gist_id}")
    res = Net::HTTP.get_response(api_url)

    return 0 unless res.is_a?(Net::HTTPSuccess)

    json = JSON.parse(res.body) rescue {}
    files = json["files"] || {}

    return 0 if files.blank?

    first_file = files.values.first
    content = first_file && first_file["content"]
    return 0 if content.blank?

    content.lines.count
  rescue StandardError => e
    Rails.logger.warn("[gist_helper] #{e.class}: #{e.message}")
    0
  end

end
