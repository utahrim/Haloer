module ApplicationHelper

  def emblem(gamertag)
    uri = URI('https://www.haloapi.com/profile/h5/profiles/'+ gamertag +'/emblem')
    uri.query = URI.encode_www_form({
        # Request parameters
        'size' => '256'
    })

    request = Net::HTTP::Get.new(uri.request_uri)
    # Request headers
    request['Ocp-Apim-Subscription-Key'] = '3a971b8c52274b3195f02bce66b1a7b4'
    # Request body
    request.body = "{body}"

    response = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
        http.request(request)
    end
    logo = response.to_hash
    return logo["location"].first
  end
end
