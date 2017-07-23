module.exports = (robot) ->
  send = (msg) ->
    request = robot.http("http://api.openweathermap.org/data/2.5/weather?q=Tokyo,jp&appid=APIKEY&units=metric").get()

    stMessage = request (err, res, body) ->
      json = JSON.parse body
      weatherName = json['weather'][0]['main']
      icon = json['weather'][0]['icon']
      temp = json['main']['temp']
      temp_max = json['main']['temp_max']
      temp_min = json['main']['temp_min']
      msg.send "今日の東京の天気は「" + weatherName + "」です。\n気温:"+ temp + "℃ 最高気温："  + temp_max+ "℃ 最低気温：" + temp_min + "℃\nhttp://openweathermap.org/img/w/" + icon + ".png"

  robot.hear /hoge/, (msg) ->
    send(msg)
