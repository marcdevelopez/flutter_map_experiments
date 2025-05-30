# Flutter Map Experiments

This project is a personal practice with **Flutter** and the `flutter_map` package. The main features include:

- Displaying the user's current location on a map.
- Allowing the user to manually enter a destination (latitude and longitude).
- Drawing a route between point A (user) and point B (destination) using external routing services.
<br>  

## 🚀 Getting Started

1. **Clone the repository**
   
   ```bash
   git clone https://github.com/marcdevelopez/flutter_map_experiments.git
   cd flutter_map_experiments
   ```
2. **Get dependencies**
   
   ```bash
   flutter pub get
   ```
3. **Start your emulator or connect a physical device**
   - Android: Open Android Studio → Device Manager → Start emulator

   - iOS: Open Xcode → Simulator → Choose a device
4. **Run the app**
   
   ```bash
   flutter run
   ```
5. **(Optional) Open with your preferred IDE**
   - You can open the project in [VS Code](https://code.visualstudio.com/) or [Android Studio](https://developer.android.com/studio).
<br> 
📎 Make sure Flutter is installed and your environment is correctly set up:  

👉 [Flutter Setup Guide](https://docs.flutter.dev/get-started/install)

<br>  

## 📦 Dependency Management in Flutter

To add a new dependency, this project uses the recommended Flutter command:

```bash
flutter pub add package_name
```

✅ This updates the pubspec.yaml file with the latest stable and compatible version of the package and automatically runs flutter pub get.

🧠 If the package was already being used implicitly as a transitive dependency, Flutter will detect that and notify you without duplicating the entry.

⚠️ Note: Avoid updating all dependencies blindly, as some versions may be incompatible with each other. Flutter will warn you in the terminal if any issues arise when running flutter pub get.  

<br>  

## 🌿 Branching Strategy  
This feature was developed on a dedicated branch following a professional workflow:

```bash
feature/flutter_map_setup  
```
This keeps the main branch clean and allows for focused development and easier pull requests.  
<br>  

## 🎯 Learning Objectives  
This project aims to:

- Learn how to integrate interactive maps into a Flutter app

- Practice working with location data and routing APIs

- Follow a clean and maintainable Git/GitHub workflow (feature branches, commits, and pull requests)
<br>  

## 🧪 Next Steps  
Once the basic features are completed, the project may be expanded with:

- Real-time updates

- Reverse geocoding

- Route styling and instructions  
<br>  
  
Stay tuned!
