express  = require 'express'
mongoose = require 'mongoose'
http = require "http"
app = express()

app.configure ->
  app.set "port", process.env.PORT or 4000
  app.set 'views', __dirname + '/views'
  app.set 'view engine', 'jade'

  app.use(express.bodyParser())
  app.use(express.urlencoded())
  app.use(express.json())
  #  faux HTTP method for put delete
  app.use(express.methodOverride())
#   # search list of our routes before you do vvv
  app.use(app.router)
  app.use(express.static(__dirname + "/public"))

mongoose.connect "mongodb://localhost/test"
# db = Mongoose.createConnection('localhost', 'zaiste')
db = mongoose.connection
db.on 'error', console.error.bind(console, 'connection error:')
db.once 'open', callback = () =>
  # yay

UserSchema = new mongoose.Schema(
  {
    name: String,
    email: String,
    age: Number
  })
Users = mongoose.model 'Users', UserSchema
# INDEX
app.get "/users", (req, res) =>
  # res.send "fooo"
  Users.find {}, (err, docs) =>
    res.render 'users/index', { users: docs }

# NEW
app.get "/users/new", (req, res) =>
  res.render "users/new"

app.post "/users", (req, res) =>
  b = req.body
  new Users({
      name: b.name,
      email: b.email,
      age: b.age
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


http.createServer(app).listen app.get('port'), ->
  console.log "Listening on port #{app.get('port')}"