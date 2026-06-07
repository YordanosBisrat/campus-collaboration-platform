// src/routes/auth.js
const express = require('express');
const bcrypt  = require('bcryptjs');
const { v4: uuidv4 } = require('uuid');
const { getDb } = require('../db/database');
const { authenticate, generateToken } = require('../middleware/auth');

const router = express.Router();

// ── POST /auth/register ───────────────────────────────────────────────────────
router.post('/register', (req, res) => {
  const { fullName, email, password } = req.body;

  if (!fullName || !email || !password) {
    return res.status(400).json({ error: 'fullName, email and password are required.' });
  }
  if (password.length < 8) {
    return res.status(400).json({ error: 'Password must be at least 8 characters.' });
  }

  const db = getDb();

  // Check duplicate email
  const existing = db.prepare('SELECT id FROM users WHERE email = ?').get(email.toLowerCase());
  if (existing) {
    return res.status(409).json({ error: 'Email already registered.' });
  }

  const passwordHash = bcrypt.hashSync(password, 10);
  const user = {
    id: uuidv4(),
    full_name: fullName.trim(),
    email: email.toLowerCase().trim(),
    password_hash: passwordHash,
    bio: '',
    avatar_path: '',
    role: 'student',
    created_at: Date.now(),
  };

  db.prepare(`
    INSERT INTO users (id, full_name, email, password_hash, bio, avatar_path, role, created_at)
    VALUES (@id, @full_name, @email, @password_hash, @bio, @avatar_path, @role, @created_at)
  `).run(user);

  const token = generateToken(user);

  return res.status(201).json({
    token,
    user: {
      id: user.id,
      fullName: user.full_name,
      email: user.email,
      bio: user.bio,
      role: user.role,
    },
  });
});

// ── POST /auth/login ──────────────────────────────────────────────────────────
router.post('/login', (req, res) => {
  const { email, password } = req.body;

  if (!email || !password) {
    return res.status(400).json({ error: 'Email and password are required.' });
  }

  const db = getDb();
  const user = db.prepare('SELECT * FROM users WHERE email = ?').get(email.toLowerCase().trim());

  if (!user) {
    return res.status(401).json({ error: 'No account found with this email.' });
  }

  const valid = bcrypt.compareSync(password, user.password_hash);
  if (!valid) {
    return res.status(401).json({ error: 'Incorrect password.' });
  }

  const token = generateToken(user);

  return res.json({
    token,
    user: {
      id: user.id,
      fullName: user.full_name,
      email: user.email,
      bio: user.bio,
      role: user.role,
    },
  });
});

// ── POST /auth/logout ─────────────────────────────────────────────────────────
// JWT is stateless — client just discards token. This endpoint is for demo.
router.post('/logout', authenticate, (req, res) => {
  return res.json({ message: 'Logged out successfully.' });
});

// ── GET /auth/me ──────────────────────────────────────────────────────────────
router.get('/me', authenticate, (req, res) => {
  const db = getDb();
  const user = db.prepare('SELECT * FROM users WHERE id = ?').get(req.user.id);
  if (!user) return res.status(404).json({ error: 'User not found.' });

  return res.json({
    id: user.id,
    fullName: user.full_name,
    email: user.email,
    bio: user.bio,
    avatarPath: user.avatar_path,
    role: user.role,
  });
});

// ── PUT /auth/profile ─────────────────────────────────────────────────────────
router.put('/profile', authenticate, (req, res) => {
  const { fullName, email, bio } = req.body;
  const db = getDb();

  db.prepare(`
    UPDATE users SET full_name = ?, email = ?, bio = ? WHERE id = ?
  `).run(
    fullName?.trim() || req.user.fullName,
    email?.toLowerCase().trim() || req.user.email,
    bio ?? '',
    req.user.id,
  );

  const updated = db.prepare('SELECT * FROM users WHERE id = ?').get(req.user.id);
  return res.json({
    id: updated.id,
    fullName: updated.full_name,
    email: updated.email,
    bio: updated.bio,
    role: updated.role,
  });
});

// ── PUT /auth/change-password ─────────────────────────────────────────────────
router.put('/change-password', authenticate, (req, res) => {
  const { currentPassword, newPassword } = req.body;
  if (!currentPassword || !newPassword) {
    return res.status(400).json({ error: 'currentPassword and newPassword are required.' });
  }
  if (newPassword.length < 8) {
    return res.status(400).json({ error: 'New password must be at least 8 characters.' });
  }

  const db = getDb();
  const user = db.prepare('SELECT * FROM users WHERE id = ?').get(req.user.id);

  if (!bcrypt.compareSync(currentPassword, user.password_hash)) {
    return res.status(401).json({ error: 'Current password is incorrect.' });
  }

  db.prepare('UPDATE users SET password_hash = ? WHERE id = ?')
    .run(bcrypt.hashSync(newPassword, 10), req.user.id);

  return res.json({ message: 'Password updated successfully.' });
});

// ── DELETE /auth/account ──────────────────────────────────────────────────────
router.delete('/account', authenticate, (req, res) => {
  const db = getDb();
  db.prepare('DELETE FROM users WHERE id = ?').run(req.user.id);
  return res.json({ message: 'Account deleted successfully.' });
});

module.exports = router;
