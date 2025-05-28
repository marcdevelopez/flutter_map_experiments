# Flutter Map Experiments

This project is a personal practice with **Flutter** and the `flutter_map` package. The main features include:

- Displaying the user's current location on a map.
- Allowing the user to manually enter a destination (latitude and longitude).
- Drawing a route between point A (user) and point B (destination) using external routing services.


## 📦 Dependency Management in Flutter

To add a new dependency, this project uses the recommended Flutter command:

```bash
flutter pub add package_name
```

✅ This updates the pubspec.yaml file with the latest stable and compatible version of the package and automatically runs flutter pub get.

🧠 If the package was already being used implicitly as a transitive dependency, Flutter will detect that and notify you without duplicating the entry.

⚠️ Note: Avoid updating all dependencies blindly, as some versions may be incompatible with each other. Flutter will warn you in the terminal if any issues arise when running flutter pub get.  


## 🌿 **Branching Strategy**  
This feature was developed on a dedicated branch following a professional workflow:

```bash
feature/flutter_map_setup  
```
This keeps the main branch clean and allows for focused development and easier pull requests.  

## 🎯 Learning Objectives  
This project aims to:

- Learn how to integrate interactive maps into a Flutter app

- Practice working with location data and routing APIs

- Follow a clean and maintainable Git/GitHub workflow (feature branches, commits, and pull requests)

## 🧪 Next Steps  
Once the basic features are completed, the project may be expanded with:

- Real-time updates

- Reverse geocoding

- Route styling and instructions  

Stay tuned!