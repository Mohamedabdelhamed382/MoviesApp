# MoviesApp
SwiftUI Movies App using TMDB API with pagination, offline support, Core Data, Combine, and clean architecture.

The project focuses on clean architecture, modularization, and high-quality, testable code.

✨ Features

🟣 Trending Movies List

Displays a list of trending movies.
Supports pagination

Each movie item shows:
Title / Poster image / Release year / Local search to filter movies by title / Genre filter chips (local filtering)
If no genre is selected, all movies are displayed
Works in online and offline modes

🟣 Movie Details

When selecting a movie, the details screen shows:
Title / Poster image / Release year & month / Genres / Overview / Homepage / Budget / Revenue / Spoken languages / Status / Runtime

🏗 Architecture

The app follows MVVM with a layered approach inspired by Clean Architecture:

This approach keeps the UI lightweight while moving business logic to testable layers.

View (SwiftUI)
 ↓
ViewModel
 ↓
UseCase
 ↓
Repository
 ↓
Data Sources (Remote / Local)

Modules:

MoviesApp
│
├── App
├── Core        (Networking, Persistence, Utilities)
├── Domain      (Models, UseCases, Repository Protocols)
├── Data        (DTOs, Repositories, Data Sources)
├── Features
│   ├── MoviesList
│   └── MovieDetails
└── Tests

This structure ensures:

Clear separation of concerns
High testability
Scalability

💾 Offline Support

Uses Core Data for local persistence
Implements a Remote-First strategy
API responses are cached locally
Falls back to local data when the device is offline

🌐 APIs Used (TMDB)

Genres List
/genre/movie/list

Discover / Trending Movies
/discover/movie

Movie Details
/movie/{movie_id}

Images
According to the TMDB image configuration

📌 TMDB Documentation:
https://developer.themoviedb.org

🧪 Testing

Unit Tests implemented using XCTest

ViewModels are tested with mocked repositories

Core Data tested using an in-memory store

🛠 Technologies

SwiftUI

Combine

Core Data

XCTest

Modular Architecture

Git (Clean commit history)

🔐 Setup

Clone the repository

Add your TMDB API Key

Build & run the project

🧾 Git & Code Quality

The project follows a clean and meaningful commit history

Each commit represents a logical step in development

Code readability and maintainability are top priorities

👨‍💻 Author

Mohamed Abdelhamed
iOS Developer

🎯 Notes for Reviewers

Even if some features are not fully completed, the focus of this project is on:

Architecture

Code quality

Clear data flow

Best practices

