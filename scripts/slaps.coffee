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

  robot.respond /slap @?([\w .\-]+)\?*$/i, (msg) ->
    user = msg.match[1].trim()
    msg.send('SLAP!! @' + user + ' has been slapped like a B*TCH!')


