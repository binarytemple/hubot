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

hockeyResponses = [
  "Oh boy are you guys talking about hockey again? What an interesting topic!",
  "Yay another hockey discussion. Good thing we're not wasting time in here.",
  "Shouldn't you be working on Factals instead of talking about hockey?"
]

pct33 = [0, 1, 2]

pct50 = [0, 1]

module.exports = (robot) ->
  robot.hear /\blivin(g|\')?\ the\ dream\b/i, (msg) ->
    msg.send msg.random dreamResponses

  robot.hear /\bironman\b/i, (msg) ->
    msg.send "Holy crap, nobody cares about your freaking races."

  robot.hear /\b(hockey|skate|skating)\b/i, (msg) ->
    msg.send msg.random hockeyResponses

  robot.hear /ha(ha)+/i, (msg) ->
    choice = msg.random pct33
    msg.send 'hahaha' unless choice isnt 0

