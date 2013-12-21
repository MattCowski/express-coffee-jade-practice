express  = require 'express'
mongoose = require 'mongoose'
http = require "http"
app = express()

# app.configure 'dev' ->
#   # NODE_ENV= ...
app.configure ->
  app.set "port", process.env.PORT or 4000
  app.set 'views', __dirname + '/views'
  app.set 'view engine', 'jade'
  # app.set 'view cache', true
  # app.enable 'view cache'
  # case sensitive routes
  #  strict routing
  # app.set 'local messages', 'true'

  # app.use(express.urlencoded())
  # app.use(express.json())
  # app.use express.cookieParser()
  # app.use express.session({secret: 'this is secret'})

  app.use(express.bodyParser())
  #  faux HTTP method for put delete
  app.use(express.methodOverride())
#   # search list of our routes before you do vvv
  app.use app.router
  app.use(express.static(__dirname + "/public"))
  # app.use (req, res) ->
  #   res.send 404, "four oh four"

  # app.use (err, req, res, next) ->
  #   res.status(err.status or 404)
  #   res.send err.message
mongoose.connect "mongodb://localhost/helloExpress"

UserSchema = new mongoose.Schema(
  {
    name: String,
    email: String,
    age: Number
  })
Users = mongoose.model 'Users', UserSchema
# INDEX
app.get "/users", (req, res) =>
  Users.find {}, (err, docs) =>
    res.render 'users/index', { users: docs }

# NEW
app.get "/users/new", (req, res) =>
  res.render "users/new"
  

#   # serving stylesheets... or e.g. file.zip
# # public/file.zip


# # app.get '/', (req, res) ->
# #   res.send 'Hello, Matt'
# count = 0
# app.get '/hello.txt', (req, res, next) ->
#   count++
#   next()

# app.get '/count', (req, res) ->
#   res.send(" " + count + " views")


# users = ['foo', 'josh', 'bob', 'anne']


# app.get '/users/:from-:to', (req, res) ->
#   # from = parseInt req.params.from, 10
#   # to = parseInt req.params.to, 10
#   res.json(users.slice(req.from, req.to + 1))

# app.param 'from', (req, res, next, from) ->
#   # req.from = parseInt req.params.from, 10
#   req.from = parseInt from, 10
#   next()
  

# app.param 'to', (req, res, next, to) ->
#   # req.to = parseInt req.params.to, 10
#   req.to = parseInt to, 10
#   next()

# app.get '/', (req, res) ->
#   res.send(req.get('user-agent'))
#   # html, xml, 
#   res.send(req.accepted())
#   res.send(req.acceptsLanguage('en') ? 'yes' : 'no')
#   res.send(req.accepts(['html', 'text', 'json']))
#   # accepted charsets utf-8 yes? no?
# # app.get '/', (req, res) ->
# #   res.render "home", { title: "Nav would go hererere"}

# # no name? reply with default
# app.get '/name/:name?', (req, res) ->
#   res.send(req.param('name', 'default value'))

# app.get '/hi', (req, res) ->
#   message = "<h1>fooobar</h1>"
#   res.send message

#   res.type('image/png').send('imageurl')

# app.get '/', (req, res) ->
#   res.format({
#       html: () ->
#         { 
#           res.send("<h1> body</h1>")
#         },
#       json: () ->
#         { res.json({ message:"body"})},
#       text: () ->
#         { res.send("body")}
#     })
#   # curl localhost:4000
#   # curl localhost:4000 -H "accept: text/plain"
#   # curl localhost:4000 -H "accept: application/json"


# app.get("/home", (req, res) ->
#   res.redirect(302, '/')
#   # res.set 
#   # res.get
#   )

# app.get '/users/:userId', (req, res) ->
#   res.send "Hello, user "+ req.params.userId

# app.post '/users', (req, res) ->
#   res.send "Creating " + req.body.username

# app.get /\/users\/(\d*)\/?(edit)?/, (req, res) ->
#   # /users/10
#   # /users/10/
#   # /users/10/edit

#   message = "user " + req.params[0]
#   if req.params[1] is 'edit'
#     message = "Editing " + message
#   else
#     message = "Viewing " + message

#   res.send message

# # part 11

# users = [
#   {name: "bob"},
#   {name: "ann"},
#   {name: "sammy"}
# ]

# loadUser = (req, res, next) ->
#   req.user = users[parseInt(req.params.userId, 10)]
#   next()

# app.get '/users/:userId', loadUser, (req, res) ->
#   res.json req.user

# # part 12
# #  Cookies and Sessions
# # res.cookie(name, value, { expires: new Date() ...})

# app.get '/name/:name', (req, res) ->
#   # res.cookie('name', req.params.name).send('<p>cookie is <a href="/name"> here</a></p>')
#   req.session.name = req.params.name
#   res.send('<p>Session is <a href="/name"> here</a></p>')

# app.get '/name', (req, res) ->
#   # res.clearCookie('name').send(req.cookies.name)
#   res.send req.session.name

# # part 13
# # Errors
# app.get '/users/:username', (req, res, next) ->
#   if req.params.username is 'andy'
#     # res.send "Andy!"
#     err = new Error 'User does not exist'
#     err.status - 'user-error'
#     next(err)
#   else
#     res.send req.params.username + "'s profile"


# http.createServer(app).listen app.get('port'), ->
#   console.log "Listening on port #{app.get('port')}"

# part 14 MongoDB




  #  whats diff -> =>
    # what's utf-8