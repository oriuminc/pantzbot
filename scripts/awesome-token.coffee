# Description:
#   Awesome token API - Slack integration.
#
#   Currently:
#     - See how many tokens we all have with the "tokens" command.
#
# Dependencies:
#   sprintf
#
# Configuration:
#   HUBOT_UF_ENDPOINT
#
# Commands:
#   hubot tokens - list MPDers and their token totals ordered by amount of tokens.
#
# Author:
#   seb@myplanetdigital.com

sprintf  = require('sprintf').sprintf

countTokens = (users) ->
  response = ""
  for user in users
    response += sprintf("%s %-15s\n", user.tokens, user.user)
  response

module.exports = (robot) ->
  robot.respond /tokens$/i, (msg) ->
    url = process.env.HUBOT_UF_ENDPOINT + 'users.json'
    robot.http(url)
      .header('Accept', 'application/json')
      .get() (err, res, body) ->

        data = JSON.parse body

        msg.send countTokens (data)
