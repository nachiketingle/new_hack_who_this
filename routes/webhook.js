var express = require('express');
var router = express.Router();


router.post("/github", function (req, res) {
	var sender = req.body.sender;
	var branch = req.body.ref;

	if(branch.indexOf('Backend') > -1){
				deploy(res);
			}
})

function deploy(res){
	childProcess.exec('cd /home/chenaaron3 && ./deploy.sh', function(err, stdout, stderr){
				if (err) {
						 console.error(err);
						 return res.send(500);
						}
				res.send(200);
			  });
}


module.exports = router;


var express = require("express");
var app = express();
var childProcess = require('child_process');