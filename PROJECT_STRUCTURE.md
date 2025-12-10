# Digital Wardrobe - Flutter Mobile App

A beautiful, catalog-based outfit management application built with Flutter and Clean Architecture.

## 📱 Features

- **Authentication**: User registration, login, and logout
- **Outfit Management**: Add, edit, delete, and view outfit items
- **Categories**: Organize outfits by type (Tops, Bottoms, Outerwear, Shoes, Accessories)
- **Search & Filter**: Find outfits quickly by name, category, or favorites
- **Favorites**: Mark and view your favorite outfits
- **Recommendations**: Get outfit combination suggestions
- **Image Upload**: Attach photos to your outfits
- **Local Caching**: Fast browsing with offline support
- **Modern UI**: Clean, aesthetic design inspired by Pinterest/Notion

## 🏗️ Architecture

This project follows **Clean Architecture** principles with clear separation of concerns:

```
lib/
├── core/                      # Core functionality
│   ├── constants/            # App-wide constants
│   │   ├── app_constants.dart
│   │   └── outfit_categories.dart
│   ├── theme/               # App theming
│   │   └── app_theme.dart
│   ├── utils/               # Utilities and routing
│   │   └── app_router.dart
│   └── errors/              # Error handling
│       └── failures.dart
│
├── data/                      # Data layer
│   ├── models/              # Data models (JSON serializable)
│   ├── repositories/        # Repository implementations
│   └── datasources/         # Data sources
│       ├── remote/          # API calls
│       └── local/           # Local storage
│
├── domain/                    # Business logic layer
│   ├── entities/            # Business entities
│   ├── repositories/        # Repository interfaces
│   └── usecases/            # Business use cases
│
└── presentation/              # Presentation layer
    ├── screens/             # UI screens
    │   ├── auth/           # Login & Register
    │   ├── home/           # Home screen
    │   ├── outfit/         # Outfit CRUD screens
    │   └── profile/        # Profile screen
    ├── providers/           # State management (Provider)
    └── widgets/             # Reusable widgets
```

## 🛠️ Tech Stack

### Frontend
- **Framework**: Flutter (Material 3)
- **State Management**: Provider
- **Architecture**: Clean Architecture (MVVM-inspired)
- **HTTP Client**: Dio + http package
- **Image Handling**: image_picker, cached_network_image
- **Local Storage**: shared_preferences
- **JSON Serialization**: json_annotation, json_serializable

### Backend (To be implemented)
- **Framework**: FastAPI (Python)
- **Database**: MySQL
- **Image Storage**: Local file system (can be upgraded to cloud)
- **API**: RESTful JSON-based

## 📦 Dependencies

```yaml
dependencies:
  provider: ^6.1.2              # State management
  dio: ^5.7.0                   # HTTP client
  http: ^1.2.2                  # Alternative HTTP client
  shared_preferences: ^2.3.3    # Local storage
  image_picker: ^1.1.2          # Image selection
  cached_network_image: ^3.4.1  # Image caching
  json_annotation: ^4.9.0       # JSON serialization
  intl: ^0.20.1                 # Date formatting

dev_dependencies:
  build_runner: ^2.4.13         # Code generation
  json_serializable: ^6.8.0     # JSON code gen
  flutter_lints: ^6.0.0         # Linting
```

## 🎨 Design System

### Color Palette (Pinterest/Notion inspired)
- **Primary**: #2D3142 (Dark Blue-Gray)
- **Secondary**: #BFC0C0 (Light Gray)
- **Accent**: #EF8354 (Coral Orange)
- **Background**: #F7F7F7 (Off-White)
- **Surface**: #FFFFFF (White)
- **Error**: #E63946 (Red)
- **Success**: #06A77D (Green)

### Typography
- Clean, modern font hierarchy
- Material 3 text theme with proper weights
- Readable body text with appropriate line heights

### Components
- Rounded corners (12-16px radius)
- Subtle shadows for depth
- Consistent padding and spacing
- Touch-friendly button sizes

## 📸 Screens

### Implemented UI Screens

1. **Login Screen** (`lib/presentation/screens/auth/login_screen.dart`)
   - Email and password fields
   - Input validation
   - Loading state
   - Navigate to registration

2. **Register Screen** (`lib/presentation/screens/auth/register_screen.dart`)
   - Name, email, password, confirm password fields
   - Form validation
   - Loading state

3. **Home Screen** (`lib/presentation/screens/home/home_screen.dart`)
   - Search bar with filter
   - Category cards
   - Recent outfits grid
   - Recommended combinations
   - Bottom navigation

4. **Outfit List Screen** (`lib/presentation/screens/outfit/outfit_list_screen.dart`)
   - Search functionality
   - Filter by category and favorites
   - Grid layout with favorite toggle
   - Floating action button to add outfit

5. **Outfit Detail Screen** (`lib/presentation/screens/outfit/outfit_detail_screen.dart`)
   - Full image display
   - Outfit details (name, category, color, notes)
   - Edit and delete options
   - "Wear with" recommendations

6. **Add Outfit Screen** (`lib/presentation/screens/outfit/add_outfit_screen.dart`)
   - Image picker
   - Form fields (name, category, color, notes)
   - Validation
   - Submit button with loading state

7. **Edit Outfit Screen** (`lib/presentation/screens/outfit/edit_outfit_screen.dart`)
   - Pre-filled form with existing data
   - Update functionality
   - Image replacement

8. **Profile Screen** (`lib/presentation/screens/profile/profile_screen.dart`)
   - User information
   - Statistics (outfits, favorites, combos)
   - Settings menu
   - Logout functionality

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (^3.10.3)
- Dart SDK
- Android Studio / VS Code with Flutter extensions
- Git

### Installation

1. **Clone the repository**
```bash
git clone <repository-url>
cd digital_wardrobe
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Run the app**
```bash
flutter run
```

### Configuration

Update API base URL in `lib/core/constants/app_constants.dart`:
```dart
static const String baseUrl = 'http://your-api-url:8000/api/v1';
```

## 📋 Next Steps

### Phase 1: Complete Data Layer ✅ (Current)
- [x] Project structure setup
- [x] UI screens implementation
- [x] Routing system
- [x] Theme configuration
- [ ] Create data models
- [ ] Implement repositories
- [ ] Set up API service

### Phase 2: Implement Business Logic
- [ ] Create use cases
- [ ] Set up providers
- [ ] Implement state management
- [ ] Connect UI to providers

### Phase 3: Backend Development
- [ ] Set up FastAPI project
- [ ] Create database schema
- [ ] Implement authentication
- [ ] Create CRUD endpoints
- [ ] Image upload handling

### Phase 4: Integration
- [ ] Connect Flutter to backend
- [ ] Implement API calls
- [ ] Handle image uploads
- [ ] Set up local caching
- [ ] Error handling

### Phase 5: Testing & Polish
- [ ] Unit tests
- [ ] Widget tests
- [ ] Integration tests
- [ ] Performance optimization
- [ ] Bug fixes

## 🔧 Development Guidelines

### Code Style
- Follow Flutter/Dart conventions
- Use meaningful variable names
- Add comments for complex logic
- Keep widgets small and focused
- Extract reusable components

### State Management
- Use Provider for global state
- Keep state as local as possible
- Avoid unnecessary rebuilds
- Use `Consumer` and `Provider.of` appropriately

### API Integration
- Always handle errors gracefully
- Show loading states
- Implement timeout handling
- Cache responses when appropriate
- Use proper HTTP status codes

### File Organization
- One widget per file (generally)
- Group related files in folders
- Use barrel files (index.dart) for exports
- Keep imports organized

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Write/update tests
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License.

## 👨‍💻 Author

Digital Wardrobe Team

---

**Note**: This is Phase 1 of the project. The UI screens are implemented with placeholder data. Backend integration and full functionality will be added in subsequent phases.
