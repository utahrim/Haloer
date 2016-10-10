class PlayersController < ApplicationController

  helper_method :save_file
  def index
  end

  def gamer
    get_player_and_count(params[:gamertag], params[:count])
    # @spartan = spartan(@player)
    # @emblem = emblem(@player)
    @results = stats(@player, @count)
  end

  def get_player_and_count(player, count)
    @player = params[:gamertag]
    if params[:count].to_i > 25
      @count = "25"
    else
      @count = params[:count]
    end
  end

  def save_file(game_events)
    doc = "#{@player}.json"
    File.open(doc, "w"){ |f| f << "#{@player}-#{Time.now}"}
    game_events = JSON.pretty_generate(game_events)
    # game_events.each do |match|
    #   File.open(doc, "a+"){ |f| f << "\n\n Game #{o} \n\n"}
    File.open(doc, "a+"){ |f| f << (game_events)}
    #   o += 1
    # end
    send_file(doc, :type => 'application/json; charset=utf-8')
  end

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
      
      @count == count
      if @count == ""
          @count = "5"
      end
    uri.query = URI.encode_www_form({
        # Request parameters
          'count' => @count
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

    match_id = get_match_id(json)
    game_events = match_events(match_id)
    get_results(json)
    save_file(game_events)

  end

  def match_events(match_id)
    t = 0
    matches = []
    match_id.each do |m_id|

      if t%3 == 0
        sleep(2)
      end
      uri = URI('https://www.haloapi.com/stats/h5/matches/' + "#{m_id}" + '/events')
      uri.query = URI.encode_www_form({
      })

      request = Net::HTTP::Get.new(uri.request_uri)

      # Request headers
      if t%2 == 0
        request['Ocp-Apim-Subscription-Key'] = HALOKEY2
      else
        request['Ocp-Apim-Subscription-Key'] = HALOKEY
      end
      t += 1
      # Request body
      request.body = "{body}"

      response = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
          http.request(request)
      end
      matches << JSON(response.body)["GameEvents"]
    end
    matches
  end

  def get_match_id(match)
    match_id_array = []
    match.each do |game|
      id = game["Id"]["MatchId"]
      match_id_array << id
    end
    match_id_array
  end

  def get_results(json)
    i = 0
    results = []
    while i < @count.to_i do
        score = {"kills" => json[i]["Players"].first["TotalKills"], "deaths" => json[i]["Players"].first["TotalDeaths"], "assists" => json[i]["Players"].first["TotalAssists"]}
        results << score
        i += 1
    end

    return results
  end
end
