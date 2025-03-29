<!-- <p align="center"><a href="https://laravel.com" target="_blank"><img src="https://raw.githubusercontent.com/laravel/art/master/logo-lockup/5%20SVG/2%20CMYK/1%20Full%20Color/laravel-logolockup-cmyk-red.svg" width="400" alt="Laravel Logo"></a></p>

<p align="center">
<a href="https://github.com/laravel/framework/actions"><img src="https://github.com/laravel/framework/workflows/tests/badge.svg" alt="Build Status"></a>
<a href="https://packagist.org/packages/laravel/framework"><img src="https://img.shields.io/packagist/dt/laravel/framework" alt="Total Downloads"></a>
<a href="https://packagist.org/packages/laravel/framework"><img src="https://img.shields.io/packagist/v/laravel/framework" alt="Latest Stable Version"></a>
<a href="https://packagist.org/packages/laravel/framework"><img src="https://img.shields.io/packagist/l/laravel/framework" alt="License"></a>
</p>
 -->

# 🚗 Fuel Station Monitoring System ⛽

## 📌 Overview
This is a **Fuel Station Monitoring System** developed by **Tharindu Chathuranga**. The system helps track vehicle refueling, register vehicles, and send SMS notifications via **Notify.lk**. It includes an **Android app for pump operators** to scan QR codes and log refueling details.

## ✨ Features
- ✅ Vehicle registration with **QR code generation**
- ✅ **SMS notifications** for vehicle registration and refueling
- ✅ **Monthly refueling summary** per vehicle
- ✅ **Android app for pump operators**
- ✅ **Database storage without foreign keys**
- ✅ **Simple and secure API integration**

## 🛠 Tech Stack
- **Backend**: PHP (Laravel)
- **Database**: MySQL
- **QR Code**: `endroid/qr-code`
- **SMS API**: Notify.lk
- **Android App**: Java/Kotlin

---

## 🚀 Installation Guide

### 📌 1. Clone the Repository
```bash
git clone https://github.com/tharinduchathuranga98/Fuel_Station_Discount_Tracker_backend.git
```
Navigate into the project directory:
```bash
cd Fuel_Station_Discount_Tracker_backend
```

### 📌 2. Install Dependencies
```bash
composer install
```

### 📌 3. Configure Environment
Copy the `.env.example` file to `.env`:
```bash
cp .env.example .env
```
Edit the `.env` file and configure your database:
```ini
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=fuel_station
DB_USERNAME=root
DB_PASSWORD=

SMS_USER_ID=SMS_USER_ID
SMS_API_KEY=SMS_API_KEY
SMS_SENDER_ID=SMS_SENDER_ID
```

### 📌 4. Generate App Key
```bash
php artisan key:generate
```

### 📌 5. Run Migrations
```bash
php artisan migrate
```

### 📌 6. Start the Server
```bash
php artisan serve
```
The API will be available at `http://127.0.0.1:8000`.

---

## 📡 API Endpoints

### 🚗 Vehicle Registration
**Endpoint:** `/api/register-vehicle`  
**Method:** `POST`  
**Description:** Registers a new vehicle and generates a QR code.

**Request Body:**
```json
{
  "number_plate": "BCC-1234",
  "owner_name": "John Doe",
  "owner_phone": "94761234567"
}
```

**Response:**
```json
{
  "message": "Vehicle registered successfully",
  "vehicle": {
    "number_plate": "BCC-1234",
    "owner_name": "John Doe",
    "owner_phone": "94761234567",
    "qr_code": "iVBORw0..."
  },
  "qr_code_url": "http://127.0.0.1:8000/storage/qrcodes/BCC-1234.png"
}
```

---

### ⛽ Refueling Log & SMS Notification
**Endpoint:** `/api/refuel`  
**Method:** `POST`  
**Description:** Logs a refueling record and sends an SMS notification.

**Request Body:**
```json
{
  "number_plate": "BCC-1234",
  "liters": 20
}
```

**Response:**
```json
{
  "message": "Refueling record saved successfully and SMS sent"
}
```

---

### 📊 Monthly Refueling Summary
**Endpoint:** `/api/monthly-summary/{number_plate}`  
**Method:** `GET`  
**Description:** Fetches the total refueling for the current month for a specific vehicle.

**Response:**
```json
{
  "number_plate": "BCC-1234",
  "total_liters": 120
}
```

---

## 📞 SMS Integration (Notify.lk)
We use **Notify.lk** to send SMS alerts when:
1. A **vehicle is registered**.
2. A **vehicle is refueled**.

### ✅ API Request Format:
```json
{
    "user_id": "user_id",
    "api_key": "api_key",
    "sender_id": "sender_id",
    "to": "94761234567",
    "message": "Your vehicle BCC-1234 has been refueled with 20 liters."
}
```
---

## 📄 Database Structure

### Vehicles Table (`vehicles`)
| Column        | Type       | Description                        |
|--------------|-----------|------------------------------------|
| id           | INT       | Primary Key                        |
| number_plate | STRING    | Vehicle number plate (Unique)     |
| owner_name   | STRING    | Owner's full name                 |
| owner_phone  | STRING    | Owner's phone number              |
| qr_code      | TEXT      | QR code (Base64 encoded)          |
| created_at   | TIMESTAMP | Timestamp when registered         |
| updated_at   | TIMESTAMP | Timestamp when updated            |

---

### Refueling Records Table (`refueling_records`)
| Column        | Type       | Description                        |
|--------------|-----------|------------------------------------|
| id           | INT       | Primary Key                        |
| number_plate | STRING    | Vehicle number plate              |
| liters       | INT       | Amount of fuel refilled (liters)  |
| refueled_at  | TIMESTAMP | Timestamp of refueling            |
| created_at   | TIMESTAMP | Timestamp when recorded           |

---

## 📧 Contact  
Developed by **Tharindu Chathuranga**  
📧 Email: tchathurangaedu@gmail.com  
🔗 GitHub: [tharinduchathuranga98](https://github.com/tharinduchathuranga98)  

---

⭐ **If you found this project helpful, please give it a star!** ⭐
