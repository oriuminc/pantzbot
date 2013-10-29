# Description:
#   Race to the bottom.
#
#   Battle it out with your mates to see who is the most
#   important/coolest/sexiest/funniest/smartest of them all solely based on the
#   clearly scientific number of dribbble followers.
#
#   Vanity will check all the follows from a specific dribbble user, and
#   display them in order of their own follow counts.
#
# Dependencies:
#   sprintf
#
# Configuration:
#   HUBOT_DRIBBBLE_USERNAME
#
# Commands:
#   hubot vanity me dribbble - list peeps ordered by dribbble followers.
#
# Author:
#   patcon@myplanetdigital

sprintf  = require('sprintf').sprintf

countFollowers = (msg, members, cb) ->
  counts = []

  members.forEach (member) ->
      member.followers = member.followers_count
      member.login = member.username
      user = member

      keptUser =
        followers: user.followers
        username: member.login

      counts.push keptUser
      if counts.length == members.length
        last     = 0
        response = ""
        counts.sort (x, y) ->
          y.followers - x.followers
        counts.forEach (user) ->
          response += sprintf("%3d %-15s\n", user.followers, user.username)
          last = user.followers
        cb response


module.exports = (robot) ->

  robot.respond /vanity me dribbble$/i, (msg) ->
    master_username = process.env.HUBOT_DRIBBBLE_USERNAME
    robot.http("http://api.dribbble.com/players/#{master_username}/following")
      .header('Accept', 'application/json')
      .get() (err, res, body) ->

        data = JSON.parse body

        countFollowers msg, data.players, (output) ->
          msg.send output
