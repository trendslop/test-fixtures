// Raw SQL queries — INTENTIONALLY using string concatenation,
// for Trendslop test fixtures
const { Pool } = require('pg');
const pool = new Pool();

// CLASSIC SQL injection: concatenating req.params into SQL
async function getUserById(req) {
  const result = await pool.query("SELECT * FROM users WHERE id = " + req.params.id);
  return result.rows[0];
}

// Template literal SQL injection
async function searchPosts(req) {
  const result = await pool.query(`SELECT * FROM posts WHERE title LIKE '%${req.query.q}%'`);
  return result.rows;
}

// f-string-style concatenation
async function deleteComment(req) {
  const sql = "DELETE FROM comments WHERE id = " + req.body.id;
  await pool.query(sql);
}

module.exports = { getUserById, searchPosts, deleteComment };
