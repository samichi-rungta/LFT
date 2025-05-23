import sqlite3
import json

# Connect to SQLite
conn = sqlite3.connect("courses.db")
cur = conn.cursor()

# Create tables
cur.execute('''
CREATE TABLE IF NOT EXISTS courses (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT,
    date INTEGER,
    description TEXT,
    domain TEXT,
    rating_total INTEGER DEFAULT 0,
    rating_count INTEGER DEFAULT 0
)''')

cur.execute('''
CREATE TABLE IF NOT EXISTS chapters (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    course_id INTEGER,
    name TEXT,
    text TEXT,
    rating_total INTEGER DEFAULT 0,
    rating_count INTEGER DEFAULT 0,
    FOREIGN KEY(course_id) REFERENCES courses(id)
)''')

# Insert JSON data
with open("courses.json") as f:
    data = json.load(f)

for course in data:
    cur.execute("INSERT INTO courses (name, date, description, domain) VALUES (?, ?, ?, ?)", 
                (course["name"], course["date"], course["description"], ",".join(course["domain"])))
    course_id = cur.lastrowid
    for chapter in course["chapters"]:
        cur.execute("INSERT INTO chapters (course_id, name, text) VALUES (?, ?, ?)",
                    (course_id, chapter["name"], chapter["text"]))

conn.commit()
conn.close()
