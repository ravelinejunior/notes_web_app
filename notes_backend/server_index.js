const express = require('express');
const bodyParser = require('body-parser');
const sqlite3 = require('sqlite3').verbose();
const cors = require('cors');
const { encrypt, decrypt } = require('./data_encryption');
const app = express();
const port = 3000;

app.use(cors());
app.use(bodyParser.json());

// Initialize SQLite database
const db = new sqlite3.Database(':memory:');

db.serialize(() => {
  db.run("CREATE TABLE notes (id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, content TEXT, iv TEXT)");
  db.run("CREATE TABLE tags (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT)");
  db.run("CREATE TABLE note_tags (note_id INTEGER, tag_id INTEGER, FOREIGN KEY(note_id) REFERENCES notes(id), FOREIGN KEY(tag_id) REFERENCES tags(id))");

  // Insert initial tags
  const stmt = db.prepare("INSERT INTO tags (name) VALUES (?)");
  ['Work', 'Personal', 'Important', 'Other'].forEach(tag => {
    stmt.run(tag);
  });
  stmt.finalize();
});

// Get all notes with tags
app.get('/notes', (_, res) => {
  const query = `
  SELECT n.id, n.title, n.content, n.iv, GROUP_CONCAT(t.name) as tags 
  FROM notes n 
  LEFT JOIN note_tags nt ON n.id = nt.note_id 
  LEFT JOIN tags t ON nt.tag_id = t.id 
  GROUP BY n.id  
  `;

  db.all(query, (err, rows) => {
    if (err) {
      console.error('Error fetching notes:', err.message);
      res.status(500).send(err.message);
    } else {
      const decryptedRows = rows.map(row => ({
        id: row.id,
        title: row.title,
        content: decrypt({ iv: row.iv, encryptedData: row.content }),
        tags: row.tags ? row.tags.split(',') : []
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
      console.error(`Error fetching note with ID ${id}:`, err.message);
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
      console.error('Error adding note:', err.message);
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
      console.error(`Error updating note with ID ${id}:`, err.message);
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
      console.error(`Error deleting note with ID ${id}:`, err.message);
      res.status(500).send(err.message);
    } else if (this.changes === 0) {
      res.status(404).send("Note not found");
    } else {
      res.status(204).send();
    }
  });
});

// Get all tags
app.get('/tags', (req, res) => {
  db.all("SELECT * FROM tags", (err, rows) => {
    if (err) {
      console.error('Error fetching tags:', err.message); 
      res.status(500).send(err.message);
    } else {
      res.json(rows);
    }
  });
});

// Add a new tag
app.post('/tags', (req, res) => {
  const { name } = req.body;
  const stmt = db.prepare("INSERT INTO tags (name) VALUES (?)");
  stmt.run([name], function (err) {
    if (err) {
      console.error('Error adding tag:', err.message);  
      res.status(500).send(err.message);
    } else {
      res.status(201).json({ id: this.lastID, name });
    }
  });
});

// Associate tags with a note
app.post('/notes/:id/tags', (req, res) => {
  const noteId = req.params.id;
  const { tagIds } = req.body; 
  const stmt = db.prepare("INSERT INTO note_tags (note_id, tag_id) VALUES (?, ?)");
  tagIds.forEach(tagId => {
    stmt.run([noteId, tagId], function (err) {
      if (err) {
        console.error(`Error associating tag with note ID ${noteId}:`, err.message);
        res.status(500).send(err.message);
      } else {
        console.log(`Tag with ID ${tagId} associated with note ID ${noteId}`);
      }
    });
  });
  res.status(201).json({ noteId, tagIds });
});

app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}/`);
});