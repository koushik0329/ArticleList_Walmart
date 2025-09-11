

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
- **🏗️ Clean Architecture**: Protocol-oriented programming with MVVM pattern

## 🛠️ Technical Architecture

### Design Patterns
- **MVVM (Model-View-ViewModel)**: Clean separation of concerns
- **Protocol-Oriented Programming**: Dependency injection and testability
- **Delegation Pattern**: Communication between view controllers
- **Singleton Pattern**: NetworkManager for API calls

### Project Structure
```
ArticleList_Walmart/
├── 📁 Common/
│   └── Constant.swift
├── 📁 Controller/
│   ├── ArticleViewController.swift
│   └── DetailsViewController.swift
├── 📁 Model/
│   └── Article.swift
├── 📁 Network/
│   ├── NetworkManager.swift
│   └── MockNetworkManager.swift
├── 📁 View/
│   └── Storyboard/
├── 📁 TableCell/
│   └── ArticleTableViewCell.swift
├── 📁 ViewModel/
│   ├── ArticleViewModel.swift
│   └── AppDelegate.swift
└── 📁 Tests/
    ├── ArticleList_WalmartTests/
    └── ArticleList_WalmartUITests/
```

## 🔧 Key Components

### NetworkManager (Protocol-Based)
```swift
protocol Network {
    func getData(from serverUrl: String, closure: @escaping (Data?) -> Void)
    func parse(data: Data?) -> ArticleList?
}

struct NetworkManager: Network {
    static let shared = NetworkManager()
    // Implementation
}
```

### ArticleViewModel (Protocol-Based)
```swift
protocol ArticleViewModelProtocol {
    func getDataFromServer(closure: @escaping (() -> Void))
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
- Xcode 15.0+
- iOS 18.6+
- Swift 5.0+

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
   - Select your target device/simulator
   - Press `Cmd + R` to build and run

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
- Real-time search as you type
- Searches both author names and article descriptions
- Case-insensitive matching
- Clear search to return to full article list

## 🧪 Testing

The project includes comprehensive testing suites:

### Unit Tests
```bash
# Run unit tests
cmd + u
```

### UI Tests
- Automated UI testing for critical user flows
- Screen navigation testing
- Search functionality validation

### Mock Objects
- `MockNetworkManager` for testing network calls
- `MockArticleViewModel` for view controller testing

## 🏗️ Architecture Benefits

### Protocol-Oriented Programming
- **Testability**: Easy dependency injection with protocol mocks
- **Flexibility**: Swap implementations without changing dependent code
- **Modularity**: Clean separation between components

### MVVM Pattern
- **Separation of Concerns**: Clear distinction between UI and business logic
- **Testability**: ViewModels can be unit tested independently
- **Reusability**: ViewModels can be used across different views

## 🔄 Data Flow

1. **Network Layer**: Fetches data from API using `NetworkManager`
2. **Model Layer**: Parses JSON into `Article` structs
3. **ViewModel Layer**: Processes data and manages state
4. **View Layer**: Displays data and handles user interactions

## 📱 UI Components

### ArticleTableViewCell
- Custom table view cell with image loading
- Author, description, and publication date display
- Share icon and proper constraint layout

### DetailsViewController
- Editable author field
- Comment input field
- Image display with fallback support
- Save/Cancel navigation buttons


---

⭐ **Star this repository if you found it helpful!**
