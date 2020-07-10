var express = require('express');
var router = express.Router();
var childProcess = require('child_process');
var scriptDirectory = '/home/chenaaron3'
var scriptFile = 'deploy.sh'

router.post("/github", function (req, res) {
    var sender = req.body.sender;
    var branch = req.body.ref;

    if (branch.indexOf('Backend') > -1) {
        res.sendStatus(200);
        console.log(`Push Detected from ${sender.login}! Now Deploying!`);
        deploy();
    }
})

function deploy() {
    let command = `cd ${scriptDirectory} && ./${scriptFile}`;
    let child = childProcess.spawn(command, {
        stdio: 'inherit',
        shell: true
    });

    child.on('exit', function (code, signal) {
        console.log('child process exited with ' + `code ${code} and signal ${signal}`);
    });
}

module.exports = router;
