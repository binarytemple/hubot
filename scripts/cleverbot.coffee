# Description:
#   "Makes your Hubot even more Clever™"
#
# Dependencies:
#   "cleverbot-node": "0.1.1"
#
# Configuration:
#   None
#
# Commands:
#   smartbot <input>
#
# Author:
#   ajacksified
#
# Modified by:
#   jgnewman

cleverbot = require('cleverbot-node')

module.exports = (robot) ->
  c = new cleverbot()

  robot.hear /^smartbot\,?\s+(.*)/i, (msg) ->
    data = msg.match[1].trim()
    c.write data, (c) =>
      msg.send(c.message)
