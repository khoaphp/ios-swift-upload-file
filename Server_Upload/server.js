var express = require("express");
var app = express();
app.use(express.static("public"));
app.listen(3000);

//body-parser
var bodyParser = require('body-parser');
app.use(bodyParser.urlencoded({ extended: false }));

//multer
var multer  = require('multer');
var storage = multer.diskStorage({
    destination: function (req, file, cb) {
      cb(null, 'public/upload')
    },
    filename: function (req, file, cb) {
      cb(null, Date.now()  + "-" + file.originalname)
    }
});  
var upload = multer({ 
    storage: storage,
    fileFilter: function (req, file, cb) {
        console.log(file);
        if( file.mimetype=="image/bmp" 
            || file.mimetype=="image/png"
            || file.mimetype=="image/jpg"
            || file.mimetype=="image/jpeg"
        ){
            cb(null, true)
        }else{
            return cb(new Error('Only image are allowed!'))
        }
    }
}).single("avatar");

app.post("/uploadFile",  function(req, res){
    console.log("start");
    upload(req, res, function (err) {
        if (err instanceof multer.MulterError) {
          res.json({"error": "A Multer error occurred when uploading."});
        } else if (err) {
          res.json({"error": "An unknown error occurred when uploading." + err});
        }else{
            console.log("Upload is okay");
            console.log(req.file); // Thông tin file đã upload
            res.json({"file": req.file.filename});
        }
    });
});