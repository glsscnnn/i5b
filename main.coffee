# deps
express = require "express"
cors = require "cors"
multer = require "multer"
fs = require "fs"

# important
upload = multer { dest: "upload/" }

# initialize app
app = express()
app.use cors()
app.engine "html", require("ejs").renderFile
app.set "view engine", "html"
app.use express.static("public")

# root endpoint just sends "root endpoint reached"
app.get "/", (req, res) ->
	res.send "root endpoint reached"

# myFile matches the name of the file set in i5a
type = upload.single "myFile"

# /api endpoint handle data
app.post "/api", type, (req, res) ->
	# temp path
	temp_path = req.file.path
	console.log temp_path

	# target path ouput to the uploads dir
	target_path = "uploads/" + req.file.originalname
	
	# write to output stream
	src = fs.createReadStream temp_path
	dest = fs.createWriteStream target_path
	src.pipe dest
	src.on 'end', () -> console.log "complete"
	src.on 'error', (err) -> console.log "error"

# app starts on port 8000
app.listen 8000, () ->
	console.log "Express started on port 8000!"
