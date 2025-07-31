# Flutter Clean Architecture Template

A robust and scalable Flutter project template built on the principles of Clean Architecture. This project provides a solid foundation for building maintainable, testable, and high-quality applications.

## Overview

This template is designed to separate concerns effectively by dividing the application into distinct layers: **Presentation**, **Domain**, and **Data**. It includes a pre-configured, feature-rich networking layer and uses the Provider pattern for state management.

## Key Features

-   🏛️ **Clean Architecture:** Enforces a clear separation of concerns, making the codebase easy to understand, scale, and maintain.
-   🌐 **Advanced Networking Layer:** A powerful and isolated networking module built with `dio`, featuring:
    -   **Request Retries:** Automatically retries failed requests.
    -   **Connectivity Checks:** Ensures an active internet connection.
    -   **Authentication Handling:** Interceptor for injecting API tokens.
    -   **Centralized Error Handling:** Gracefully manages network and API errors.
    -   **Logging:** Detailed request and response logging for debugging.
-   🔄 **State Management:** Utilizes `provider` for efficient and predictable state management.
-   📁 **Structured Project Layout:** A logical directory structure that keeps your code organized.
-   🧪 **Testability:** The architecture makes it easy to write unit and widget tests for every part of the application.

## Project Structure

The `lib` directory is organized into the following layers:

```
lib
├── model/              # Data models (e.g., Album)
├── network/            # Networking layer (Dio, interceptors, error handling)
├── presentation/       # UI layer (Widgets and screens)
├── providers/          # State management (ChangeNotifiers)
└── repositories/       # Abstract contracts for data sources
```

## Core Dependencies

-   [**dio**](https://pub.dev/packages/dio): A powerful HTTP client for Dart, which supports interceptors, global configuration, FormData, request cancellation, file downloading, timeout, etc.
-   [**provider**](https://pub.dev/packages/provider): A state management library that is easy to understand and use.

I've built a networking module that is completely isolated and packed with features to handle real-world scenarios gracefully. The goal is to make network requests reliable and easy to manage.

To get a local copy up and running, follow these simple steps.

### Prerequisites

-   [Flutter SDK](https://flutter.dev/docs/get-started/install)

### Installation

1.  **Clone the repo**
    ```sh
    git clone https://github.com/your_username/flutter_clean_architect.git
    ```
2.  **Navigate to the project directory**
    ```sh
    cd flutter_clean_architect
    ```
3.  **Install dependencies**
    ```sh
    flutter pub get
    ```
4.  **Run the app**
    ```sh
    flutter run
    ```
