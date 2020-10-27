const express = require('express')
const cors = require('cors')
const multer = require('multer')

// neccessary
var upload = multer({ dest: 'upload/' })
var app = express()
var fs = require('fs')

// cross origin sharing
app.use(cors())
app.engine('html', require('ejs').renderFile);
app.set('view engine', 'html');
app.use(express.static('public'))

// root endpoint
app.get("/", (req, res) => {
	res.send("Hello");
});

// endpoint to handle files being uploaded
var type = upload.single('myFile');
app.post("/api", type, (req, res) => {
	// temp path
	var temp_path = req.file.path;
	console.log(temp_path);

	// target path output to the uploads dir
	var target_path = 'uploads/' + req.file.originalname;

	var src = fs.createReadStream(temp_path);
	var dest = fs.createWriteStream(target_path);
	src.pipe(dest);
	src.on('end', function() { console.log('complete'); });
	src.on('error', function(err) { console.log('error'); });
})

app.listen(8000, () => {
	console.log("started on port 8000")
})
