from fastapi import FastAPI, HTTPException, Query
import sqlite3

app = FastAPI()

def get_db():
    conn = sqlite3.connect("courses.db")
    conn.row_factory = sqlite3.Row
    return conn

@app.get("/courses")
def get_courses():
    conn = get_db()
    cur = conn.cursor()
    courses = cur.execute("SELECT * FROM courses").fetchall()
    return [dict(c) for c in courses]

@app.get("/courses/{course_id}")
def get_course(course_id: int):
    conn = get_db()
    cur = conn.cursor()
    course = cur.execute("SELECT * FROM courses WHERE id=?", (course_id,)).fetchone()
    if not course:
        raise HTTPException(status_code=404, detail="Course not found")
    return dict(course)

@app.get("/courses/{course_id}/chapters")
def get_chapters(course_id: int):
    conn = get_db()
    cur = conn.cursor()
    chapters = cur.execute("SELECT * FROM chapters WHERE course_id=?", (course_id,)).fetchall()
    return [dict(ch) for ch in chapters]

@app.post("/courses/{course_id}/{chapter_id}")
def rate_chapter(course_id: int, chapter_id: int, rating: int = Query(..., ge=-1, le=1)):
    conn = get_db()
    cur = conn.cursor()
    
    # Check if chapter exists
    chapter = cur.execute("SELECT * FROM chapters WHERE id=? AND course_id=?", (chapter_id, course_id)).fetchone()
    if not chapter:
        raise HTTPException(status_code=404, detail="Chapter not found")
    
    # Update rating
    total = chapter["rating_total"] + rating
    count = chapter["rating_count"] + 1
    cur.execute("UPDATE chapters SET rating_total=?, rating_count=? WHERE id=?", (total, count, chapter_id))
    conn.commit()

    chapter = cur.execute("SELECT * FROM chapters WHERE id=?", (chapter_id,)).fetchone()
    return dict(chapter)
