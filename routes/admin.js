// Admin routes — INTENTIONALLY missing auth, for Trendslop test fixtures
const express = require('express');
const router = express.Router();

// State-changing routes with no auth indicators. The audit should flag these.
router.delete('/admin/users/:id', (req, res) => {
  // Deletes user — but no auth check!
  const userId = req.params.id;
  db.users.delete({ id: userId });
  res.json({ ok: true });
});

router.post('/admin/posts/:id/feature', (req, res) => {
  // Features a post — but no auth check!
  const postId = req.params.id;
  db.posts.update({ id: postId }, { featured: true });
  res.json({ ok: true });
});

router.put('/admin/settings', (req, res) => {
  // Updates app-wide settings — but no auth check!
  db.settings.update(req.body);
  res.json({ ok: true });
});

module.exports = router;
