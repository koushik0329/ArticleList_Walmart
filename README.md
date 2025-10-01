
````markdown
# 📰 ArticleList Walmart

A modern iOS news application built with **Swift** and **UIKit**, showcasing **Clean Architecture** and **Protocol-Oriented Programming**.  
This project demonstrates working with APIs using a **generic `NetworkManager`**, data persistence via **UserDefaults**, and a smooth user experience with search and delete actions.  
The app is structured using **MVVMC (Model–View–ViewModel–Coordinator)** for clear separation of concerns and navigation management.

---

## 🚀 Features

- 🔹 **Login Screen**  
  - Simple login flow with user details stored in **UserDefaults**  
  - Users don’t need to log in every time  

- 🔹 **Articles List**  
  - Fetches news articles from a server endpoint using `NetworkManager`  
  - Supports **search functionality** with UISearchController  
  - Allows deleting articles with swipe actions  

- 🔹 **Networking**  
  - `NetworkManager` handles API calls and JSON parsing  
  - Uses **async/await** with `URLSession`  
  - Generic `parse` method for decoding `Decodable` models  

---

## 🏛 Architecture – MVVMC

This project follows the **MVVMC (Model–View–ViewModel–Coordinator)** pattern:  

- **Model** → Defines the data and business logic.  
- **View** → Handles only UI and rendering.  
- **ViewModel** → Exposes data/state to the view and communicates with the model.  
- **Coordinator** → Manages navigation flow, ensuring view controllers remain lightweight and independent.  

👉 This structure makes the app **modular, testable, and scalable**, ideal for real-world production apps.  

---

## 📡 Network Layer

```swift
protocol NetworkManagerProtocol {
    func getData(from serverUrl: String) async -> NetworkState
    func parse<T: Decodable>(data: Data?, type: T.Type) -> T?
}

class NetworkManager: NetworkManagerProtocol {
    static let shared = NetworkManager()
    
    func getData(from serverUrl: String) async -> NetworkState {
        guard let serverURL = URL(string: serverUrl) else { return .invalidURL }
        do {
            let (data, _) = try await URLSession.shared.data(from: serverURL)
            return .success(data)
        } catch {
            return .errorFetchingData
        }
    }

    func parse<T: Decodable>(data: Data?, type: T.Type) -> T? {
        guard let data = data else { return nil }
        return try? JSONDecoder().decode(T.self, from: data)
    }
}
````

---

## 🛠 Tech Stack

* **iOS 18.6+**
* **Swift 5.0+**
* **UIKit**
* **MVVMC Architecture**
* **Protocol-Oriented Programming**
* **Clean Architecture**
* **Async/Await Networking**
* **UserDefaults for persistence**

---

## 📸 Screenshots

**Login Screen** <img width="432" height="853" alt="image" src="https://github.com/user-attachments/assets/8cdbbc73-4d11-4cce-8623-992c347c405a" />

**Articles List** <img width="410" height="846" alt="image" src="https://github.com/user-attachments/assets/1d73cd56-620a-48fd-9db9-39280ff30fe8" />


