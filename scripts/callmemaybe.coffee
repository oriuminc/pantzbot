# Description:
#   Return a link to the room's video chat
#
# Commands:
#   hubot call me - Returns a video chat url based on the current room
#   hubot call [help|list|save] <room> - Manages room links //TODO help list
#   hubot whos calling - Returns a list of recent video chats //TODO

callmemaybe = {}

set_chat_url = (room, chatUrl) ->
  callmemaybe[room] ?= ''
  callmemaybe[room] = chatUrl

save = (robot) ->
  robot.brain.data.callmemaybe = callmemaybe

module.exports = (robot) ->
  # Internal: Initialize our brain
  robot.brain.on 'loaded', =>
    callmemaybe = robot.brain.data.callmemaybe

  robot.respond /call save (https?.+)/i, (msg) ->
    room = msg.message.user.room
    chatUrl = msg.match[1]
    set_chat_url(room, chatUrl)
    save(robot)
    theResponse = """
                  Saved chat URL for #{room}.
                  Can I call you? ;)
                  """

    msg.send theResponse

  robot.respond /call me(?! maybe)/i, (msg) ->
    room = msg.message.user.room
    theResponse = """
                  Click here for #{room} video chat:
                  #{callmemaybe[room]}
                  """
    msg.send theResponse

  robot.respond /call me maybe/i, (msg) ->
    theResponse = """
                  Click here for video chat:
                  http://www.youtube.com/watch?v=fWNaR-rxAic
                  """
    msg.send theResponse
