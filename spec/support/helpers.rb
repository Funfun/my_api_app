module Helpers
  def json
    JSON.parse(response.body)
  end

  def headers
    {
      'Accept' => 'application/vnd.example.v1'
    }
  end
end
