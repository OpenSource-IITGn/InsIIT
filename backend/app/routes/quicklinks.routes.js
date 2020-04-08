module.exports = (app) => {
    const quicklinks = require('../controllers/quicklinks.controller.js');

    // Create a new Note
    // app.post('/quicklinks', notes.create);

    // Retrieve all Notes
    app.get('/quicklinks', quicklinks.getAll);

    // Retrieve a single Note with noteId
    // app.get('/notes/:noteId', notes.findOne);

    // Update a Note with noteId
    // app.put('/notes/:noteId', notes.update);

    // Delete a Note with noteId
    // app.delete('/notes/:noteId', notes.delete);
}