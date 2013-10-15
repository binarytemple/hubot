# Description:
#   Turns hubot into a magic 8 ball
#
# Responds to:
#   "magic 8 ball me [QUESTION]"
#   "magic eight ball me [QUESTION]"
#   "eight ball me [QUESTION]"
#   "8 ball me [QUESTION]" 
#

responses = [
  "It is certain.",
  "It is decidedly so.",
  "Without a doubt.",
  "Yes definitely.",
  "You may rely on it.",
  "As I see it, yes.",
  "Most likely.",
  "Outlook good.",
  "Yes.",
  "Signs point to yes.",
  "Reply hazy. Try again.",
  "Ask again later.",
  "Better not tell you now.",
  "Cannot predict now.",
  "Concentrate and ask again.",
  "Don't count on it.",
  "My reply is no.",
  "My sources say no.",
  "Outlook not so good.",
  "Very doubtful."
]

module.exports = (robot) ->
  robot.respond /(magic\s*)?(8|eight)\s*ball\s*(me\s*)?.+$/i, (msg) ->
    msg.send msg.random responses


