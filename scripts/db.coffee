# Description:
#   Allows hubot to integrate with a JSON file
#
# Commands:
#   hubot fake event <event> - Triggers the <event> event for debugging reasons
#

fs         = require 'fs'
path       = require 'path'
db_loc     = path.resolve __dirname, '../db-sim.json'
orig_state = {"users":{}}
db_cache   = JSON.parse fs.readFileSync(db_loc).toString()
locks      = 0
 
#
# Tries to perform an asynchronous action.
# If the action is locked, waits 10ms then tries again.
# If we try more than 1000 times, we assume a problem
# and throw an error
#
# @param {Function} fn   - The asynchronous action to perform
# @param {Number}   recs - The number of tries already attempted.
#
# @returns {void}
#
defer = (fn, recs) ->
  recs = recs or 0
  if recs > 1000
    throw new Error('TOO MUCH RECURSION!');
  if locks > 0
    setTimeout (-> defer(fn, recs + 1)), 10
  else
    fn()

#
# Defers itself and...
# Locks asynchronous actions, writes the current db_cache
# to file, then unlocks asynchronous actions.
#
# @returns {void}
#
write_db = ->
  defer ->
    locks = locks + 1
    fs.writeFile db_loc, JSON.stringify(db_cache), ->
      locks = locks - 1

#
# Checks to see if a user exists.
#
# @returns {Boolean}
#
user_exists = (user) ->
  Object::hasOwnProperty.call db_cache.users, user

#
# Registers a new user in the db.
#
register_user = (user, msg) ->
  db_cache.users[user] = {
    "roles" : [],
    "stars" : 0
  }
  write_db()
  msg and msg.send('Ok, I just registered ' + user + '.')

#
# Checks to see if a user has a particular role.
# NOTE: Assumes you have already checked to see if the
# user exists.
#
# @returns {Boolean}
#
has_role = (user, role) ->
  (x for x in db_cache.users[user].roles when x is role).length

#
# Removes an item from an array.
#
# @returns {Array} - With the new item removed.
#
remove_item = (arr, item) ->
  x for x in arr when x isnt item

###
EXPORT MODULE CODE
###

module.exports = (robot) ->

  # Register a new user in the db
  robot.respond /db\:register \@?([^\s]+)$/i, (msg) ->
    user = msg.match[1].trim().toLowerCase()
    if Object::hasOwnProperty.call(db_cache.users, user)
      msg.send user + ' is already registered, bro'
    else
      register_user user, msg

  # View the current state of the db
  robot.respond /db\:show\s*(\@?[^\s]+)?$/i, (msg) ->
    user = msg.match[1]
    if user
      user = user.replace(/^\@/, '').trim().toLowerCase()
      if db_cache.users[user]
        msg.send "Here is " + user + "'s record: " + JSON.stringify(db_cache.users[user])
      else
        msg.send "I don't know anything about " + user
    else
      msg.send JSON.stringify(db_cache)

  # Reset the db back to its original state
  robot.respond /db\:reset$/i, (msg) ->
    db_cache = orig_state
    write_db()
    msg.send 'OK, I just reset the record.'

  # Assign roles
  robot.respond /\@?([\w .\-]+) is (a|an) ([\w .\-]+)\s*.*$/i, (msg) ->
    user = msg.match[1].trim().toLowerCase()
    aan  = msg.match[2].trim()
    role = msg.match[3].trim()
    if user isnt "what"
      if user_exists(user)
        if has_role(user, role)
          msg.send '@' + user + ' already has that role.'
        else
          db_cache.users[user].roles.push role
          write_db()
          msg.send 'Got it. Just made @' + user + ' ' + aan + ' ' + role + '.'
      else
        msg.send "I can't assign the role if you haven't registered that user, bro."

  # Revoke roles
  robot.respond /\@?([\w .\-]+) is not (a|an) ([\w .\-]+)\s*.*$/i, (msg) ->
    user = msg.match[1].trim().toLowerCase()
    aan  = msg.match[2].trim()
    role = msg.match[3].trim()
    if user isnt "what"
      if user_exists(user)
        if has_role(user, role)
          db_cache.users[user].roles = remove_item(db_cache.users[user].roles, role)
          write_db()
          msg.send 'Got it. @' + user + ' is no longer ' + aan + ' ' + role + '.'
        else
          msg.send "That is correct."
      else
        msg.send "You're right. Because that user isn't even registered yet."

  # Ask about roles
  robot.respond /is \@?([\w .\-]+) (a|an) ([\w .\-]+)\?*$/i, (msg) ->
    user = msg.match[1].trim().toLowerCase()
    aan  = msg.match[2].trim()
    role = msg.match[3].trim()
    if user_exists(user)
      if has_role(user, role)
        msg.send 'Yep. @' + user + ' is ' + aan + ' ' + role + '.'
      else
        msg.send 'Nope. @' + user + ' is not ' + aan + ' ' + role + '.'
    else
      msg.send "No, because that user isn't registered."

  # Award stars
  robot.respond /give \@?([\w .\-]+) (a|an) ([^\s]+\s+)?star$/i, (msg) ->
    user = msg.match[1].trim().toLowerCase()
    if user_exists(user)
      db_cache.users[user].stars += 1
      write_db()
      msg.send '@' + user + ' now has a total of ' + db_cache.users[user].stars + ' star(s)!'
    else
      msg.send "You will have to register that user first."

  # Revoke stars
  robot.respond /take away a star from \@?([\w .\-]+)$/i, (msg) ->
    user = msg.match[1].trim().toLowerCase()
    if user_exists(user)
      if db_cache.users[user].stars > 0
        db_cache.users[user].stars -= 1
        write_db()
        msg.send 'Wah, wah, wah. @' + user + ' now has ' + db_cache.users[user].stars + ' star(s).'
      else
        msg.send "I can't. @" + user + " doesn't have any stars."
    else
      msg.send "You will have to register that user first."

