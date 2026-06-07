// tests/skills.test.js
const request = require('supertest');
const app = require('../src/index');
const { getTestDb, closeDb } = require('../src/db/database');

beforeAll(() => { getTestDb(); });
afterAll(() => { closeDb(); });

describe('Skills API', () => {
  let ownerToken;
  let otherToken;
  let skillId;

  // ── Setup: register two users ─────────────────────────────────────────────

  beforeAll(async () => {
    const owner = await request(app).post('/auth/register').send({
      fullName: 'Skill Owner',
      email: 'owner@aau.edu.et',
      password: 'Password123',
    });
    ownerToken = owner.body.token;

    const other = await request(app).post('/auth/register').send({
      fullName: 'Other User',
      email: 'other@aau.edu.et',
      password: 'Password123',
    });
    otherToken = other.body.token;
  });

  // ── Create Skill ──────────────────────────────────────────────────────────

  test('POST /skills — creates skill successfully', async () => {
    const res = await request(app)
      .post('/skills')
      .set('Authorization', `Bearer ${ownerToken}`)
      .send({
        title: 'Java Tutoring',
        category: 'Programming',
        description: 'Help with Java OOP concepts',
        availability: 'Tuesdays 4-6PM',
        prerequisites: 'None',
      });
    expect(res.status).toBe(201);
    expect(res.body.title).toBe('Java Tutoring');
    expect(res.body.category).toBe('Programming');
    expect(res.body.id).toBeDefined();
    skillId = res.body.id;
  });

  test('POST /skills — returns 400 for missing fields', async () => {
    const res = await request(app)
      .post('/skills')
      .set('Authorization', `Bearer ${ownerToken}`)
      .send({ title: 'Incomplete' });
    expect(res.status).toBe(400);
  });

  test('POST /skills — returns 401 without token', async () => {
    const res = await request(app).post('/skills').send({
      title: 'Test',
      category: 'Math',
      description: 'Test skill',
    });
    expect(res.status).toBe(401);
  });

  // ── Read Skills ───────────────────────────────────────────────────────────

  test('GET /skills — returns list of skills', async () => {
    const res = await request(app).get('/skills');
    expect(res.status).toBe(200);
    expect(Array.isArray(res.body)).toBe(true);
    expect(res.body.length).toBeGreaterThan(0);
  });

  test('GET /skills/:id — returns specific skill', async () => {
    const res = await request(app).get(`/skills/${skillId}`);
    expect(res.status).toBe(200);
    expect(res.body.id).toBe(skillId);
    expect(res.body.title).toBe('Java Tutoring');
  });

  test('GET /skills/:id — returns 404 for unknown id', async () => {
    const res = await request(app).get('/skills/nonexistent-id');
    expect(res.status).toBe(404);
  });

  test('GET /skills/my — returns only owner skills', async () => {
    const res = await request(app)
      .get('/skills/my')
      .set('Authorization', `Bearer ${ownerToken}`);
    expect(res.status).toBe(200);
    expect(res.body.every((s) => s.ownerId !== undefined)).toBe(true);
  });

  // ── Update Skill ──────────────────────────────────────────────────────────

  test('PUT /skills/:id — owner can update skill', async () => {
    const res = await request(app)
      .put(`/skills/${skillId}`)
      .set('Authorization', `Bearer ${ownerToken}`)
      .send({ title: 'Advanced Java Tutoring' });
    expect(res.status).toBe(200);
    expect(res.body.title).toBe('Advanced Java Tutoring');
  });

  test('PUT /skills/:id — non-owner gets 403', async () => {
    const res = await request(app)
      .put(`/skills/${skillId}`)
      .set('Authorization', `Bearer ${otherToken}`)
      .send({ title: 'Hacked Title' });
    expect(res.status).toBe(403);
  });

  // ── Request Skill ─────────────────────────────────────────────────────────

  test('POST /skills/:id/request — other user can request skill', async () => {
    const res = await request(app)
      .post(`/skills/${skillId}/request`)
      .set('Authorization', `Bearer ${otherToken}`);
    expect(res.status).toBe(201);
    expect(res.body.status).toBe('pending');
  });

  test('POST /skills/:id/request — duplicate request returns 409', async () => {
    const res = await request(app)
      .post(`/skills/${skillId}/request`)
      .set('Authorization', `Bearer ${otherToken}`);
    expect(res.status).toBe(409);
  });

  test('POST /skills/:id/request — owner cannot request own skill', async () => {
    const res = await request(app)
      .post(`/skills/${skillId}/request`)
      .set('Authorization', `Bearer ${ownerToken}`);
    expect(res.status).toBe(400);
  });

  test('GET /skills/requests — owner sees incoming requests', async () => {
    const res = await request(app)
      .get('/skills/requests')
      .set('Authorization', `Bearer ${ownerToken}`);
    expect(res.status).toBe(200);
    expect(Array.isArray(res.body)).toBe(true);
    expect(res.body.length).toBeGreaterThan(0);
  });

  // ── Delete Skill ──────────────────────────────────────────────────────────

  test('DELETE /skills/:id — non-owner gets 403', async () => {
    const res = await request(app)
      .delete(`/skills/${skillId}`)
      .set('Authorization', `Bearer ${otherToken}`);
    expect(res.status).toBe(403);
  });

  test('DELETE /skills/:id — owner can delete skill', async () => {
    const res = await request(app)
      .delete(`/skills/${skillId}`)
      .set('Authorization', `Bearer ${ownerToken}`);
    expect(res.status).toBe(200);
    expect(res.body.message).toMatch(/deleted/i);
  });

  test('GET /skills/:id — returns 404 after deletion', async () => {
    const res = await request(app).get(`/skills/${skillId}`);
    expect(res.status).toBe(404);
  });
});
