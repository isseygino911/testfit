# TestFit Backend API

Backend server for the TestFit mock test playground app.

## Prerequisites

- Node.js (v18 or higher)
- MySQL Server

## Setup

### 1. Install dependencies

```bash
cd backend
npm install
```

### 2. Configure MySQL Database

Create the database:

```bash
mysql -u root -p < database/setup.sql
```

Or manually:

```sql
CREATE DATABASE IF NOT EXISTS testfit_db;
```

### 3. Environment Variables

Copy the example env file and configure it:

```bash
cp .env.example .env
```

Edit `.env` with your MySQL credentials:

```env
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=your_password
DB_NAME=testfit_db
DB_PORT=3306

JWT_SECRET=your_super_secret_key_change_this
JWT_EXPIRES_IN=7d

PORT=3000
```

### 4. Run the server

Development mode:
```bash
npm run dev
```

Production mode:
```bash
npm start
```

## API Endpoints

### Authentication

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/auth/signup` | Register a new user |
| POST | `/api/auth/login` | Login user |
| GET | `/api/auth/me` | Get current user (requires token) |

### Health Check

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/health` | Check if API is running |

## Request/Response Examples

### Sign Up

```bash
curl -X POST http://localhost:3000/api/auth/signup \
  -H "Content-Type: application/json" \
  -d '{"email": "test@example.com", "password": "password123", "fullName": "Test User"}'
```

### Login

```bash
curl -X POST http://localhost:3000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email": "test@example.com", "password": "password123"}'
```

### Get Current User

```bash
curl http://localhost:3000/api/auth/me \
  -H "Authorization: Bearer YOUR_TOKEN_HERE"
```

## iOS Configuration

For the iOS app to connect to this backend:

1. **Simulator**: Use `http://localhost:3000`
2. **Physical Device**: Use your computer's IP address (e.g., `http://192.168.1.100:3000`)

Update the `baseURL` in `testfit/Services/AuthService.swift` accordingly.
