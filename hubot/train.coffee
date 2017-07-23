cheerio = require 'cheerio-httpcli'
request = require 'request'

module.exports = (robot) ->
  robot.hear /いく/i, (msg) ->
    odakyu = 'http://transit.yahoo.co.jp/traininfo/detail/110/0/'
    dento = 'http://transit.yahoo.co.jp/traininfo/detail/114/0/'

    searchTrainStatus(odakyu)
#ここに電車の乗り換えの処理を追加する

    searchTrainStatus(dento)
#ここに電車の乗り換えの処理を追加する

  searchTrainStatus = (url) ->
    cheerio.fetch url, (err, $, res) ->

      title = "#{$('h1').text()}"

      if $('.icnNormalLarge').length
        robot.send {room: "random"}, "#{title}は平常運転です。"
      else
        info = $('.trouble p').text()
        robot.send {room: "random"}, "#{title}は遅延してます。\n#{info}"





# 到着時刻を指定して電車検索
  robot.hear /train (\S*) (\S*) (\d{4})/i, (response) ->
    nowTime      = new Date()
    startStation = response.match[1]
    goalStation  = response.match[2]
    month        = nowTime.getFullYear() + '/' + (nowTime.getMonth() + 1)
    day          = nowTime.getDate()
    hour         = response.match[3].slice(0,2)
    minute       = response.match[3].slice(2)
    if(nowTime.getHours() > Number(hour))
      day += 1; # 現在時刻より前の時刻を記載した場合、次の日の検索を行う
    basis        = 0 # 到着時刻で検索
    response.send month + '/' + day + ' ' + hour + ':' + minute + ' に' + goalStation + '駅に到着する'
    searchTrain(startStation, goalStation, month, day, hour, minute, basis, response)

  # 現在時刻から出発する電車検索
  robot.hear /train now/i, (response) ->
    nowTime      = new Date()
    startStation = '湘南台'
    goalStation  = '二子玉川'
    month        = nowTime.getFullYear() + '/' + (nowTime.getMonth() + 1)
    day          = nowTime.getDate()
    hour         = nowTime.getHours()
    minute       = nowTime.getMinutes()
    basis        = 1 # 出発時刻で検索
    response.send 'いまから' + goalStation + '駅に向かう'
    searchTrain(startStation, goalStation, month, day, hour, minute, basis, response)

  # Navitimeスクレイピング関数
  searchTrain = (startStation, goalStation, month, day, hour, minute, basis, response) ->
    searchInfo = {
        orvStationName: startStation,
        dnvStationName: goalStation,
        month         : month,
        day           : day,
        hour          : hour,
        minute        : minute,
        basis         : basis,
      }

    cheerio.fetch 'https://www.navitime.co.jp/', (err, $, res, body) ->
      $('#transfer_form').submit searchInfo, (err, $, res, body) ->

        response.send startStation + ' ' + $('.summary_list').text() + ' ' + goalStation
       #response.send res.request.uri.href


    searchTrainHoge = (startStation, goalStation, month, day, hour, minute, basis, response) ->
      searchInfo = {
          orvStationName: startStation,
          dnvStationName: goalStation,
          month         : month,
          day           : day,
          hour          : hour,
          minute        : minute,
          basis         : basis,
        }

      client.fetch 'https://www.navitime.co.jp/', searchInfo, (err, $, res) ->
        robot.send {room: "random"}, 'fuga'
        test = "#{$('summary_list time').text()}"
        robot.send {room: "random"}, 'hogehoge'
        response.send test
