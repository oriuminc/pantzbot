# Description:
#   Return a link to the room's video chat
#
# Commands:
#   hubot call me - Returns a video chat url based on the current room
#   hubot call [help|list|save] <room> - Manages room links //TODO help list
#   hubot whos calling - Returns a list of recent video chats //TODO

callmemaybe = {}

set_room_url = (room, video_url) ->
  callmemaybe[room] = video_url

save = (robot) ->
  robot.brain.data.callmemaybe = callmemaybe

module.exports = (robot) ->
  # Internal: Initialize our brain
  robot.brain.on 'loaded', =>
    callmemaybe = robot.brain.data.callmemaybe

  robot.respond /call save (https?.+)/i, (msg) ->
    room = msg.message.user.room
    chatURL = msg.match[1]
    set_room_url(room, chatURL)
    save(robot)
    theResponse = "Saved " +  chatURL + " for " + room + " chat.\n"
    theResponse += "Can I call you? ;)\n" 

    msg.send theResponse

  robot.respond /call me/i, (msg) ->
    room = msg.message.user.room
    theResponse = "Click here for " + room + " video chat:\n"
    theResponse += callmemaybe[room] + "\n"
    msg.send theResponse
