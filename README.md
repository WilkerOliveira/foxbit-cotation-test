# FoxBit Cotation Test 🚀

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter">
  <img src="https://img.shields.io/badge/WebSocket-02569B?style=for-the-badge&logo=websocket&logoColor=white" alt="WebSocket">
</p>

A real-time cryptocurrency listing application built with Flutter, leveraging WebSockets to provide up-to-the-minute price updates.

<div align="center">
<img src="https://github.com/user-attachments/assets/94cad56d-4366-41db-8cc7-d8a6a8fa0bb7" alt="Screenshot_1748628935" style="width: 25%;">
</div>
---

## 🛠️ Technologies & Packages

This project utilizes the following key technologies and external packages:

* **`web_socket_channel`**: For establishing and managing WebSocket connections to receive real-time data.
* **`bloc` & `flutter_bloc`**: A highly popular and effective state management solution for Flutter applications, ensuring maintainable and testable code.
* **`rxdart`**: A reactive programming library for Dart, enhancing asynchronous data streams.
* **`currency_formatter`**: For elegant and consistent display of currency values.
* **`equatable`**: Simplifies value equality comparisons in Dart.
* **`get_it`**: A simple service locator for Dart and Flutter, useful for dependency injection.
* **`result_dart`**: A functional programming concept for handling success and failure states more explicitly.

---

## 🧪 Testing

This project includes a comprehensive test suite to ensure reliability and maintainability.

* **`bloc_test`**: For testing BLoCs and Cubits.
* **`mocktail`**: A mocking library for Dart, used for creating test doubles.
* **`coverage`**: To generate code coverage reports.

To run the tests:

```bash
flutter test --coverage
