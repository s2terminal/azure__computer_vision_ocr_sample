require 'sinatra'
require 'net/http'
require 'json'
SECRET_ACCESS_KEY = 'XXXXXXXX'

get '/' do
  if params['url']
    uri = URI('https://westus.api.cognitive.microsoft.com/vision/v2.0/ocr')
    uri.query = URI.encode_www_form({
      # Request parameters
      'language' => 'unk',
      'detectOrientation ' => 'true'
    })

    request = Net::HTTP::Post.new(uri.request_uri)
    # Request headers
    request['Content-Type'] = 'application/json'
    # Request headers
    request['Ocp-Apim-Subscription-Key'] = SECRET_ACCESS_KEY
    # Request body
    request.body = "{'url':'#{params['url']}'}"

    response = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
      http.request(request)
    end

    JSON.parse(response.body)['regions'].each do |region|
      @lines = region['lines'].map do |line|
        line['words'].reduce(""){|txt,word| txt+=word['text'] }
      end
    end
  end

  erb :vision
end
