const QuickLink = require('../models/quicklink.model.js');

// Retrieve and return all notes from the database.
exports.getAll = (req, res) => {
    console.log("[GET]: Quicklinks");
    QuickLink.find()
        .then(links => {
            res.send(links);
        }).catch(err => {
            res.status(500).send({
                message: err.message || "Some error occurred while retrieving links."
            });
        });
};