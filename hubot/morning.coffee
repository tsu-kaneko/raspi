cronJob = require('cron').CronJob
cheerio = require 'cheerio-httpcli'

module.exports = (robot) ->
  send = (room, msg) ->
    response = new robot.Response(robot, {user : {id : -1, name : room}, text : "none", done : false}, [])
    response.send msg

  # *(sec) *(min) *(hour) *(day) *(month) *(day of the week)
  new cronJob('0 00 07 * * *', () ->

    robot.messageRoom "random", 'おはようございます'

    request = robot.http('http://weather.livedoor.com/forecast/webservice/json/v1?city=130010')
    .get()

    #request = robot.http("http://api.openweathermap.org/data/2.5/weather?q=Tokyo,jp&appid=APIKEY&units=metric").get()

    day = 1

    request (err, res, body) ->
      json = JSON.parse body
      terop = json['forecasts'][day]['telop']
      maxCelsius = json['forecasts'][day]['temperature']['max']['celsius']
      minCelsius = json['forecasts'][day]['temperature']['min']['celsius']
      robot.messageRoom "random", "今日の東京の天気は、#{terop}で最高気温は#{maxCelsius}℃ 最低気温は#{minCelsius}℃ です "

      #temp = json['message']
      #robot.messageRoom "random", "今日の東京の気温は、#{temp}です。"


    @exec = require('child_process').exec
    command = "sudo /home/pi/python_apps/Adafruit_Python_DHT/examples/AdafruitDHT.py 11 4"
    @exec command, (error, stdout, stderr) ->
      robot.messageRoom "random", error if error?
      robot.messageRoom "random", stdout if stdout?
      robot.messageRoom "random", stderr if stderr?

  ).start()
