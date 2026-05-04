import psycopg2
import os

def get_db_connection():
    """
    Connect to PostgreSQL.
    All values come from environment variables (set in docker-compose or AWS Secrets Manager).
    """
    conn = psycopg2.connect(
        host=os.getenv("DB_HOST"),
        database=os.getenv("DB_NAME"),
        user=os.getenv("DB_USER"),
        password=os.getenv("DB_PASSWORD"),
        port=os.getenv("DB_PORT", "5432")
    )
    return conn


def init_db():
    """
    Create the users table if it doesn't exist yet.
    Run this once when the app starts.
    """
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS users (
            id    SERIAL PRIMARY KEY,
            name  VARCHAR(100) NOT NULL,
            email VARCHAR(100) UNIQUE NOT NULL
        );
    """)
    conn.commit()
    conn.close()
    print("✅ Database table ready!")
