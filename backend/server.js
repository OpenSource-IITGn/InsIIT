const express = require('express');
const bodyParser = require('body-parser');

// create express app
const app = express();

// parse requests of content-type - application/x-www-form-urlencoded
app.use(bodyParser.urlencoded({ extended: true }))

// parse requests of content-type - application/json
app.use(bodyParser.json())

// define a simple route
app.get('/', (req, res) => {
    console.log("[GET]: Home")
    res.json({ "message": "Welcome to the InstiApp API for getting data regarding all institute stuff :P" });
});

require('./app/routes/quicklinks.routes.js')(app);
// listen for requests
app.listen(3000, () => {
    console.log("Server is listening on port 3000");
});


const mongoose = require('mongoose');
const dbConfig = require('./config/database.config.js');
mongoose.Promise = global.Promise;

// Connecting to the database
mongoose.connect(dbConfig.url, {
    useNewUrlParser: true
}).then(() => {
    console.log("Successfully connected to the database");
}).catch(err => {
    console.log('Could not connect to the database. Exiting now...', err);
    process.exit();
});