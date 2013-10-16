# Description:
#   Passes questions along to Wolfram Alpha
#
# Commands:
#   hubot ping - Reply with pong
#   hubot echo <text> - Reply back with <text>
#   hubot time - Reply with current time
#   hubot die - End hubot process

appid = process.env.WOLFRAM_APPID

Wolfram = require('wolfram-alpha').createClient(appid)

module.exports = (robot) ->
  robot.respond /wolfram(\s+alpha)?\s+(.+)$/i, (msg) ->
    question = msg.match[2]
    Wolfram.query question, (e, result) ->
      if result and result.length > 0
        msg.send obj.subpods[0].text for obj in result when obj.title is 'Solution' 
      else
        msg.send 'Hmm... not sure.'
