-- ============================================
-- HerCare Database Schema (MySQL)
-- Smart Menstrual & PCOD Health Companion
-- ============================================

CREATE DATABASE IF NOT EXISTS hercare_db;
USE hercare_db;

-- ---------------------------------------------
-- Table 1: Users
-- ---------------------------------------------
CREATE TABLE IF NOT EXISTS users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    age INT,
    height FLOAT,
    weight FLOAT,
    created_date DATE DEFAULT (CURRENT_DATE)
);

-- ---------------------------------------------
-- Table 2: Period_Tracker
-- ---------------------------------------------
CREATE TABLE IF NOT EXISTS period_tracker (
    period_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE,
    cycle_length INT DEFAULT 28,
    flow_level ENUM('Light', 'Medium', 'Heavy') DEFAULT 'Medium',
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- ---------------------------------------------
-- Table 3: Symptoms
-- ---------------------------------------------
CREATE TABLE IF NOT EXISTS symptoms (
    symptom_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    date DATE NOT NULL,
    pain_level INT CHECK (pain_level BETWEEN 0 AND 5),
    mood VARCHAR(50),
    acne BOOLEAN DEFAULT FALSE,
    hair_fall BOOLEAN DEFAULT FALSE,
    cramps BOOLEAN DEFAULT FALSE,
    notes TEXT,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- ---------------------------------------------
-- Table 4: PCOD_Tracker
-- ---------------------------------------------
CREATE TABLE IF NOT EXISTS pcod_tracker (
    pcod_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    date DATE NOT NULL DEFAULT (CURRENT_DATE),
    weight_change FLOAT,
    sleep_hours FLOAT,
    stress_level INT CHECK (stress_level BETWEEN 1 AND 5),
    exercise_done BOOLEAN DEFAULT FALSE,
    water_intake INT,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- ---------------------------------------------
-- Table 5: Reminders
-- ---------------------------------------------
CREATE TABLE IF NOT EXISTS reminders (
    reminder_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    reminder_type ENUM('Period', 'Water', 'Exercise', 'Medicine') NOT NULL,
    reminder_date DATE NOT NULL,
    status ENUM('Pending', 'Completed', 'Cancelled') DEFAULT 'Pending',
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- ---------------------------------------------
-- Table 6: Food_Tracker
-- ---------------------------------------------
CREATE TABLE IF NOT EXISTS food_tracker (
    food_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    date DATE NOT NULL,
    meal_type ENUM('Breakfast', 'Lunch', 'Dinner', 'Snack') NOT NULL,
    description TEXT,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- ---------------------------------------------
-- Table 7: Water_Log (daily quick water tracking)
-- ---------------------------------------------
CREATE TABLE IF NOT EXISTS water_log (
    water_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    date DATE NOT NULL DEFAULT (CURRENT_DATE),
    glasses INT NOT NULL DEFAULT 0,
    goal INT NOT NULL DEFAULT 8,
    UNIQUE KEY unique_user_date (user_id, date),
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- ---------------------------------------------
-- Indexes for performance
-- ---------------------------------------------
CREATE INDEX idx_period_user ON period_tracker(user_id);
CREATE INDEX idx_symptoms_user ON symptoms(user_id);
CREATE INDEX idx_pcod_user ON pcod_tracker(user_id);
CREATE INDEX idx_reminders_user ON reminders(user_id);
CREATE INDEX idx_food_user ON food_tracker(user_id);
CREATE INDEX idx_water_user ON water_log(user_id);
