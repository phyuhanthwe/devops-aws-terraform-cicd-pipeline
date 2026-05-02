"""
Simple tests for the API.
GitHub Actions will run these automatically before deploying.
If tests FAIL → deployment is STOPPED. ✅ This is the power of CI/CD!
"""
from fastapi.testclient import TestClient
from unittest.mock import patch, MagicMock
from app.main import app

client = TestClient(app)


def test_root_endpoint():
    """Test that homepage returns 200 OK"""
    response = client.get("/")
    assert response.status_code == 200
    assert "message" in response.json()


def test_health_check():
    """Test health endpoint - AWS uses this to know if app is alive"""
    response = client.get("/health")
    assert response.status_code == 200
    assert response.json()["status"] == "healthy"


@patch("main.get_db_connection")
def test_get_users(mock_db):
    """Test get users - we mock the database so we don't need a real DB to test"""
    mock_conn = MagicMock()
    mock_conn.cursor.return_value.fetchall.return_value = [
        (1, "Alice", "alice@test.com"),
        (2, "Bob", "bob@test.com"),
    ]
    mock_db.return_value = mock_conn

    response = client.get("/users")
    assert response.status_code == 200
    assert len(response.json()["users"]) == 2


@patch("main.get_db_connection")
def test_create_user(mock_db):
    """Test creating a user"""
    mock_conn = MagicMock()
    mock_conn.cursor.return_value.fetchone.return_value = (1,)
    mock_db.return_value = mock_conn

    response = client.post("/users", json={"name": "Charlie", "email": "charlie@test.com"})
    assert response.status_code == 200
    assert response.json()["message"] == "User created!"
