# bmdu_test

A Flutter e-commerce demo app showcasing a simple login flow, product browsing, search, and recent product history.

## Features

- Email/password login with validation and session persistence
- Product listing with remote product loading via `http`
- Search by product title or category
- Recent products tracked with `shared_preferences`
- Responsive Material 3 UI with light/dark theme support
- Provider-based state management

## Getting Started

### Prerequisites

- Flutter SDK installed
- Android Studio, Xcode, or other supported Flutter environment

### Run locally

1. Open the project in your editor:
   ```bash
   cd C:\Users\achyu\AndroidStudioProjects\bmdu_test
   flutter pub get
   flutter run
   ```

2. The app starts at `lib/main.dart` and shows a login screen if the user is not signed in.

## Project Structure

- `lib/main.dart` — app entry point and provider setup
- `lib/screens/` — UI screens for login, product list, and product details
- `lib/providers/` — auth and product state management
- `lib/services/` — API and local storage helpers
- `lib/models/` — product data model
- `lib/widgets/` — reusable UI components

## Dependencies

- `provider` — state management
- `http` — network requests
- `shared_preferences` — local session and recent product storage
- `shimmer` — loading placeholders

## Notes

- The app currently uses a mock login flow and a sample product API.
- Recent views are saved locally and restored on app restart.

## License

This repository is provided as-is for learning and demo purposes.
