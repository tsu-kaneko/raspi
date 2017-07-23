
module.exports = (robot) ->
  robot.hear /who are you/i, (msg) ->
    msg.send "I'm hubot!"

  robot.hear /hello/i, (msg) ->
    msg.send "hello!!!!"

  robot.hear /who am I/i, (msg) ->
    msg.send "You are #{msg.message.user.name}"

  robot.hear /what is this (.*)/i, (msg) ->
    msg.send "This is #{msg.match[1]}"


  robot.hear /temp/i, (msg) ->
    @exec = require('child_process').exec
    command = "sudo /home/pi/python_apps/Adafruit_Python_DHT/examples/AdafruitDHT.py 11 4"
    @exec command, (error, stdout, stderr) ->
      msg.send error if error?
      msg.send stdout if stdout?
      msg.send stderr if stderr?

  robot.hear /wether/i, (msg) ->
    request = msg.http('http://weather.livedoor.com/forecast/webservice/json/v1?city=130010')
    .get()
    request (err, res, body) ->
      json = JSON.parse body
      forecast = json['forecasts'][day]['telop']
      msg.reply forecast

  robot.hear /(.*)の天気教えてん/i, (msg) ->
    switch msg.match[1]
      when '今日'
        day = 0
      when '明日'
        day = 1
      when '明後日'
        day = 2
      else
        day = 3
        break
    request = msg.http('http://weather.livedoor.com/forecast/webservice/json/v1?city=270000')
    .get()
    request (err, res, body) ->
      json = JSON.parse body
      if day == 3 then forecast = 'わからん...' else forecast = json['forecasts'][day]['telop']
      msg.reply forecast

  robot.hear /todaywether/, (msg) ->
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



  robot.respond /aaaaa/i, (res) ->
    request = robot.http("http://weather.livedoor.com/forecast/webservice/json/v1?city=270000").get()
    request (err, mes, body) ->
      json = JSON.parse body
      message_row = "今日の天気は#{json.forecasts[0].telop}です。#{json.description.text}"
      message = message_row.replace(/\r?\n|[ ]/g,"")
      console.log(message)
      say(res, message)

  robot.respond /ohayou/i, (msg) ->
    msg.send "ohayou"
