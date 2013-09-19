# Description:
#   Harasses a user any time he says a Cole-specific phrase.
#
# Overhears:
#   livin' the dream           - Responds with a death threat.
#   ironman                    - Responds angrily about the ironman.
#   cole winans updated a card - Responds angrily about the updated card. 
#

dreamResponses = [
  "Dream as if you'll live forever. Live as if you'll die today... because you will.",
  "You know who you gotta watch out for in your dreams is Freddy Krueger.",
  "You're about to be living a nightmare."
]

module.exports = (robot) ->
  robot.hear /\blivin(g|\')?\ the\ dream\b/i, (msg) ->
    msg.send msg.random dreamResponses

  robot.hear /\bironman\b/i, (msg) ->
    msg.send "Holy crap, nobody cares about your freaking races."


