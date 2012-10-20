# Description:
#   Return a link to the room's video chat
#
# Commands:
#   hubot call me - Returns the video chat url for the current room
#   hubot call set <chatUrl> - Sets the video chat url for the current room

callmemaybe = {}

set_chat_url = (msg, room, chatUrl) ->
  console.log "chatUrl: #{chatUrl}"
  console.log "room: #{room}"
  callmemaybe[room] ?= ''
  callmemaybe[room] = chatUrl
  msg.send "Saved chat URL for #{room}. Can I call you? ;)"


save = (robot) ->
  robot.brain.data.callmemaybe = callmemaybe

module.exports = (robot) ->
  # Internal: Initialize our brain
  robot.brain.on 'loaded', =>
    callmemaybe = robot.brain.data.callmemaybe

  robot.respond /call set (https?.+)/i, (msg) ->
    room = msg.message.user.room
    chatUrl = msg.match[1]
    set_chat_url(msg, room, chatUrl)
    save(robot)

  robot.respond /call me( maybe)?/i, (msg) ->
    room = msg.message.user.room
    chatUrl = callmemaybe[room]
    if msg.match[1]?
      chatUrl = "http://www.youtube.com/watch?v=fWNaR-rxAic"
    msg.send "Click here for #{room} video chat: #{chatUrl}"
