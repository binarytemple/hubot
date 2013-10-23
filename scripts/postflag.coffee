# Description:
#   Posts a US flag icon in Slack chat when a git push happens.
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   smartbot <input>
#
# Author:
#   jgnewman


module.exports = (robot) ->

  robot.hear /\d+ new commits?\:/i, (msg) ->
    msg.send ':us:'
