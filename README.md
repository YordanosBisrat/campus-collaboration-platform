# Campus Skill Exchange & Study Group Management System

A mobile platform for university students to exchange skills and form study groups. Students can offer skills they know, request skills they want to learn, create and join study groups, and manage their academic profiles — all within a campus community.

---

## Members

| Name | ID |
| --------- | ----------- |
| Christian Elias | UGR/8399/16 |
| Menal Abdulkadir | UGR/7907/16 |
| Natnael Henok | UGR/9671/16 |
| Ruth Tewodros | UGR/7383/16 |
| Yordanos Bisrat | UGR/3362/16 |

---
## Demo
https://www.loom.com/share/f7c9302272634024aa49b959ab4e480d
## Features

- **Skill Exchange** — post skills you can teach, browse skills others offer, and send/receive skill requests (full CRUD)
- **Study Groups** — create topic-based study groups, join or leave groups, manage membership (full CRUD)
- **Authentication** — signup, login, logout, and delete account
- **Authorization** — JWT-based session management; unauthenticated users are redirected to login
- **Profile Management** — edit your profile and change your password
- **Local-first** — Flutter app uses SQLite for offline caching; backend uses SQLite via better-sqlite3

---

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Mobile frontend | Flutter 3 (Dart), Riverpod, GoRouter, sqflite |
| REST API backend | Node.js, Express, better-sqlite3, JWT, bcryptjs |
| Local database (app) | SQLite via sqflite |
| Local database (API) | SQLite via better-sqlite3 |
| Testing (backend) | Jest, Supertest |
| Testing (Flutter) | flutter_test, integration_test |

---

## Project Structure

```
campus-collaboration-platform/
├── campus-collaboration-api/       # Node.js REST API
│   ├── src/
│   │   ├── db/database.js          # SQLite schema & connection
│   │   ├── middleware/auth.js      # JWT middleware
│   │   └── routes/                 # auth, skills, groups
│   └── tests/                      # Jest integration tests
│
└── campus-colaboration-flutter/    # Flutter mobile app
    ├── lib/
    │   ├── core/                   # theme, routing, network, widgets
    │   └── features/               # auth, skills, groups, profile, home
    ├── test/                       # unit & widget tests
    └── integration_test/           # integration tests
```

---

## Getting Started

### Prerequisites

- [Node.js](https://nodejs.org/) v18 or higher
- [Flutter SDK](https://flutter.dev/docs/get-started/install) 3.x (Dart SDK ^3.11)
- An Android emulator, iOS simulator, or physical device

### 1. Start the backend API

```bash
cd campus-collaboration-api
npm install
npm start
```

The API will run at `http://localhost:3000`. You should see all available routes printed in the terminal.

To run the API tests:

```bash
npm test
```

### 2. Run the Flutter app

Open a new terminal:

```bash
cd campus-colaboration-flutter
flutter pub get
flutter run
```

> **Note:** The Flutter app must be run on a device or emulator that can reach `localhost:3000`. For Android emulators, use `10.0.2.2:3000` instead of `localhost:3000` if needed.

To run Flutter unit and widget tests:

```bash
flutter test
```

To run Flutter integration tests (requires the API to be running):

```bash
flutter test integration_test/
```

---
