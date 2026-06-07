// src/index.js
const express = require('express');
const cors    = require('cors');
const { getDb } = require('./db/database');

// Routes
const authRoutes   = require('./routes/auth');
const skillsRoutes = require('./routes/skills');
const groupsRoutes = require('./routes/groups');

const app  = express();
const PORT = process.env.PORT || 3000;

// ── Middleware ────────────────────────────────────────────────────────────────
app.use(cors());
app.use(express.json());

// ── Request logger (shows in terminal — useful for demo) ──────────────────────
app.use((req, _res, next) => {
  console.log(`[${new Date().toISOString()}] ${req.method} ${req.url}`);
  next();
});

// ── Routes ────────────────────────────────────────────────────────────────────
app.use('/auth',   authRoutes);
app.use('/skills', skillsRoutes);
app.use('/groups', groupsRoutes);

// ── Health check ──────────────────────────────────────────────────────────────
app.get('/health', (_req, res) => {
  res.json({ status: 'ok', message: 'Campus Collaboration API is running' });
});

// ── 404 handler ───────────────────────────────────────────────────────────────
app.use((_req, res) => {
  res.status(404).json({ error: 'Route not found.' });
});

// ── Global error handler ──────────────────────────────────────────────────────
app.use((err, _req, res, _next) => {
  console.error(err.stack);
  res.status(500).json({ error: 'Internal server error.' });
});

// ── Start server ──────────────────────────────────────────────────────────────
if (require.main === module) {
  // Initialize DB on startup
  getDb();
  app.listen(PORT, () => {
    console.log(`\n🚀 Campus Collaboration API running at http://localhost:${PORT}`);
    console.log(`📋 Endpoints:`);
    console.log(`   POST   http://localhost:${PORT}/auth/register`);
    console.log(`   POST   http://localhost:${PORT}/auth/login`);
    console.log(`   POST   http://localhost:${PORT}/auth/logout`);
    console.log(`   GET    http://localhost:${PORT}/auth/me`);
    console.log(`   PUT    http://localhost:${PORT}/auth/profile`);
    console.log(`   PUT    http://localhost:${PORT}/auth/change-password`);
    console.log(`   DELETE http://localhost:${PORT}/auth/account`);
    console.log(`   GET    http://localhost:${PORT}/skills`);
    console.log(`   POST   http://localhost:${PORT}/skills`);
    console.log(`   GET    http://localhost:${PORT}/skills/:id`);
    console.log(`   PUT    http://localhost:${PORT}/skills/:id`);
    console.log(`   DELETE http://localhost:${PORT}/skills/:id`);
    console.log(`   POST   http://localhost:${PORT}/skills/:id/request`);
    console.log(`   GET    http://localhost:${PORT}/groups`);
    console.log(`   POST   http://localhost:${PORT}/groups`);
    console.log(`   GET    http://localhost:${PORT}/groups/:id`);
    console.log(`   PUT    http://localhost:${PORT}/groups/:id`);
    console.log(`   DELETE http://localhost:${PORT}/groups/:id`);
    console.log(`   POST   http://localhost:${PORT}/groups/:id/join`);
    console.log(`   DELETE http://localhost:${PORT}/groups/:id/leave`);
    console.log(`\n📁 Database: campus_api.db`);
  });
}

module.exports = app; // exported for tests
