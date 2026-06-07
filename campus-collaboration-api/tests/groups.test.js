// tests/groups.test.js
const request = require('supertest');
const app = require('../src/index');
const { getTestDb, closeDb } = require('../src/db/database');

beforeAll(() => { getTestDb(); });
afterAll(() => { closeDb(); });

describe('Groups API', () => {
  let creatorToken;
  let memberToken;
  let groupId;

  // ── Setup ─────────────────────────────────────────────────────────────────

  beforeAll(async () => {
    const creator = await request(app).post('/auth/register').send({
      fullName: 'Group Creator',
      email: 'creator@aau.edu.et',
      password: 'Password123',
    });
    creatorToken = creator.body.token;

    const member = await request(app).post('/auth/register').send({
      fullName: 'Group Member',
      email: 'member@aau.edu.et',
      password: 'Password123',
    });
    memberToken = member.body.token;
  });

  // ── Create Group ──────────────────────────────────────────────────────────

  test('POST /groups — creates group successfully', async () => {
    const res = await request(app)
      .post('/groups')
      .set('Authorization', `Bearer ${creatorToken}`)
      .send({
        name: 'Data Structures Study',
        topic: 'Computer Science',
        description: 'Weekly problem solving sessions',
      });
    expect(res.status).toBe(201);
    expect(res.body.name).toBe('Data Structures Study');
    expect(res.body.memberCount).toBe(1);
    groupId = res.body.id;
  });

  test('POST /groups — returns 400 for missing fields', async () => {
    const res = await request(app)
      .post('/groups')
      .set('Authorization', `Bearer ${creatorToken}`)
      .send({ name: 'Incomplete' });
    expect(res.status).toBe(400);
  });

  test('POST /groups — returns 401 without token', async () => {
    const res = await request(app).post('/groups').send({
      name: 'Test',
      topic: 'Math',
      description: 'Test group',
    });
    expect(res.status).toBe(401);
  });

  // ── Read Groups ───────────────────────────────────────────────────────────

  test('GET /groups — returns list of groups', async () => {
    const res = await request(app).get('/groups');
    expect(res.status).toBe(200);
    expect(Array.isArray(res.body)).toBe(true);
    expect(res.body.length).toBeGreaterThan(0);
  });

  test('GET /groups/:id — returns group with members', async () => {
    const res = await request(app).get(`/groups/${groupId}`);
    expect(res.status).toBe(200);
    expect(res.body.id).toBe(groupId);
    expect(Array.isArray(res.body.members)).toBe(true);
    expect(res.body.members.length).toBe(1); // creator
  });

  test('GET /groups/:id — returns 404 for unknown id', async () => {
    const res = await request(app).get('/groups/nonexistent-id');
    expect(res.status).toBe(404);
  });

  // ── Update Group ──────────────────────────────────────────────────────────

  test('PUT /groups/:id — creator can update group', async () => {
    const res = await request(app)
      .put(`/groups/${groupId}`)
      .set('Authorization', `Bearer ${creatorToken}`)
      .send({ name: 'Advanced Data Structures' });
    expect(res.status).toBe(200);
    expect(res.body.name).toBe('Advanced Data Structures');
  });

  test('PUT /groups/:id — non-creator gets 403', async () => {
    const res = await request(app)
      .put(`/groups/${groupId}`)
      .set('Authorization', `Bearer ${memberToken}`)
      .send({ name: 'Hacked Name' });
    expect(res.status).toBe(403);
  });

  // ── Join Group ────────────────────────────────────────────────────────────

  test('POST /groups/:id/join — member joins successfully', async () => {
    const res = await request(app)
      .post(`/groups/${groupId}/join`)
      .set('Authorization', `Bearer ${memberToken}`);
    expect(res.status).toBe(201);
    expect(res.body.message).toMatch(/joined/i);
  });

  test('POST /groups/:id/join — duplicate join returns 409', async () => {
    const res = await request(app)
      .post(`/groups/${groupId}/join`)
      .set('Authorization', `Bearer ${memberToken}`);
    expect(res.status).toBe(409);
  });

  test('GET /groups/:id — member count increases after join', async () => {
    const res = await request(app).get(`/groups/${groupId}`);
    expect(res.body.memberCount).toBe(2);
    expect(res.body.members.length).toBe(2);
  });

  test('GET /groups/my — returns joined groups', async () => {
    const res = await request(app)
      .get('/groups/my')
      .set('Authorization', `Bearer ${memberToken}`);
    expect(res.status).toBe(200);
    expect(res.body.length).toBeGreaterThan(0);
  });

  // ── Leave Group ───────────────────────────────────────────────────────────

  test('DELETE /groups/:id/leave — member can leave', async () => {
    const res = await request(app)
      .delete(`/groups/${groupId}/leave`)
      .set('Authorization', `Bearer ${memberToken}`);
    expect(res.status).toBe(200);
    expect(res.body.message).toMatch(/left/i);
  });

  test('DELETE /groups/:id/leave — creator cannot leave', async () => {
    const res = await request(app)
      .delete(`/groups/${groupId}/leave`)
      .set('Authorization', `Bearer ${creatorToken}`);
    expect(res.status).toBe(400);
    expect(res.body.error).toMatch(/creator/i);
  });

  test('GET /groups/:id — member count decreases after leave', async () => {
    const res = await request(app).get(`/groups/${groupId}`);
    expect(res.body.memberCount).toBe(1);
  });

  // ── Delete Group ──────────────────────────────────────────────────────────

  test('DELETE /groups/:id — non-creator gets 403', async () => {
    const res = await request(app)
      .delete(`/groups/${groupId}`)
      .set('Authorization', `Bearer ${memberToken}`);
    expect(res.status).toBe(403);
  });

  test('DELETE /groups/:id — creator can delete group', async () => {
    const res = await request(app)
      .delete(`/groups/${groupId}`)
      .set('Authorization', `Bearer ${creatorToken}`);
    expect(res.status).toBe(200);
    expect(res.body.message).toMatch(/deleted/i);
  });

  test('GET /groups/:id — returns 404 after deletion', async () => {
    const res = await request(app).get(`/groups/${groupId}`);
    expect(res.status).toBe(404);
  });
});
