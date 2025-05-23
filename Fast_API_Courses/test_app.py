from fastapi.testclient import TestClient
from main import app

client = TestClient(app)

def test_get_courses():
    response = client.get("/courses")
    assert response.status_code == 200
    assert isinstance(response.json(), list)

def test_get_chapters():
    response = client.get("/courses/1/chapters")
    assert response.status_code == 200
    chapters = response.json()
    assert isinstance(chapters, list)
    assert "name" in chapters[0]

def test_rate_chapter():
    response = client.post("/courses/1/1?rating=1")
    assert response.status_code == 200
    chapter = response.json()
    assert "rating_total" in chapter
    assert "rating_count" in chapter
    assert chapter["rating_count"] > 0

def test_rate_chapter_invalid():
    response = client.post("/courses/1/999?rating=1")
    assert response.status_code == 404
