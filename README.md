# Rick and Morty Character Viewer

![Rick and Morty Banner](https://rickandmortyapi.com/api/character/avatar/1.jpeg)

## Table of Contents
1. [Project Overview](#project-overview)
2. [Architecture](#architecture)
3. [Modules](#modules)
4. [Key Features](#key-features)
5. [Assumptions and Challenges](#assumptions-and-challenges)
6. [Getting Started](#getting-started)
7. [Development](#development)
8. [Testing](#testing)
9. [Dependency Management](#dependency-management)
10. [Performance Considerations](#performance-considerations)
11. [Future Improvements](#future-improvements)


## Project Overview

The Rick and Morty Character Viewer is an iOS application that showcases characters from the popular animated series "Rick and Morty". It utilizes the [Rick and Morty API](https://rickandmortyapi.com/) to fetch and display character information in a user-friendly interface.

### High-Level Architecture Diagram

```mermaid
graph TD
    A[Presentation Layer] --> B[Business Layer]
    B --> C[Data Repository Layer]
    C --> D[Networking Layer]
    D --> E[Rick and Morty API]
```

## Architecture

The project follows Clean Architecture principles, utilizing the MVVM-C (Model-View-ViewModel-Coordinator) pattern in the presentation layer. It's designed with modularity in mind, separating concerns into distinct layers:

1. **Presentation Layer (RickCompanion)**: Implements the user interface and handles user interactions.
2. **Domain Layer (BusinessLayer)**: Contains the core business logic and use cases.
3. **Data Layer (DataRepository)**: Abstracts the data sources and provides a clean API for the domain layer.
4. **Networking Layer (APIGate)**: Handles all network communications.
5. **Common**: Provides shared utilities and extensions used across the application.

## Modules

### 1. APIGate
- Responsible for network communication
- Implements `URLSessionNetworking`
- Defines network protocols and endpoints
- Handles network errors

### 2. DataRepository
- Abstracts data sources
- Implements `CharacterRepository`
- Defines Data Transfer Objects (DTOs)
- Handles data-related errors

### 3. BusinessLayer
- Implements use cases (e.g., `FetchCharactersUseCase`)
- Defines business logic and rules
- Handles business-related errors

### 4. RickCompanion (Main App)
- Implements the MVVM-C pattern
- Contains scenes for character list and details
- Implements coordinators for navigation
- Defines ViewModels and ViewControllers

### 5. Common
- Provides shared utilities (e.g., image loading and caching)
- Implements common UI components
- Contains extensions and helper functions

## Key Features
- Paginated list of Rick and Morty characters
- Character filtering by status (Alive, Dead, Unknown)
- Detailed view for each character
- Asynchronous image loading with caching
- Dark mode support

## Assumptions and Challenges

### Assumptions
- The project assumes that most views should be implemented in SwiftUI, with the exception of the main character list, which uses a UITableView for performance reasons.
- The app is designed to work with iOS 16.0 and above, taking advantage of the latest SwiftUI features and improvements.

### Challenges
- **Image Loading in TableView Cells**: We encountered a challenge with image loading in the character list. When scrolling quickly, images were sometimes loaded into the wrong cells. This was resolved by adding a unique identifier to each SwiftUI CharacterCellView, as SwiftUI doesn't inherently know it's being used within a UITableViewCell.

### Architectural Decisions
- **Interface-Driven Communication**: All modules in the app communicate with each other through interfaces (protocols). This design decision enhances the app's scalability, testability, and allows for easier future modifications. It also enables mock implementations for testing and the potential for alternative implementations without affecting the rest of the system.

- **Dependency Injection**: We use dependency injection containers in each module to manage the creation and lifetime of objects. This approach improves testability and allows for easier swapping of implementations.

- **MVVM-C with Clean Architecture**: The app follows MVVM-C (Model-View-ViewModel-Coordinator) pattern within a Clean Architecture structure. This separation of concerns allows for better testability and maintainability.

## Getting Started

### Prerequisites
- Xcode 13.0+
- iOS 16.0+
- Swift 5.5+

### Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/rick-and-morty-viewer.git
   ```
2. Open `RickCompanion.xcodeproj` in Xcode.
3. Build and run the project on your simulator or device.

## Development

### Project Structure
```
RickCompanion/
├── APIGate/
│   ├── NetworkLayer/
│   ├── Protocols/
│   └── Utilites/
├── DataRepository/
│   ├── Repositories/
│   ├── DTOs/
│   └── Endpoints/
├── BusinessLayer/
│   └── UseCases/
├── RickCompanion/
│   ├── Presentation/
│   │   ├── Scenes/
│   │   ├── Common/
│   │   └── Coordinator/
│   └── App/
└── Common/
    ├── Utilities/
    └── Extensions/
```

### Adding a New Feature
1. Determine which module(s) will be affected.
2. Implement necessary data structures in DataRepository if required.
3. Add business logic in BusinessLayer if needed.
4. Implement the UI in the RickCompanion module.
5. Update coordinators if the feature requires navigation changes.
6. Update Dependency Injection Containers to create new instance.
7. Add appropriate unit tests for all new components.

### Best Practices
- Use protocols for inter-module communication to maintain loose coupling.
- Implement dependency injection for better testability and flexibility.
- Keep UI components as dumb as possible, with business logic residing in ViewModels and Use Cases.
- Use Coordinators for navigation logic to keep ViewControllers and SwiftUI Views focused on their primary responsibilities.

## Testing

Each module has its own test target. To run tests:

1. Select the desired scheme (e.g., `APIGateTests`, `DataRepositoryTests`, etc.)
2. Press `Cmd+U` or navigate to Product > Test

Ensure that you maintain high test coverage, especially for business logic and data handling.

## Dependency Management

The project uses Swift Package Manager for dependency management. To add a new dependency:

1. In Xcode, go to File > Swift Packages > Add Package Dependency
2. Enter the repository URL and follow the prompts

## Performance Considerations

- Implement efficient image caching to reduce network requests
- Use pagination for character list to optimize memory usage
- Implement proper error handling and retry mechanisms for network requests
- Optimize UI for smooth scrolling and responsive user interactions

## Future Improvements

- Implement search functionality for characters
- Add favorite character feature with local storage
- Introduce episode list and details
- Implement UI State Restoration
- Add localization for multiple languages
- Enhance accessibility features


---

For any questions or support, please open an issue in the GitHub repository or contact the maintainers directly.
