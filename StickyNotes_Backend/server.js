const express = require('express');
const { v4: uuidv4 } = require('uuid');
const app = express();
const PORT = 3000;

app.use(express.json());

// In-memory data store
let notes = [];

app.listen(PORT, () => {
    console.log(`Sticky Note Server is running on http://localhost:${PORT}`);
});

// Create a Note Endpoint
app.post('/notes', (req, res) => {
    const { text,
        isComplete,
        position,
        textColor,
        noteColor } = req.body;
    
    const newNote = {
        id: uuidv4(),
        text,
        isComplete: isComplete,
        position: position,
        textColor: textColor,
        noteColor: noteColor
    };
    
    notes.push(newNote);
    
    res.status(200).json(newNote);
});

// Get all Notes Endpoint
app.get('/notes', (req, res) => {
    res.json(notes);
});

// Edit a Note by ID Endpoint
app.put('/notes/:id', (req, res) => {
    // Find the note with a matching ID
    const note = notes.find(noteBeingSearched => noteBeingSearched.id === req.params.id);
    
    if (!note) {
        // If we didn't find one, return a 404 and error message
        return res.status(404).json({ message: 'Note not found' });
    }
    
    const { text,
        isComplete,
        position,
        textColor,
        noteColor } = req.body;
    
    note.text = text;
    note.isComplete = isComplete;
    note.position = position;
    note.textColor = textColor;
    note.noteColor = noteColor;
    
    res.status(200).json(note);
});

// Delete a Note by ID Endpoint
app.delete('/notes/:id', (req, res) => {
    const noteIndex = notes.findIndex(noteBeingSearched => noteBeingSearched.id === req.params.id);
    
    if (noteIndex === -1) {
        return res.status(404).json({ message: 'Note not found' });
    }
    
    const deletedNote = notes.splice(noteIndex, 1);
    res.json(deletedNote);
});
