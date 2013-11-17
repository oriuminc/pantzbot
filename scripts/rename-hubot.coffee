# Description:
#   Tell people hubot's new name if they use the old one
#
# Commands:
#   None
#
module.exports = (robot) ->
  robot.hear /^slackbot:? (.+)/i, (msg) ->
    response = "Sorry, I'm a diva and only respond to '#{robot.name}' now."
    response += " or #{robot.alias}" if robot.alias
    msg.reply response
    return
