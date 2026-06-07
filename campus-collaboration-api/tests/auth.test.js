// tests/auth.test.js
const request  = require('supertest');
const app      = require('../src/index');
const { getTestDb, closeDb } = require('../src/db/database');

beforeAll(() => { getTestDb(); });
afterAll(() => { closeDb(); });

describe('Auth API', () => {
  const testUser = {
    fullName: 'Test User',
    email: 'test@aau.edu.et',
    password: 'Password123',
  };
  let token;

  // ── Register ──────────────────────────────────────────────────────────────

  test('POST /auth/register — success', async () => {
    const res = await request(app).post('/auth/register').send(testUser);
    expect(res.status).toBe(201);
    expect(res.body.token).toBeDefined();
    expect(res.body.user.email).toBe(testUser.email);
    expect(res.body.user.fullName).toBe(testUser.fullName);
    token = res.body.token;
  });

  test('POST /auth/register — duplicate email returns 409', async () => {
    const res = await request(app).post('/auth/register').send(testUser);
    expect(res.status).toBe(409);
    expect(res.body.error).toMatch(/already registered/i);
  });

  test('POST /auth/register — missing fields returns 400', async () => {
    const res = await request(app)
      .post('/auth/register')
      .send({ email: 'test2@aau.edu.et' });
    expect(res.status).toBe(400);
  });

  test('POST /auth/register — short password returns 400', async () => {
    const res = await request(app)
      .post('/auth/register')
      .send({ fullName: 'A', email: 'a@aau.edu.et', password: '123' });
    expect(res.status).toBe(400);
    expect(res.body.error).toMatch(/8 characters/i);
  });

  // ── Login ─────────────────────────────────────────────────────────────────

  test('POST /auth/login — success', async () => {
    const res = await request(app).post('/auth/login').send({
      email: testUser.email,
      password: testUser.password,
    });
    expect(res.status).toBe(200);
    expect(res.body.token).toBeDefined();
    token = res.body.token;
  });

  test('POST /auth/login — wrong password returns 401', async () => {
    const res = await request(app).post('/auth/login').send({
      email: testUser.email,
      password: 'wrongpassword',
    });
    expect(res.status).toBe(401);
    expect(res.body.error).toMatch(/incorrect password/i);
  });

  test('POST /auth/login — unknown email returns 401', async () => {
    const res = await request(app).post('/auth/login').send({
      email: 'nobody@aau.edu.et',
      password: 'Password123',
    });
    expect(res.status).toBe(401);
  });

  // ── Auth/me ───────────────────────────────────────────────────────────────

  test('GET /auth/me — returns user with valid token', async () => {
    const res = await request(app)
      .get('/auth/me')
      .set('Authorization', `Bearer ${token}`);
    expect(res.status).toBe(200);
    expect(res.body.email).toBe(testUser.email);
  });

  test('GET /auth/me — returns 401 without token', async () => {
    const res = await request(app).get('/auth/me');
    expect(res.status).toBe(401);
  });

  // ── Update Profile ────────────────────────────────────────────────────────

  test('PUT /auth/profile — updates profile', async () => {
    const res = await request(app)
      .put('/auth/profile')
      .set('Authorization', `Bearer ${token}`)
      .send({ fullName: 'Updated Name', bio: 'CS junior' });
    expect(res.status).toBe(200);
    expect(res.body.fullName).toBe('Updated Name');
    expect(res.body.bio).toBe('CS junior');
  });

  // ── Change Password ───────────────────────────────────────────────────────

  test('PUT /auth/change-password — success', async () => {
    const res = await request(app)
      .put('/auth/change-password')
      .set('Authorization', `Bearer ${token}`)
      .send({ currentPassword: testUser.password, newPassword: 'NewPass456' });
    expect(res.status).toBe(200);
  });

  test('PUT /auth/change-password — wrong current password returns 401', async () => {
    const res = await request(app)
      .put('/auth/change-password')
      .set('Authorization', `Bearer ${token}`)
      .send({ currentPassword: 'wrongpass', newPassword: 'AnotherPass789' });
    expect(res.status).toBe(401);
  });

  // ── Logout ────────────────────────────────────────────────────────────────

  test('POST /auth/logout — success with token', async () => {
    const res = await request(app)
      .post('/auth/logout')
      .set('Authorization', `Bearer ${token}`);
    expect(res.status).toBe(200);
  });

  // ── Delete Account ────────────────────────────────────────────────────────

  test('DELETE /auth/account — deletes account', async () => {
    // Register a fresh user to delete
    const reg = await request(app).post('/auth/register').send({
      fullName: 'Delete Me',
      email: 'delete@aau.edu.et',
      password: 'DeletePass123',
    });
    const delToken = reg.body.token;

    const res = await request(app)
      .delete('/auth/account')
      .set('Authorization', `Bearer ${delToken}`);
    expect(res.status).toBe(200);

    // Confirm can no longer login
    const login = await request(app).post('/auth/login').send({
      email: 'delete@aau.edu.et',
      password: 'DeletePass123',
    });
    expect(login.status).toBe(401);
  });
});
