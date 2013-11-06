# Description:
#   View and manage Gittip gifts for a specific user.
#
# Dependencies:
#   array-query
#
# Configuration:
#   HUBOT_GITTIP_APIKEY
#   HUBOT_GITTIP_USERNAME
#   HUBOT_GITTIP_MAXTIP
#
# Commands:
#   hubot gittip giving - Show total of tips.
#   hubot gittip max - Show max tips available via hubot.
#   hubot gittip tips - List individual tips.


module.exports = (robot) ->

  apiKey = process.env.HUBOT_GITTIP_APIKEY
  username = process.env.HUBOT_GITTIP_USERNAME
  maxTip = process.env.HUBOT_GITTIP_MAXTIP
  endpoint = "https://#{apiKey}:@www.gittip.com"

  unless apiKey and username and maxTip
    console.log "twitter_mention.coffee: HUBOT_GITTIP_APIKEY, HUBOT_GITTIP_USERNAME and HUBOT_GITTIP_MAXTIP are required."
    return

  REGEX = ///
    gittip
    (        # 1)
      \s+    #    whitespace
      (\S+)   # 2) cmd
      (      # 3)
        \s+  #    whitespace
        (\S+) # 4) arg
      )?
    )
  ///i

  robot.respond REGEX, (msg) ->
    cmd = msg.match[2]
    arg = msg.match[4]

    switch cmd
      when "giving"
        msg.http("#{endpoint}/#{username}/public.json")
          .get() (err, res, body) ->
            if err
              throw err

            response = JSON.parse(body)

            msg.send "#{username} is currently giving $#{response.giving}/week in tips."

      when "max"
        msg.send "current max availability for weekly tips is $#{maxTip}."

      when "tips"
        filter = arg
        msg.send "Listing tips given by #{username}:"

        msg.http("#{endpoint}/#{username}/tips.json")
          .get() (err, res, body) ->
            if err
              throw err

            tips = JSON.parse(body)

            if filter
              query = require 'array-query'
              tips = query('username')
                .regex(new RegExp filter, 'i')
                .on tips

            printTip = (tip) ->
              msg.send "$#{tip.amount} => #{tip.username}"
            printTip(tip) for tip in tips
