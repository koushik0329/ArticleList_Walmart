
# ArticleList Walmart

A modern iOS news application built with Swift and UIKit, showcasing clean architecture principles and protocol-oriented programming.

![iOS](https://img.shields.io/badge/iOS-18.6+-blue.svg)
![Swift](https://img.shields.io/badge/Swift-5.0+-orange.svg)
![Xcode](https://img.shields.io/badge/Xcode-15.0+-blue.svg)
![License](https://img.shields.io/badge/License-MIT-green.svg)

## 📱 Screenshots

<img width="389" height="834" alt="image" src="https://github.com/user-attachments/assets/b29c6aed-32e9-4c7e-8282-04bfa05f01fc" />

*News articles displayed with search functionality and detailed views*

## ✨ Features

- **📰 News Article Feed**: Browse through a curated list of news articles
- **🔍 Real-time Search**: Search articles by author or description
- **📖 Detailed Article View**: View full article details with images
- **✏️ Edit Functionality**: Modify author names and add comments
- **🖼️ Image Loading**: Asynchronous image loading with fallback support
- **📱 Responsive UI**: Optimized for various iOS device sizes
- **🏗️ Clean Architecture**: Protocol-oriented programming with MVVMC pattern

## 🛠️ Technical Architecture

### Design Patterns
- **MVVMC (Model-View-ViewModel-Coordinator)**: Clean separation of concerns with navigation handled by Coordinators
- **Protocol-Oriented Programming**: Dependency injection and testability
- **Delegation Pattern**: Communication between view controllers
- **Singleton Pattern**: ServiceManager for API calls

### ServiceManager (Generic + Async/Await)
```swift
import Foundation

protocol ServiceManagerProtocol {
    func getData<T: Decodable>(from serverUrl: String, type: T.Type) async throws -> T
}

class ServiceManager: ServiceManagerProtocol {
    static let shared = ServiceManager()

    func getData<T: Decodable>(from serverUrl: String, type: T.Type) async throws -> T {
        guard let serverURL = URL(string: serverUrl) else {
            throw ServiceError.networkState(.invalidURL)
        }

        let (data, response) = try await URLSession.shared.data(from: serverURL)

        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw ServiceError.networkState(.invalidResponse(statusCode: (response as? HTTPURLResponse)?.statusCode ?? -1))
        }

        return try JSONDecoder().decode(T.self, from: data)
    }
}
````

### ArticleViewModel (Protocol-Based)

```swift
protocol ArticleViewModelProtocol {
    func getDataFromServer() async
    func getArticleCount() -> Int
    func getArticle(at index: Int) -> Article?
    func searchArticles(with: String)
    func resetSearch()
    func updateArticle(at index: Int, with updatedArticle: Article)
}
```

### Article Model

```swift
struct Article: Decodable {
    var author: String?
    var comment: String
    let description: String?
    let urlToImage: String?
    let publishedAt: String?
    
    var publishedDateOnly: String {
        // Date formatting logic
    }
}
```

## 🚀 Getting Started

### Prerequisites

* Xcode 15.0+
* iOS 18.6+
* Swift 5.0+

### Installation

1. **Clone the repository**

   ```bash
   git clone https://github.com/yourusername/ArticleList_Walmart.git
   cd ArticleList_Walmart
   ```

2. **Open in Xcode**

   ```bash
   open ArticleList_Walmart.xcodeproj
   ```

3. **Build and Run**

   * Select your target device/simulator
   * Press `Cmd + R` to build and run

### Configuration

Update the API endpoint in `Constant.swift`:

```swift
enum Server: String {
    case endPoint = "https://your-news-api-endpoint.com/articles"
}
```

## 📋 Usage

### Basic Operations

1. **View Articles**: Launch the app to see the latest news articles
2. **Search**: Use the search bar to filter articles by author or description
3. **View Details**: Tap on any article to view full details
4. **Edit Article**: Modify author name or add comments in the detail view
5. **Save Changes**: Use the save button to persist your modifications

### Search Functionality

* Real-time search as you type
* Searches both author names and article descriptions
* Case-insensitive matching
* Clear search to return to full article list

## 🧪 Testing

The project includes comprehensive testing suites:

### Unit Tests

```bash
# Run unit tests
cmd + u
```

### UI Tests

* Automated UI testing for critical user flows
* Screen navigation testing
* Search functionality validation

### Mock Objects

* `MockServiceManager` for testing network calls
* `MockArticleViewModel` for view controller testing

## 🏗️ Architecture Benefits

### Protocol-Oriented Programming

* **Testability**: Easy dependency injection with protocol mocks
* **Flexibility**: Swap implementations without changing dependent code
* **Modularity**: Clean separation between components

### MVVMC Pattern

* **Separation of Concerns**: Clear distinction between UI, navigation, and business logic
* **Testability**: ViewModels can be unit tested independently
* **Reusability**: Coordinators and ViewModels can be reused across different flows

## 🔄 Data Flow

1. **Service Manager**: Fetches data from API using async/await
2. **Model Layer**: Parses JSON into `Article` structs
3. **ViewModel Layer**: Processes data and manages state
4. **Coordinator Layer**: Handles navigation between screens
5. **View Layer**: Displays data and handles user interactions

## 📱 UI Components

### ArticleTableViewCell

* Custom table view cell with image loading
* Author, description, and publication date display
* Share icon and proper constraint layout

### DetailsViewController

* Editable author field
* Comment input field
* Image display with fallback support
* Save/Cancel navigation buttons

---

⭐ **Star this repository if you found it helpful!**

```

---

Do you also want me to **add a code snippet for using `ServiceManager` inside your `ArticleViewModel`** (with `async/await`)? That would make the README more complete for future readers.
```
