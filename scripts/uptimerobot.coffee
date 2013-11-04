# Description:
#   Return site uptime from Uptime Robot service.
#
# Dependencies:
#   uptime-robot
#
# Commands:
#   hubot uptime <filter> - Returns uptime for sites.
#   hubot uptime add-check <url> - Adds a new uptime check.

apiKey = process.env.HUBOT_UPTIMEROBOT_APIKEY

module.exports = (robot) ->

  REGEX = ///
    uptime
    (       # 1)
      \s+   #    whitespace
      (.*)  # 2) filter
    )?
  ///i
  robot.respond REGEX, (msg) ->
    Client = require 'uptime-robot'
    client = new Client apiKey

    filter = msg.match[2]
    data = {}

    client.getMonitors data, (err, res) ->
      if err
        throw err

      monitors = res

      if filter
        query = require 'array-query'
        monitors = query('friendlyname')
          .regex(new RegExp filter, 'i')
          .on res

      for monitor, i in monitors
        name   = monitor.friendlyname
        url    = monitor.url
        uptime = monitor.alltimeuptimeratio
        status = switch monitor.status
          when "0" then "paused"
          when "1" then "not checked yet"
          when "2" then "up"
          when "8" then "seems down"
          when "9" then "down"

        msg.send "Status of #{name} [#{url}]: #{status} (#{uptime}% uptime)"

  robot.respond /uptime add-check (\S+)( (.*))?$/i, (msg) ->
    url = require('url').parse(msg.match[1])
    name = msg.match[3] or url.href

    monitorUrl = url.href if url.protocol
    monitorFriendlyName = name
    msg.http("http://api.uptimerobot.com/newMonitor")
      .query({
        apiKey: apiKey
        monitorFriendlyName: monitorFriendlyName
        monitorURL: monitorUrl
        monitorType: 1
        format: "json"
        noJsonCallback: 1
      })
      .get() (err, res, body) ->
        response = JSON.parse(body)

        if response.stat is "ok"
          msg.send "done"

        if response.stat is "fail"
          msg.send "#{response.message}"
