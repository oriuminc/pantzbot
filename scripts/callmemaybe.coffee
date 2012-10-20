# Description:
#   Return a link to the room's video chat
#
# Commands:
#   hubot call me - Returns the video chat url for the current room
#   hubot call set <chatUrl> - Sets the video chat url for the current room

callmemaybe = {}

set_chat_url = (room, chatUrl) ->
  console.log "chatUrl: #{chatUrl}"
  console.log "room: #{room}"
  callmemaybe[room] ?= ''
  callmemaybe[room] = chatUrl

save = (robot) ->
  robot.brain.data.callmemaybe = callmemaybe

module.exports = (robot) ->
  # Internal: Initialize our brain
  robot.brain.on 'loaded', =>
    callmemaybe = robot.brain.data.callmemaybe

  robot.respond /call set (https?.+)/i, (msg) ->
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
