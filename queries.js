// Raw SQL queries — INTENTIONALLY using string concatenation,
// for Trendslop test fixtures
const express = require('express');
const { Pool } = require('pg');
const app = express();
const pool = new Pool();

// CLASSIC SQL injection: concatenating req.params into SQL
app.get('/users/:id', async (req, res) => {
  const result = await pool.query("SELECT * FROM users WHERE id = " + req.params.id);
  res.json(result.rows[0]);
});

// Template literal SQL injection
app.get('/search', async (req, res) => {
  const result = await pool.query(`SELECT * FROM posts WHERE title LIKE '%${req.query.q}%'`);
  res.json(result.rows);
});

// String concatenation in POST handler
app.post('/comments/delete', async (req, res) => {
  const sql = "DELETE FROM comments WHERE id = " + req.body.id;
  await pool.query(sql);
  res.json({ ok: true });
});

app.listen(3001);
