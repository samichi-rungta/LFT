# FastAPI Employee Management API
A RESTful API to manage employee records built using **FastAPI**, **SQLite**, and **SQLAlchemy**.

This application provides full CRUD operations for employee data and uses FastAPI's auto-generated Swagger documentation for easy testing and exploration.

---

## Features

- Create, Read, Update, Delete (CRUD) operations for employee data
- SQLite database integration with SQLAlchemy ORM
- Data validation using Pydantic
- Error handling with proper HTTP status codes
- Auto-generated API documentation (Swagger UI and Redoc)
- Modular project structure

---

## Tech Stack

- **Backend Framework**: FastAPI
- **Database**: SQLite
- **ORM**: SQLAlchemy
- **Validation**: Pydantic
- **Server**: Uvicorn (ASGI server)

---

## Project Structure
employee-api/
├── main.py           # FastAPI application with API routes
├── models.py         # SQLAlchemy database models
├── database.py       # DB connection and base setup
├── schemas.py        # Pydantic models for request/response validation
├── crud.py           # CRUD logic abstracted from API layer
├── employees.db      # SQLite database (auto-generated)
├── requirements.txt  # Project dependencies
└── README.md         # Project overview and instructions

---

## Setup Instructions
### 1. Clone the Repository
git clone https://github.com/your-username/employee-api.git
cd employee-api

### 2. Set Up a Virtual Environment
python -m venv venv
source venv/bin/activate      # On Windows: venv\Scripts\activate

### 3. Install Dependencies
pip install -r requirements.txt

### 4. Run the API Server
uvicorn main:app --reload

---

## API Endpoints

| Method | Endpoint          | Description                  |
| ------ | ----------------- | ---------------------------- |
| POST   | `/employees`      | Add a new employee           |
| GET    | `/employees`      | List all employees           |
| GET    | `/employees/{id}` | Get an employee by ID        |
| PUT    | `/employees/{id}` | Update an employee's details |
| DELETE | `/employees/{id}` | Delete an employee by ID     |

---

## Example Requests
### POST /employees
{
  "name": "Alice",
  "age": 30,
  "department": "HR"
}

### PUT /employees/1
{
  "name": "Alice Smith",
  "age": 31,
  "department": "Operations"
}

---

## Auto-Generated Documentation
FastAPI provides documentation out of the box:
* Swagger UI: [http://localhost:8000/docs](http://localhost:8000/docs)
* Redoc: [http://localhost:8000/redoc](http://localhost:8000/redoc)

---

## (Optional) Docker Setup

### Dockerfile (if added):
# Build the image
docker build -t employee-api .

# Run the container
docker run -p 8000:8000 employee-api

---
