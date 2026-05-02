from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from app.database import get_db_connection, init_db
import os
import uvicorn
from fastapi.staticfiles import StaticFiles
from fastapi.responses import FileResponse

# app = FastAPI(title="DevOps Practice API")
app = FastAPI(title="Cloud User Management Platform")

app.mount("/static", StaticFiles(directory="static"), name="static")

# ── Model (shape of data) ─────────────────────────────────────────────────────
class User(BaseModel):
    name: str
    email: str

# ── Routes (endpoints) ────────────────────────────────────────────────────────

# @app.get("/")
# def root():
#     """Just a hello world endpoint"""
#     return {"message": "Hello! API is running ✅"}


@app.get("/")
def read_index():
    return FileResponse("static/index.html")

@app.get("/health")
def health_check():
    """GitHub Actions / AWS will call this to check if app is alive"""
    return {"status": "healthy"}


@app.get("/users")
def get_all_users():
    """Get all users from PostgreSQL database"""
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("SELECT id, name, email FROM users;")
    rows = cursor.fetchall()
    conn.close()
    return {"users": [{"id": r[0], "name": r[1], "email": r[2]} for r in rows]}
    # return {"users": [{"id": 1, "name": "Test", "email": "test@test.com"}]}


@app.post("/users")
def create_user(user: User):
    """Add a new user to PostgreSQL database"""
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute(
        "INSERT INTO users (name, email) VALUES (%s, %s) RETURNING id;",
        (user.name, user.email)
    )
    new_id = cursor.fetchone()[0]
    conn.commit()
    conn.close()
    return {"message": "User created!", "id": new_id}


@app.delete("/users/{user_id}")
def delete_user(user_id: int):
    """Delete a user by ID"""
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("DELETE FROM users WHERE id = %s RETURNING id;", (user_id,))
    deleted = cursor.fetchone()
    conn.commit()
    conn.close()
    if not deleted:
        raise HTTPException(status_code=404, detail="User not found")
    return {"message": f"User {user_id} deleted!"}

if __name__ == "__main__":
    init_db()
    uvicorn.run("app.main:app", host="0.0.0.0", port=8000, reload=True)