# Description:
#   Return site uptime from Uptime Robot service.
#
# Dependencies:
#   uptime-robot
#
# Commands:
#   hubot uptime <filter> - Returns uptime for sites.

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
    client = new Client process.env.HUBOT_UPTIMEROBOT_KEY

    interval_days = 1
    filter = msg.match[2]

    data =
      customUptimeRatio: [interval_days]

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
        uptime = monitor.customuptimeratio
        status = switch monitor.status
          when "0" then "paused"
          when "1" then "not checked yet"
          when "2" then "up"
          when "8" then "seems down"
          when "9" then "down"

        msg.send "Status of #{name} [#{url}]: #{status} (#{uptime}% uptime today)"

