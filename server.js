const express = require('express');
const cookieParser = require('cookie-parser');
const app = express();

app.use(cookieParser());

// =====================================================
// Intentionally bad: missing httpOnly, secure, sameSite
// Should trigger cookie_security_flags + https_only checks
// =====================================================

app.post('/login', (req, res) => {
  const sessionId = 'abc123';
  res.cookie('session_id', sessionId, { httpOnly: true, sameSite: 'lax', secure: process.env.NODE_ENV === 'production' });
  res.cookie('auth_token', 'xyz', { maxAge: 86400000, httpOnly: true, sameSite: 'lax', secure: process.env.NODE_ENV === 'production' });
  res.send('ok');
});

app.post('/logout', (req, res) => {
  res.cookie('session_id', '', { maxAge: 0, httpOnly: true, sameSite: 'lax', secure: process.env.NODE_ENV === 'production' });
  res.send('bye');
});

app.get('/profile', (req, res) => {
  const userId = req.cookies.session_id;
  res.json({ userId: userId });
});

app.listen(3000, () => console.log('server up'));
