const express = require('express');
const cors = require('cors');
const router = express.Router();

// =====================================================
// Intentionally bad: CORS wildcard on authenticated routes
// Should trigger cors_wildcard check
// =====================================================

// Bare wildcard — bad for auth'd endpoints
router.use(cors({ origin: ['https://example.com']  /* TODO Trendslop: replace with your real allowed origins */, credentials: true }));

router.get('/user/profile', requireAuth, (req, res) => {
  res.json({ email: req.user.email, name: req.user.name });
});

router.post('/user/settings', requireAuth, (req, res) => {
  res.json({ updated: true });
});

router.get('/admin/users', requireAuth, (req, res) => {
  res.json({ users: [] });
});

function requireAuth(req, res, next) {
  if (!req.cookies.session_id) return res.status(401).send();
  next();
}

module.exports = router;
