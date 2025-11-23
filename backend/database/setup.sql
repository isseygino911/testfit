-- TestFit Database Setup Script
-- Run this script to create the database and tables

-- Create database if not exists
CREATE DATABASE IF NOT EXISTS testfit_db;

-- Use the database
USE testfit_db;

-- Create users table
CREATE TABLE IF NOT EXISTS users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  email VARCHAR(255) NOT NULL UNIQUE,
  password VARCHAR(255) NOT NULL,
  full_name VARCHAR(255) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_email (email)
);

-- You can run this script using:
-- mysql -u root -p < setup.sql
