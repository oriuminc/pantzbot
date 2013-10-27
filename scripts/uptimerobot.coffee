# Description:
#   Return site uptime from Uptime Robot service.
#
# Commands:
#   hubot uptime - Returns uptime for sites.

module.exports = (robot) ->
  robot.respond /uptime (.*)/i, (msg) ->
    Client = require 'uptime-robot'
    client = new Client process.env.HUBOT_UPTIMEROBOT_KEY

    interval_days = 1
    filter = msg.match[1]

    data =
      customUptimeRatio: [interval_days]

    client.getMonitors data, (err, res) ->
      if err
        throw err

      query = require 'array-query'
      matches = query('friendlyname')
        .regex(///
          #{filter}
        ///i)
        .on res

      for match, i in matches
        name = match.friendlyname
        url = match.url
        uptime = match.customuptimeratio
        status = switch match.status
          when "0" then "paused"
          when "1" then "not checked yet"
          when "2" then "up"
          when "8" then "seems down"
          when "9" then "down"

        msg.send "Status of #{name} [#{url}]: #{status} (#{uptime}% uptime today)"

