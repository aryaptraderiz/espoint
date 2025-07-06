❄️ esPoint - Cold Beverage Sales Management App
📌 Overview
esPoint is a point-of-sale (POS) mobile application built using Flutter and powered by Firebase. It is designed to help small beverage businesses manage their products, ingredients (stock), transactions, and generate visual reports of their sales.

Whether you're running a juice stall, a cold drink shop, or a growing beverage business, esPoint makes it easy to track inventory, process transactions, and analyze performance in real-time.

✨ Features
🔐 User Authentication with Firebase (email & password)
🥤 Product Management: Add, edit, and delete cold beverage items
🧂 Ingredient (Stock) Management: Track and update raw materials
💳 Sales Transactions: Add new sales, auto-deduct ingredients from stock
📊 Sales Reports: Visualize daily/monthly revenue via charts
🔔 Notifications: Local notifications and optional WhatsApp integration
☁️ Cloud Sync: Real-time data syncing with Firebase Firestore
📱 Modern UI: Built with Flutter, responsive across Android devices
🚀 Getting Started
✅ Prerequisites
Ensure you have the following installed:

Flutter SDK
Android Studio or VS Code with Flutter extensions
A configured Firebase Project
🛠️ Installation
1. Clone the Repository
git clone https://github.com/aryaptraderiz/espoint.git
cd espoint
Install Dependencies flutter pub get

Firebase Setup Go to Firebase Console

Create a new project and register your Android app with the package name: com.example.espoint_flutter

Download the google-services.json file and place it in: /android/app/google-services.json

Enable Authentication (Email/Password) and Cloud Firestore

Generate firebase_options.dart using Firebase CLI or manual setup

Run the App flutter run
🗂️ Project Structure bash Salin Edit lib/ │ ├── models/ # Data models: Product, Ingredient, Transaction, etc. ├── providers/ # State management using Provider package ├── screens/ # UI screens: Login, Dashboard, Products, Transactions ├── services/ # Firebase integrations and helper services ├── widgets/ # Reusable custom UI widgets └── firebase_options.dart

🔐 Authentication Email & password login system via Firebase Auth

New users can register and will have their profiles stored in the users collection

🔄 Real-Time Data All changes to products, ingredients, and transactions are synced in real-time using Cloud Firestore

Offline caching is handled automatically by Firestore SDK

📈 Sales Reporting Integrated with fl_chart to visualize transaction data

Bar charts show revenue statistics by day, week, or month

🔔 Notifications Local notifications are implemented using flutter_local_notifications

WhatsApp notification feature can be added via webhook/API (optional)

🛠️ Technologies Used Flutter & Dart

Firebase Authentication

Firebase Cloud Firestore

Provider (State Management)

fl_chart (Data Visualization)

flutter_local_notifications (Local Alerts)

🤝 Contribution Contributions are welcome! Feel free to fork this repo and submit a pull request to improve UI, fix bugs, or add new features.

📄 License MIT License © 2025 Arya Putra Aderiz
