express  = require 'express'
mongoose = require 'mongoose'
http = require "http"
app = express()

app.configure ->
  app.set "port", process.env.PORT or 4000
  app.set 'views', __dirname + '/views'
  app.set 'view engine', 'jade'

  app.use(express.bodyParser())
  #  faux HTTP method for put delete
  app.use(express.methodOverride())
#   # search list of our routes before you do vvv
  app.use app.router
  app.use(express.static(__dirname + "/public"))

mongoose.connect "mongodb://localhost/helloExpress"
# db = Mongoose.createConnection('localhost', 'zaiste')
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


http.createServer(app).listen app.get('port'), ->
  console.log "Listening on port #{app.get('port')}"