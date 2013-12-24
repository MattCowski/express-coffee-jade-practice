express  = require 'express'
mongoose = require 'mongoose'
http = require "http"
app = express()
mongo = require 'mongodb'
# passport = require 'passport'

mongoUri = process.env.MONGOLAB_URI || process.env.MONGOHQ_URL || 'mongodb://localhost/mydb'

# TODO: is this mandatory for Heroku?
mongo.Db.connect mongoUri, (err, db) =>
  db.collection 'mydocs', (er, collection) =>
    collection.insert {'mkey': 'myvalue'}, {safe: true}, (er, rs) =>

# # Passport
# app.post('/login', passport.authenticate('local', { successRedirect: '/', failureRedirect: '/login' }))

app.configure ->
  app.set "port", process.env.PORT or 4000
  app.set 'views', __dirname + '/views'
  app.set 'view engine', 'jade'

  app.use(express.urlencoded())
  app.use(express.json())
  #  faux HTTP method for put delete
  app.use(express.methodOverride())
#   # search list of our routes before you do vvv

  # app.use (req, res) ->
  #   res.send 404, "four oh four"

  app.use (err, req, res, next) ->
    res.status(err.status or 404)
    res.send err.message
  app.use express.cookieParser()
  app.use express.session({secret: 'this is secret'})
  app.use(app.router)
  app.use(express.static(__dirname + "/public"))


mongoose.connect mongoUri

db = mongoose.connection
db.on 'error', console.error.bind(console, 'connection error:')
db.once 'open', callback = () =>
  # yay

UserSchema = new mongoose.Schema(
  {
    name: String,
    email: String,
    age: Number,
    remember_token: String
  })
Users = mongoose.model 'Users', UserSchema

app.get '/', (req, res) ->
  res.render "home", { title: "Nav would go hererere"}
# no name? reply with default
app.get '/about', (req, res) ->
  message = "<h1>Site is made by Matt</h1>"
  res.send message
  # res.type('image/png').send('imageurl')

# INDEX
app.get "/users", (req, res) =>
  Users.find { remember_token: req.cookies.remember_token }, (err, docs) =>
    res.render 'users/index', { users: docs }

# NEW
app.get "/users/new", (req, res) =>
  res.render "users/new"

app.post "/users", (req, res) =>
  b = req.body
  res.cookie('guestId', b.name)

  b.remember_token = req.cookies.remember_token
  new Users({
      name: b.name,
      email: b.email,
      age: b.age,
      remember_token: b.remember_token
    }).save (err, user) =>
      if (err)
        res.json err
      res.redirect '/users/' + user.name

app.param 'name', (req, res, next, name) =>
  Users.find { name: name }, (err, docs) =>
    req.user = docs[0]
    next()

# SHOW
app.get '/users/:name', (req, res) =>
  res.render 'users/show', { user: req.user }

# # FIXME
# app.get '/users/:name?', (req, res) ->
#   res.send(req.param('name', 'default value'))


# EDIT
app.get '/users/:name/edit', (req, res) =>
  res.render "users/edit", { user: req.user }

# UPDATE
app.put '/users/:name', (req, res) =>
  b = req.body
  Users.update(
    { name: req.params.name },
    { name: b.name, age: b.age, email: b.email },
    (err) =>
      res.redirect '/users/' + b.name
    )

# DESTROY
app.delete '/users/:name', (req, res) =>
  Users.remove({ name: req.params.name }, (err) =>
    res.redirect '/users'
    )


# res.cookie(name, value, { expires: new Date() ...})

app.get '/guest/:guestId', (req, res) ->
  # res.cookie('guestId', req.params.guestId).send('<p>cookie is <a href="/guest"> here</a></p>')
  # req.session.guest = req.params.guest
  # res.send('<p>Session is <a href="/guest"> here</a></p>')

app.get '/guest', (req, res) ->
  # res.clearCookie('guest').send(req.cookies.guest)
  # res.send(req.cookies.guestId)
  # res.send req.session.guest










http.createServer(app).listen app.get('port'), ->
  console.log "Listening on port #{app.get('port')}"