import os
import psycopg2
from psycopg2 import Error


# ---------------------------------------------
# Supabase PostgreSQL connection configuration
# ---------------------------------------------

DB_CONFIG = {
    "host": os.getenv("DB_HOST"),
    "port": int(os.getenv("DB_PORT", "5432")),
    "user": os.getenv("DB_USER"),
    "password": os.getenv("DB_PASSWORD"),
    "database": os.getenv("DB_NAME"),
}


def get_db_connection():
    """Returns a new PostgreSQL connection."""
    try:
        conn = psycopg2.connect(**DB_CONFIG)
        return conn
    except Error as e:
        print(f"Database connection error: {e}")
        raise


def init_db():
    """
    Creates all HerCare tables in Supabase PostgreSQL.
    """

    conn = get_db_connection()
    cursor = conn.cursor()

    try:

        # ---------------------------------------------
        # Users table
        # ---------------------------------------------
        cursor.execute("""
            CREATE TABLE IF NOT EXISTS users (
                user_id SERIAL PRIMARY KEY,
                name VARCHAR(100) NOT NULL,
                email VARCHAR(150) UNIQUE NOT NULL,
                password VARCHAR(255) NOT NULL,
                age INTEGER,
                height REAL,
                weight REAL,
                created_date DATE DEFAULT CURRENT_DATE
            )
        """)

        # ---------------------------------------------
        # Period Tracker
        # ---------------------------------------------
        cursor.execute("""
            CREATE TABLE IF NOT EXISTS period_tracker (
                period_id SERIAL PRIMARY KEY,
                user_id INTEGER NOT NULL,
                start_date DATE NOT NULL,
                end_date DATE,
                cycle_length INTEGER DEFAULT 28,
                flow_level VARCHAR(20) DEFAULT 'Medium',
                FOREIGN KEY (user_id)
                    REFERENCES users(user_id)
                    ON DELETE CASCADE
            )
        """)

        # ---------------------------------------------
        # Symptoms
        # ---------------------------------------------
        cursor.execute("""
            CREATE TABLE IF NOT EXISTS symptoms (
                symptom_id SERIAL PRIMARY KEY,
                user_id INTEGER NOT NULL,
                date DATE NOT NULL,
                pain_level INTEGER,
                mood VARCHAR(50),
                acne BOOLEAN DEFAULT FALSE,
                hair_fall BOOLEAN DEFAULT FALSE,
                cramps BOOLEAN DEFAULT FALSE,
                notes TEXT,
                FOREIGN KEY (user_id)
                    REFERENCES users(user_id)
                    ON DELETE CASCADE
            )
        """)

        # ---------------------------------------------
        # PCOD Tracker
        # ---------------------------------------------
        cursor.execute("""
            CREATE TABLE IF NOT EXISTS pcod_tracker (
                pcod_id SERIAL PRIMARY KEY,
                user_id INTEGER NOT NULL,
                date DATE NOT NULL DEFAULT CURRENT_DATE,
                weight_change REAL,
                sleep_hours REAL,
                stress_level INTEGER,
                exercise_done BOOLEAN DEFAULT FALSE,
                water_intake INTEGER,
                FOREIGN KEY (user_id)
                    REFERENCES users(user_id)
                    ON DELETE CASCADE
            )
        """)

        # ---------------------------------------------
        # Reminders
        # ---------------------------------------------
        cursor.execute("""
            CREATE TABLE IF NOT EXISTS reminders (
                reminder_id SERIAL PRIMARY KEY,
                user_id INTEGER NOT NULL,
                reminder_type VARCHAR(30) NOT NULL,
                reminder_date DATE NOT NULL,
                status VARCHAR(20) DEFAULT 'Pending',
                FOREIGN KEY (user_id)
                    REFERENCES users(user_id)
                    ON DELETE CASCADE
            )
        """)

        # ---------------------------------------------
        # Food Tracker
        # ---------------------------------------------
        cursor.execute("""
            CREATE TABLE IF NOT EXISTS food_tracker (
                food_id SERIAL PRIMARY KEY,
                user_id INTEGER NOT NULL,
                date DATE NOT NULL,
                meal_type VARCHAR(20) NOT NULL,
                description TEXT,
                FOREIGN KEY (user_id)
                    REFERENCES users(user_id)
                    ON DELETE CASCADE
            )
        """)

        # ---------------------------------------------
        # Water Log
        # ---------------------------------------------
        cursor.execute("""
            CREATE TABLE IF NOT EXISTS water_log (
                water_id SERIAL PRIMARY KEY,
                user_id INTEGER NOT NULL,
                date DATE NOT NULL DEFAULT CURRENT_DATE,
                glasses INTEGER NOT NULL DEFAULT 0,
                goal INTEGER NOT NULL DEFAULT 8,
                UNIQUE(user_id, date),
                FOREIGN KEY (user_id)
                    REFERENCES users(user_id)
                    ON DELETE CASCADE
            )
        """)

        conn.commit()

        print("HerCare Supabase PostgreSQL database initialized successfully.")

    except Error as e:
        conn.rollback()
        print(f"Database initialization error: {e}")
        raise

    finally:
        cursor.close()
        conn.close()


if __name__ == "__main__":
    init_db()
