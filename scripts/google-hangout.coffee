# hangout <room name> provides a link to the proper GoogleHangout
module.exports = (robot) ->
  robot.respond /(hangout|standup)\s?(.*)?/i, (msg) ->
    roomname = msg.message.user.room
    link = "https://talkgadget.google.com/hangouts/extras/dockyard.com/"+roomname+"?authuser=0&hl=en&eid"
    msg.send("Join " + roomname)
    msg.send(link)
