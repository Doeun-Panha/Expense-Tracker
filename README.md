# 💸 Expense Tracker

A sleek, intuitive, and feature-rich Flutter application designed to help you track your personal finances with ease. Monitor your spending habits, manage categories, and visualize your financial health through interactive charts—all with secure, offline local storage.

---

## ✨ Key Features

- **📊 Visual Analytics**: Interactive pie charts to visualize spending distribution across different categories.
- **💰 Real-time Balance**: Instantly see your total balance, income, and expenses on a clean dashboard.
- **📂 Categorized Transactions**: Organize your spending with predefined categories like Food, Transport, Entertainment, and more.
- **🕒 Transaction History**: A comprehensive, scrollable list of all your past activities.
- **💾 Offline First**: Uses **SQLite** (via `sqflite`) for reliable, secure local data storage.
- **📱 Modern UI**: Built with Google Fonts and a polished Material Design theme for a premium user experience.

---

## 🛠️ Tech Stack

- **Framework**: [Flutter](https://flutter.dev/) (v3.10.0+)
- **Language**: [Dart](https://dart.dev/)
- **State Management**: [Provider](https://pub.dev/packages/provider)
- **Local Database**: [SQFlite](https://pub.dev/packages/sqflite)
- **Data Visualization**: [FL Chart](https://pub.dev/packages/fl_chart)
- **Theming**: Custom App Theme with [Google Fonts](https://pub.dev/packages/google_fonts)

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (ensure `flutter doctor` passes)
- An IDE (VS Code, Android Studio, etc.)

### Installation

1. **Clone the repository**:
   ```bash
   git clone https://github.com/your-username/expense-tracker.git
   cd expense-tracker
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run the app**:
   ```bash
   flutter run
   ```

---

## 📁 Project Structure

```text
lib/
├── models/         # Data structures and category definitions
├── providers/      # Business logic and state management
├── screens/        # Main UI pages (Dashboard, Transactions, etc.)
├── utils/          # App constants and theme definitions
├── widgets/        # Reusable UI components and charts
└── main.dart       # App entry point and navigation setup
```

---

## 📄 License

This project is open-source and available under the [MIT License](LICENSE).
