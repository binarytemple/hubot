# Description:
#   Allows you to slap a user
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   slackbot slap <user>

module.exports = (robot) ->

  robot.respond /(slap|smack) @?([\w .\-]+)$/i, (msg) ->
    user = msg.match[2].trim()
    msg.send('SLAP!! @' + user + ' has been slapped like a B*TCH!')


