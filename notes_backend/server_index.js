const express = require('express');
const bodyParser = require('body-parser');
const sqlite3 = require('sqlite3').verbose();
const cors = require('cors'); // Import cors
const { encrypt, decrypt } = require('./data_encryption');
const app = express();
const port = 3000;

app.use(cors()); // Enable cors
app.use(bodyParser.json());

// Initialize SQLite database
const db = new sqlite3.Database(':memory:');

db.serialize(() => {
  db.run("CREATE TABLE notes (id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, content TEXT, iv TEXT)");
});

// Get all notes
app.get('/notes', (req, res) => {
  db.all("SELECT * FROM notes", (err, rows) => {
    if (err) {
      res.status(500).send(err.message);
    } else {
      const decryptedRows = rows.map(row => ({
        id: row.id,
        title: row.title,
        content: decrypt({ iv: row.iv, encryptedData: row.content })
      }));
      res.json(decryptedRows);
    }
  });
});

// Get a single note by ID
app.get('/notes/:id', (req, res) => {
  const id = req.params.id;
  db.get("SELECT * FROM notes WHERE id = ?", [id], (err, row) => {
    if (err) {
      res.status(500).send(err.message);
    } else if (row) {
      res.json({
        id: row.id,
        title: row.title,
        content: decrypt({ iv: row.iv, encryptedData: row.content })
      });
    } else {
      res.status(404).send("Note not found");
    }
  });
});

// Add a new note
app.post('/notes', (req, res) => {
  const { title, content } = req.body;
  const encrypted = encrypt(content);
  const stmt = db.prepare("INSERT INTO notes (title, content, iv) VALUES (?, ?, ?)");
  stmt.run([title, encrypted.encryptedData, encrypted.iv], function (err) {
    if (err) {
      res.status(500).send(err.message);
    } else {
      res.status(201).json({ id: this.lastID, title, content });
    }
  });
});

// Edit an existing note
app.put('/notes/:id', (req, res) => {
  const { title, content } = req.body;
  const id = req.params.id;
  const encrypted = encrypt(content);
  const stmt = db.prepare("UPDATE notes SET title = ?, content = ?, iv = ? WHERE id = ?");
  stmt.run([title, encrypted.encryptedData, encrypted.iv, id], function (err) {
    if (err) {
      res.status(500).send(err.message);
    } else if (this.changes === 0) {
      res.status(404).send("Note not found");
    } else {
      res.json({ id, title, content });
    }
  });
});

// Delete a note
app.delete('/notes/:id', (req, res) => {
  const id = req.params.id;
  const stmt = db.prepare("DELETE FROM notes WHERE id = ?");
  stmt.run([id], function (err) {
    if (err) {
      res.status(500).send(err.message);
    } else if (this.changes === 0) {
      res.status(404).send("Note not found");
    } else {
      res.status(204).send();
    }
  });
});

app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}/`);
});
