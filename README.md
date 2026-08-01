# HerCare 💗

A period and cycle tracking app built with **Flutter** (frontend) and **Flask + SQLite** (backend).

## Features
- User registration & login
- Period logging with flow intensity
- Symptom & mood tracking
- Personal notes
- Cycle calendar overview
- Local notifications for upcoming periods

## Project Structure
```
HerCare/
├── frontend/     # Flutter app
├── backend/      # Flask REST API
├── database/     # SQL schema
└── documentation/
```

## Getting Started

### Backend
```bash
cd backend
pip install -r requirements.txt
python app.py
```
The API runs on `http://localhost:5000/api`.

### Frontend
```bash
cd frontend
flutter pub get
flutter run
```
Update `baseUrl` in `lib/services/api_service.dart` to point to your backend
(use `10.0.2.2` for Android emulator, your machine's LAN IP for a physical device).

## API Endpoints

| Method | Endpoint                       | Description                          |
|--------|----------------------------------|----------------------------------------|
| POST   | /api/users/register              | Create account (name, email, password, age, height, weight) |
| POST   | /api/users/login                 | Log in                                |
| GET    | /api/users/<user_id>             | Get user profile                      |
| PUT    | /api/users/<user_id>             | Update profile fields                 |
| POST   | /api/periods                     | Log a period                          |
| GET    | /api/periods/<user_id>           | Get period history                    |
| DELETE | /api/periods/<period_id>         | Delete a period log                   |
| GET    | /api/periods/predict/<user_id>   | Predict next period date & cycle day  |
| POST   | /api/symptoms                    | Log symptoms/mood                     |
| GET    | /api/symptoms/<user_id>          | Get symptom history                   |
| DELETE | /api/symptoms/<symptom_id>       | Delete a symptom entry                |
| POST   | /api/pcod                        | Log a PCOD lifestyle entry            |
| GET    | /api/pcod/<user_id>              | Get PCOD entry history                |
| GET    | /api/pcod/summary/<user_id>      | 30-day PCOD averages                  |
| POST   | /api/reminders                   | Create a reminder                     |
| GET    | /api/reminders/<user_id>         | Get reminders                         |
| PUT    | /api/reminders/<reminder_id>     | Update reminder status                |
| DELETE | /api/reminders/<reminder_id>     | Delete a reminder                     |
| POST   | /api/food                        | Log a meal                            |
| GET    | /api/food/<user_id>              | Get meal history                      |
| DELETE | /api/food/<food_id>               | Delete a meal entry                   |
| GET    | /api/water/<user_id>/today       | Get today's water intake              |
| POST   | /api/water/<user_id>/add         | Add/subtract a glass (body: amount)   |
| PUT    | /api/water/<user_id>/goal        | Update daily water goal               |
| GET    | /api/water/<user_id>/history     | Last 7 days of water intake           |

## Tech Stack
- **Frontend:** Flutter, Dart, http, flutter_local_notifications
- **Backend:** Python, Flask, Flask-Cors, SQLite
- **Database:** SQLite (see `database/hercare_database.sql`)
