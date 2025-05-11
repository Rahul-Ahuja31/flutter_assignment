# Flutter Article App

A simple Flutter app that fetches and displays articles from a public API. Users can search, view details, and manage favorite articles.

## Key Features

- **Article Listing**: Fetches articles from `https://jsonplaceholder.typicode.com/posts` and displays them in a clean list view.
- **Search**: Client-side search allows filtering articles by title without calling the API again.
- **Post Details**: Tapping an article opens a detail screen showing the full title and body.
- **Favorites**: Users can add or remove articles from favorites. Favorite posts are saved using secure local storage.
- **Favourite Post**: Tapping an start icon open a favourite posts screen showing the all user favourite posts.
- **Pull-to-Refresh**: Users can pull down on the list to manually refresh and reload articles from the API.
- **Graceful Error Handling**: Displays user-friendly error messages if API requests fail.~~~~

## Tech Stack

- **Flutter SDK**: 3.16.5
- **Dart Version** :3.2.3
- **State Management**: GetX
- **HTTP Client**: http
- **Local Storage**: secure_preference_storage

## Why These Technologies?

- **HTTP**:  
  We used the `http` package to perform REST API calls efficiently. It's lightweight, easy to integrate, and well-suited for fetching JSON data from the provided public API.

- **SecurePreferenceStorage**:  
  This package is used to persist user favorites securely on the device. It ensures that favorite articles are saved even after the app is closed and protects user data from being easily tampered with.

- **GetX (State Management)**:  
  GetX offers a simple and reactive state management approach. It allows us to manage UI updates, handle navigation, and organize logic using controllers without excessive boilerplate. This makes the app clean, modular, and easy to maintain.


## Project Architecture

The codebase follows a clean and modular architecture with separation of concerns between UI, data, and logic layers:

**lib/**  
├── **model/**    
│ └── **post_model.dart** # Data model for articles/posts  
├── **network**/  
│ ├── **api_manager.dart** # Handles actual HTTP requests  
│ └── **repository**/  
│ ├── **post_repository.dart** # Abstract class defining repository methods  
│ └── **post_repository_impl.dart** # Abstract method body implementation of the repository  
├── **share_preference**/  
│ └── **base_preference.dart** # Set of secure preference  
│ └── **post_preference.dart** # Manage user favourite posts   
├── **ui**/  
│ ├── **post_screen.dart** # Displays list of articles with search and refresh  
│ ├── **post_detail_screen.dart** # Displays full article details  
│ └── **favorite_post_screen.dart** # Displays user's favorite posts  
├── **widgets**/  
│ └── **post_card_view.dart** # Reusable UI widget for displaying post preview  
└── **main.dart** # App entry point and routing setup  
