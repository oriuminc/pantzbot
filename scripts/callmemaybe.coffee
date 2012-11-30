# Description:
#   Return a link to the room's video chat
#
# Commands:
#   hubot call me - Returns the video chat url for the current room
#   hubot call set <url> - Sets the video chat url for the current room

set_chat_url = (callmemaybeData, room, chatUrl) ->
  callmemaybeData[room] = chatUrl

module.exports = (robot) ->
  # Internal: Initialize our brain
  robot.brain.on 'loaded', =>
    robot.brain.data.callmemaybe ||= {}

  robot.respond /call set (https?.+)/i, (msg) ->
    callmemaybeData = robot.brain.data.callmemaybe
    room = msg.message.user.room
    chatUrl = msg.match[1]
    set_chat_url(callmemaybeData, room, chatUrl)
    msg.send "Saved chat URL for #{room}. Can I call you? ;)"

# To re-enable Carly Rae Jepsen:
#  - replace line 27 with line 26
#  - replace line 32 with 31
#  robot.respond /call me( maybe)?/i, (msg) ->
   robot.respond /call me( video)?/i, (msg) ->
    room = msg.message.user.room
    chatUrl = robot.brain.data.callmemaybe[room]
    if msg.match[1]?
#     chatUrl = "http://www.youtube.com/watch?v=fWNaR-rxAic"
      chatUrl = "https://hall.com/hall_video/honeybadgers/video"
    msg.send "Click here for #{room} video chat: #{chatUrl}"
