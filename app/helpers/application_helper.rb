module ApplicationHelper

  def emblem(gamertag)
    uri = URI('https://www.haloapi.com/profile/h5/profiles/'+ gamertag +'/emblem')
    uri.query = URI.encode_www_form({
        # Request parameters
        'size' => '256'
    })

    request = Net::HTTP::Get.new(uri.request_uri)
    # Request headers
    request['Ocp-Apim-Subscription-Key'] = HALOKEY
    # Request body
    request.body = "{body}"

    response = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
        http.request(request)
    end
    logo = response.to_hash
    return logo["location"].first
  end

  def spartan(gamertag)
    uri = URI('https://www.haloapi.com/profile/h5/profiles/'+ gamertag +'/spartan')
    uri.query = URI.encode_www_form({
        # Request parameters
        'size' => '256'
    })

    request = Net::HTTP::Get.new(uri.request_uri)
    # Request headers
    request['Ocp-Apim-Subscription-Key'] = HALOKEY2
    # Request body
    request.body = "{body}"

    response = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
        http.request(request)
    end
    logo = response.to_hash
    return logo["location"].first
  end

  def stats(gamertag, count)
    uri = URI('https://www.haloapi.com/stats/h5/players/'+ gamertag +'/matches')
    uri.query = URI.encode_www_form({
        # Request parameters
        'count' => count
    })

    request = Net::HTTP::Get.new(uri.request_uri)
    # Request headers
    request['Ocp-Apim-Subscription-Key'] = HALOKEY
    # Request body
    request.body = "{body}"

    response = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
        http.request(request)
    end
    json = JSON(response.body)["Results"]

    i = 0
    results = []
    while i < count.to_i do
        score = {"kills" => json[i]["Players"].first["TotalKills"], "deaths" => json[i]["Players"].first["TotalDeaths"], "assists" => json[i]["Players"].first["TotalAssists"]}
        results << score
        i += 1
    end

    return results


  end
end
