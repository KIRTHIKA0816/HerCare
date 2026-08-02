import mysql.connector
from mysql.connector import Error

# ---------------------------------------------
# MySQL connection configuration
# Update these values to match your local setup
# ---------------------------------------------
DB_CONFIG = {
    'host': 'mysql.railway.internal',
    'port': 3306,
    'user': 'root',
    'password': 'yuQwPkPRwxlTVZOFhRLHTvrJUuZyNGcF',
    'database': 'railway'
}


def get_db_connection():
    """Returns a new MySQL connection."""
    try:
        conn = mysql.connector.connect(**DB_CONFIG)
        return conn
    except Error as e:
        print(f"Database connection error: {e}")
        raise


def init_db():
    """
    Creates the database (if missing) and all tables.
    Run this once, or just import database/hercare_database.sql
    directly into MySQL Workbench / CLI.
    """
    conn = mysql.connector.connect(
        host=DB_CONFIG['host'],
        port=DB_CONFIG['port'],
        user=DB_CONFIG['user'],
        password=DB_CONFIG['password']
    )
    cursor = conn.cursor()
    cursor.execute("CREATE DATABASE IF NOT EXISTS hercare_db")
    cursor.execute("USE hercare_db")

    cursor.execute('''
        CREATE TABLE IF NOT EXISTS users (
            user_id INT AUTO_INCREMENT PRIMARY KEY,
            name VARCHAR(100) NOT NULL,
            email VARCHAR(150) UNIQUE NOT NULL,
            password VARCHAR(255) NOT NULL,
            age INT,
            height FLOAT,
            weight FLOAT,
            created_date DATE DEFAULT (CURRENT_DATE)
        )
    ''')

    cursor.execute('''
        CREATE TABLE IF NOT EXISTS period_tracker (
            period_id INT AUTO_INCREMENT PRIMARY KEY,
            user_id INT NOT NULL,
            start_date DATE NOT NULL,
            end_date DATE,
            cycle_length INT DEFAULT 28,
            flow_level ENUM('Light', 'Medium', 'Heavy') DEFAULT 'Medium',
            FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
        )
    ''')

    cursor.execute('''
        CREATE TABLE IF NOT EXISTS symptoms (
            symptom_id INT AUTO_INCREMENT PRIMARY KEY,
            user_id INT NOT NULL,
            date DATE NOT NULL,
            pain_level INT,
            mood VARCHAR(50),
            acne BOOLEAN DEFAULT FALSE,
            hair_fall BOOLEAN DEFAULT FALSE,
            cramps BOOLEAN DEFAULT FALSE,
            notes TEXT,
            FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
        )
    ''')

    cursor.execute('''
        CREATE TABLE IF NOT EXISTS pcod_tracker (
            pcod_id INT AUTO_INCREMENT PRIMARY KEY,
            user_id INT NOT NULL,
            date DATE NOT NULL DEFAULT (CURRENT_DATE),
            weight_change FLOAT,
            sleep_hours FLOAT,
            stress_level INT,
            exercise_done BOOLEAN DEFAULT FALSE,
            water_intake INT,
            FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
        )
    ''')

    cursor.execute('''
        CREATE TABLE IF NOT EXISTS reminders (
            reminder_id INT AUTO_INCREMENT PRIMARY KEY,
            user_id INT NOT NULL,
            reminder_type ENUM('Period', 'Water', 'Exercise', 'Medicine') NOT NULL,
            reminder_date DATE NOT NULL,
            status ENUM('Pending', 'Completed', 'Cancelled') DEFAULT 'Pending',
            FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
        )
    ''')

    cursor.execute('''
        CREATE TABLE IF NOT EXISTS food_tracker (
            food_id INT AUTO_INCREMENT PRIMARY KEY,
            user_id INT NOT NULL,
            date DATE NOT NULL,
            meal_type ENUM('Breakfast', 'Lunch', 'Dinner', 'Snack') NOT NULL,
            description TEXT,
            FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
        )
    ''')

    cursor.execute('''
        CREATE TABLE IF NOT EXISTS water_log (
            water_id INT AUTO_INCREMENT PRIMARY KEY,
            user_id INT NOT NULL,
            date DATE NOT NULL DEFAULT (CURRENT_DATE),
            glasses INT NOT NULL DEFAULT 0,
            goal INT NOT NULL DEFAULT 8,
            UNIQUE KEY unique_user_date (user_id, date),
            FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
        )
    ''')

    conn.commit()
    cursor.close()
    conn.close()
    print("HerCare MySQL database initialized successfully.")
if __name__ == "__main__":
    init_db()
