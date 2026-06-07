// src/routes/groups.js
const express = require('express');
const { v4: uuidv4 } = require('uuid');
const { getDb } = require('../db/database');
const { authenticate } = require('../middleware/auth');

const router = express.Router();

// ── GET /groups ───────────────────────────────────────────────────────────────
router.get('/', (req, res) => {
  const db = getDb();
  const groups = db.prepare(`
    SELECT * FROM study_groups ORDER BY created_at DESC
  `).all();
  return res.json(groups.map(formatGroup));
});

// ── GET /groups/my ────────────────────────────────────────────────────────────
router.get('/my', authenticate, (req, res) => {
  const db = getDb();
  const groups = db.prepare(`
    SELECT sg.*
    FROM study_groups sg
    JOIN group_members gm ON sg.id = gm.group_id
    WHERE gm.user_id = ?
    ORDER BY sg.created_at DESC
  `).all(req.user.id);
  return res.json(groups.map(formatGroup));
});

// ── GET /groups/:id ───────────────────────────────────────────────────────────
router.get('/:id', (req, res) => {
  const db = getDb();
  const group = db.prepare('SELECT * FROM study_groups WHERE id = ?').get(req.params.id);
  if (!group) return res.status(404).json({ error: 'Group not found.' });

  const members = db.prepare(`
    SELECT * FROM group_members WHERE group_id = ? ORDER BY joined_at ASC
  `).all(req.params.id);

  return res.json({ ...formatGroup(group), members });
});

// ── POST /groups ──────────────────────────────────────────────────────────────
router.post('/', authenticate, (req, res) => {
  const { name, topic, description } = req.body;
  if (!name || !topic || !description) {
    return res.status(400).json({ error: 'name, topic and description are required.' });
  }

  const db = getDb();
  const user = db.prepare('SELECT * FROM users WHERE id = ?').get(req.user.id);
  const now = Date.now();
  const groupId = uuidv4();

  const group = {
    id: groupId,
    name: name.trim(),
    topic: topic.trim(),
    description: description.trim(),
    creator_id: req.user.id,
    member_count: 1,
    created_at: now,
  };

  db.prepare(`
    INSERT INTO study_groups (id, name, topic, description, creator_id, member_count, created_at)
    VALUES (@id, @name, @topic, @description, @creator_id, @member_count, @created_at)
  `).run(group);

  // Creator becomes admin member
  db.prepare(`
    INSERT INTO group_members (id, group_id, user_id, user_name, user_field, role, joined_at)
    VALUES (?, ?, ?, ?, ?, 'admin', ?)
  `).run(uuidv4(), groupId, req.user.id, user.full_name, user.bio || '', now);

  return res.status(201).json(formatGroup(group));
});

// ── PUT /groups/:id ───────────────────────────────────────────────────────────
router.put('/:id', authenticate, (req, res) => {
  const db = getDb();
  const group = db.prepare('SELECT * FROM study_groups WHERE id = ?').get(req.params.id);

  if (!group) return res.status(404).json({ error: 'Group not found.' });
  if (group.creator_id !== req.user.id) {
    return res.status(403).json({ error: 'Only the group creator can edit this group.' });
  }

  const { name, topic, description } = req.body;

  db.prepare(`
    UPDATE study_groups SET name = ?, topic = ?, description = ? WHERE id = ?
  `).run(
    name?.trim()        ?? group.name,
    topic?.trim()       ?? group.topic,
    description?.trim() ?? group.description,
    req.params.id,
  );

  const updated = db.prepare('SELECT * FROM study_groups WHERE id = ?').get(req.params.id);
  return res.json(formatGroup(updated));
});

// ── DELETE /groups/:id ────────────────────────────────────────────────────────
router.delete('/:id', authenticate, (req, res) => {
  const db = getDb();
  const group = db.prepare('SELECT * FROM study_groups WHERE id = ?').get(req.params.id);

  if (!group) return res.status(404).json({ error: 'Group not found.' });
  if (group.creator_id !== req.user.id) {
    return res.status(403).json({ error: 'Only the group creator can delete this group.' });
  }

  db.prepare('DELETE FROM study_groups WHERE id = ?').run(req.params.id);
  return res.json({ message: 'Group deleted successfully.' });
});

// ── POST /groups/:id/join ─────────────────────────────────────────────────────
router.post('/:id/join', authenticate, (req, res) => {
  const db = getDb();
  const group = db.prepare('SELECT * FROM study_groups WHERE id = ?').get(req.params.id);
  if (!group) return res.status(404).json({ error: 'Group not found.' });

  const already = db.prepare(`
    SELECT id FROM group_members WHERE group_id = ? AND user_id = ?
  `).get(req.params.id, req.user.id);

  if (already) return res.status(409).json({ error: 'Already a member.' });

  const user = db.prepare('SELECT * FROM users WHERE id = ?').get(req.user.id);

  db.prepare(`
    INSERT INTO group_members (id, group_id, user_id, user_name, user_field, role, joined_at)
    VALUES (?, ?, ?, ?, ?, 'member', ?)
  `).run(uuidv4(), req.params.id, req.user.id, user.full_name, user.bio || '', Date.now());

  db.prepare('UPDATE study_groups SET member_count = member_count + 1 WHERE id = ?')
    .run(req.params.id);

  return res.status(201).json({ message: 'Joined group successfully.' });
});

// ── DELETE /groups/:id/leave ──────────────────────────────────────────────────
router.delete('/:id/leave', authenticate, (req, res) => {
  const db = getDb();
  const member = db.prepare(`
    SELECT * FROM group_members WHERE group_id = ? AND user_id = ?
  `).get(req.params.id, req.user.id);

  if (!member) return res.status(404).json({ error: 'You are not a member of this group.' });

  // Creator cannot leave — must delete the group instead
  const group = db.prepare('SELECT * FROM study_groups WHERE id = ?').get(req.params.id);
  if (group.creator_id === req.user.id) {
    return res.status(400).json({ error: 'Creator cannot leave. Delete the group instead.' });
  }

  db.prepare('DELETE FROM group_members WHERE group_id = ? AND user_id = ?')
    .run(req.params.id, req.user.id);

  db.prepare(`
    UPDATE study_groups SET member_count = MAX(member_count - 1, 0) WHERE id = ?
  `).run(req.params.id);

  return res.json({ message: 'Left group successfully.' });
});

// ── Helper ────────────────────────────────────────────────────────────────────
function formatGroup(g) {
  return {
    id:          g.id,
    name:        g.name,
    topic:       g.topic,
    description: g.description,
    creatorId:   g.creator_id,
    memberCount: g.member_count,
    createdAt:   g.created_at,
  };
}

module.exports = router;
