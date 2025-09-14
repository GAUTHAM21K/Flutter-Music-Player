# Flutter Music Player

Nexotech Player is a feature-rich music player built using Flutter. It provides a seamless and visually appealing experience for users to browse, play, and manage their music playlists. The app is designed with a clean architecture to ensure scalability and maintainability.

---

## Table of Contents

- [Features](#features)
- [Architecture](#architecture)
- [Packages Used](#packages-used)
- [Folder Structure](#folder-structure)
- [Getting Started](#getting-started)
- [Contributing](#contributing)
- [License](#license)

---

## Features

- **Playlist Management**: Browse and play songs from a playlist.
- **Mini Player**: A compact player at the bottom of the screen for quick access.
- **Full Player Screen**: A detailed player screen with controls and progress bar.
- **Dynamic Navigation**: Bottom navigation bar with dynamic icons and labels.
- **Offline Support**: Caches songs locally for instant access.
- **Responsive Design**: Adapts to different screen sizes using `flutter_screenutil`.

---

## Architecture

The project follows a **clean architecture** pattern, separating concerns into distinct layers:

1. **Presentation Layer**:
   - Contains UI components such as screens and widgets.
   - Uses `flutter_riverpod` for state management.

2. **Domain Layer**:
   - Includes business logic and providers.
   - Providers manage the state of the app, such as the mini player visibility and the currently playing song.

3. **Data Layer**:
   - Handles data storage and retrieval.
   - Uses `Hive` for local storage and `dio` for network requests.

4. **Service Layer**:
   - Contains services like `SongService` for interacting with APIs or data sources.

This architecture ensures that the app is modular, testable, and easy to maintain.

---

## Packages Used

The following packages are used to enhance the functionality of the app:

- **[flutter_riverpod](https://pub.dev/packages/flutter_riverpod)**: For state management.
- **[just_audio](https://pub.dev/packages/just_audio)**: For audio playback.
- **[audio_service](https://pub.dev/packages/audio_service)**: For background audio playback.
- **[hive](https://pub.dev/packages/hive)**: For local storage.
- **[hive_flutter](https://pub.dev/packages/hive_flutter)**: For integrating Hive with Flutter.
- **[dio](https://pub.dev/packages/dio)**: For making HTTP requests.
- **[flutter_screenutil](https://pub.dev/packages/flutter_screenutil)**: For responsive design.
- **[google_fonts](https://pub.dev/packages/google_fonts)**: For custom fonts.
- **[cached_network_image](https://pub.dev/packages/cached_network_image)**: For efficient image loading and caching.
- **[flutter_svg](https://pub.dev/packages/flutter_svg)**: For rendering SVG assets.

---

## Folder Structure

The project is organized as follows:

lib/
├── main.dart                  # Entry point of the app

├── models/                    # Data models
│   ├── song_model.dart
│   └── song_model.g.dart

├── providers/                 # State management providers
│   ├── mini_player_provider.dart
│   ├── player_provider.dart
│   └── songs_provider.dart

├── repositories/              # Data repositories
│   └── song_repository.dart

├── screens/                   # UI screens
│   ├── mini_player.dart
│   ├── player_screen.dart
│   └── playlist_screen.dart

├── services/                  # Services for data handling
│   └── song_service.dart

└── widgets/                   # Reusable UI components
    ├── player_controls.dart
    ├── progress_bar.dart
    └── song_tile.dart



---

## Getting Started

### Prerequisites

- Flutter SDK (>=3.0.0)
- Dart SDK (>=3.0.0)

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/nexotech_player.git
