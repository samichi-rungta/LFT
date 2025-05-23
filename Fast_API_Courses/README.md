# 📘 FastAPI Course API (with SQLite)

A simple and scalable REST API built using **FastAPI** that provides:
- Course & chapter listings
- Chapter rating functionality
- Aggregated course ratings

Originally designed for MongoDB, this project uses **SQLite** for easier local development, especially on macOS.

---

## Features
- List all courses
- View individual course details
- View chapters for a course
- Rate individual chapters (+1 or -1)
- Auto-generated Swagger & Redoc documentation
- Unit tested with PyTest
- Dockerized for easy deployment

---

## 🧱 Project Structure
├── courses.json         # Source data for course and chapters
├── courses.db           # Auto-generated SQLite DB (after init)
├── init\_db.py           # Script to load JSON into SQLite
├── main.py              # FastAPI app
├── test\_app.py          # API test suite
├── requirements.txt     # Python dependencies
├── Dockerfile           # Docker setup
└── README.md            # You're here!

---

## Setup & Run Locally

### 1. Install dependencies
pip install -r requirements.txt

### 2. Initialize the database
python init_db.py

This creates `courses.db` and loads data from `courses.json`.

### 3. Start the API
uvicorn main:app --reload

Visit:
* Swagger: [http://localhost:8000/docs](http://localhost:8000/docs)
* ReDoc: [http://localhost:8000/redoc](http://localhost:8000/redoc)

---

## API Endpoints
| Method | Endpoint                    | Description     | 
| GET    | `/courses`                  | List all courses |
| GET    | `/courses/{course_id}`      | Get one course  |
| GET    | `/courses/{course_id}/chapters`| Get chapters of a course|
| POST   | `/courses/{course_id}/{chapter_id}?rating=1` | Rate a chapter (+1 or -1)|

---

## Running Tests

Run all tests using `pytest`:
pytest test_app.py

Expected output:

collected 4 items
test_app.py ....                                       [100%]

---

## Docker Usage
### 1. Build Docker image
docker build -t fastapi-courses .

### 2. Run the container
docker run -p 8000:8000 fastapi-courses

Visit:
* [http://localhost:8000/courses](http://localhost:8000/courses)
* [http://localhost:8000/docs](http://localhost:8000/docs)

---

## Sample Request (Rating a Chapter)
curl -X POST "http://localhost:8000/courses/1/1?rating=1"

---

## Notes
* SQLite is used instead of MongoDB for ease of use and platform compatibility (macOS 12+).
* To use a different database (e.g. PostgreSQL, MongoDB), update the data access logic in `main.py`.

---

