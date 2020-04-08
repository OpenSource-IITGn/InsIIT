const mongoose = require('mongoose');

const NoteSchema = mongoose.Schema({
    name: String,
    description: String,
    link: String,
}, {
    timestamps: false
});

module.exports = mongoose.model('quicklink', NoteSchema);