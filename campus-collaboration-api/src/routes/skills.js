// src/routes/skills.js
const express = require('express');
const { v4: uuidv4 } = require('uuid');
const { getDb } = require('../db/database');
const { authenticate } = require('../middleware/auth');

const router = express.Router();

// ── GET /skills ───────────────────────────────────────────────────────────────
// Public — anyone can browse skills
router.get('/', (req, res) => {
  const db = getDb();
  const skills = db.prepare(`
    SELECT s.*, u.full_name AS owner_name
    FROM skills s
    JOIN users u ON s.owner_id = u.id
    ORDER BY s.created_at DESC
  `).all();

  return res.json(skills.map(formatSkill));
});

// ── GET /skills/my ────────────────────────────────────────────────────────────
// Returns only skills owned by the logged-in user
router.get('/my', authenticate, (req, res) => {
  const db = getDb();
  const skills = db.prepare(`
    SELECT * FROM skills WHERE owner_id = ? ORDER BY created_at DESC
  `).all(req.user.id);

  return res.json(skills.map(formatSkill));
});

// ── GET /skills/requests ──────────────────────────────────────────────────────
// Returns incoming requests for the logged-in user's skills
router.get('/requests', authenticate, (req, res) => {
  const db = getDb();
  const requests = db.prepare(`
    SELECT sr.*
    FROM skill_requests sr
    JOIN skills s ON sr.skill_id = s.id
    WHERE s.owner_id = ?
    ORDER BY sr.created_at DESC
  `).all(req.user.id);

  return res.json(requests);
});

// ── GET /skills/:id ───────────────────────────────────────────────────────────
router.get('/:id', (req, res) => {
  const db = getDb();
  const skill = db.prepare(`
    SELECT s.*, u.full_name AS owner_name
    FROM skills s
    JOIN users u ON s.owner_id = u.id
    WHERE s.id = ?
  `).get(req.params.id);

  if (!skill) return res.status(404).json({ error: 'Skill not found.' });
  return res.json(formatSkill(skill));
});

// ── POST /skills ──────────────────────────────────────────────────────────────
router.post('/', authenticate, (req, res) => {
  const { title, category, description, availability, prerequisites } = req.body;

  if (!title || !category || !description) {
    return res.status(400).json({ error: 'title, category and description are required.' });
  }

  const db = getDb();
  const user = db.prepare('SELECT * FROM users WHERE id = ?').get(req.user.id);

  const skill = {
    id: uuidv4(),
    title: title.trim(),
    category: category.trim(),
    description: description.trim(),
    owner_id: req.user.id,
    owner_name: user.full_name,
    owner_year: user.bio || '',
    availability: availability?.trim() || '',
    prerequisites: prerequisites?.trim() || '',
    created_at: Date.now(),
  };

  db.prepare(`
    INSERT INTO skills
      (id, title, category, description, owner_id, owner_name, owner_year,
       availability, prerequisites, created_at)
    VALUES
      (@id, @title, @category, @description, @owner_id, @owner_name, @owner_year,
       @availability, @prerequisites, @created_at)
  `).run(skill);

  return res.status(201).json(formatSkill(skill));
});

// ── PUT /skills/:id ───────────────────────────────────────────────────────────
router.put('/:id', authenticate, (req, res) => {
  const db = getDb();
  const skill = db.prepare('SELECT * FROM skills WHERE id = ?').get(req.params.id);

  if (!skill) return res.status(404).json({ error: 'Skill not found.' });
  if (skill.owner_id !== req.user.id) {
    return res.status(403).json({ error: 'You can only edit your own skills.' });
  }

  const { title, category, description, availability, prerequisites } = req.body;

  db.prepare(`
    UPDATE skills SET
      title         = ?,
      category      = ?,
      description   = ?,
      availability  = ?,
      prerequisites = ?
    WHERE id = ?
  `).run(
    title?.trim()         ?? skill.title,
    category?.trim()      ?? skill.category,
    description?.trim()   ?? skill.description,
    availability?.trim()  ?? skill.availability,
    prerequisites?.trim() ?? skill.prerequisites,
    req.params.id,
  );

  const updated = db.prepare('SELECT * FROM skills WHERE id = ?').get(req.params.id);
  return res.json(formatSkill(updated));
});

// ── DELETE /skills/:id ────────────────────────────────────────────────────────
router.delete('/:id', authenticate, (req, res) => {
  const db = getDb();
  const skill = db.prepare('SELECT * FROM skills WHERE id = ?').get(req.params.id);

  if (!skill) return res.status(404).json({ error: 'Skill not found.' });
  if (skill.owner_id !== req.user.id) {
    return res.status(403).json({ error: 'You can only delete your own skills.' });
  }

  db.prepare('DELETE FROM skills WHERE id = ?').run(req.params.id);
  return res.json({ message: 'Skill deleted successfully.' });
});

// ── POST /skills/:id/request ──────────────────────────────────────────────────
router.post('/:id/request', authenticate, (req, res) => {
  const db = getDb();
  const skill = db.prepare('SELECT * FROM skills WHERE id = ?').get(req.params.id);

  if (!skill) return res.status(404).json({ error: 'Skill not found.' });
  if (skill.owner_id === req.user.id) {
    return res.status(400).json({ error: 'You cannot request your own skill.' });
  }

  // Check duplicate request
  const existing = db.prepare(`
    SELECT id FROM skill_requests
    WHERE skill_id = ? AND requester_id = ?
  `).get(req.params.id, req.user.id);

  if (existing) {
    return res.status(409).json({ error: 'You have already requested this skill.' });
  }

  const request = {
    id: uuidv4(),
    skill_id: req.params.id,
    skill_title: skill.title,
    requester_id: req.user.id,
    requester_name: req.user.fullName,
    status: 'pending',
    created_at: Date.now(),
  };

  db.prepare(`
    INSERT INTO skill_requests
      (id, skill_id, skill_title, requester_id, requester_name, status, created_at)
    VALUES
      (@id, @skill_id, @skill_title, @requester_id, @requester_name, @status, @created_at)
  `).run(request);

  return res.status(201).json(request);
});

// ── PUT /skills/requests/:requestId ──────────────────────────────────────────
// Accept or reject a request (only skill owner can do this)
router.put('/requests/:requestId', authenticate, (req, res) => {
  const { status } = req.body; // 'accepted' | 'rejected'
  if (!['accepted', 'rejected'].includes(status)) {
    return res.status(400).json({ error: "status must be 'accepted' or 'rejected'." });
  }

  const db = getDb();
  const request = db.prepare(`
    SELECT sr.*, s.owner_id
    FROM skill_requests sr
    JOIN skills s ON sr.skill_id = s.id
    WHERE sr.id = ?
  `).get(req.params.requestId);

  if (!request) return res.status(404).json({ error: 'Request not found.' });
  if (request.owner_id !== req.user.id) {
    return res.status(403).json({ error: 'Only the skill owner can respond to requests.' });
  }

  db.prepare('UPDATE skill_requests SET status = ? WHERE id = ?')
    .run(status, req.params.requestId);

  return res.json({ message: `Request ${status}.` });
});

// ── Helper ────────────────────────────────────────────────────────────────────
function formatSkill(s) {
  return {
    id:            s.id,
    title:         s.title,
    category:      s.category,
    description:   s.description,
    ownerId:       s.owner_id,
    ownerName:     s.owner_name,
    ownerYear:     s.owner_year,
    availability:  s.availability,
    prerequisites: s.prerequisites,
    createdAt:     s.created_at,
  };
}

module.exports = router;
