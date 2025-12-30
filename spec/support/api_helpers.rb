module ApiHelpers
  def json
    @json ||= JSON.parse(response.body)
  end

  def do_request(method, path, options = {})
    public_send(method, path, **options)
  end
end
