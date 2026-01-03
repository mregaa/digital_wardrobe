# Digital Wardrobe

A Flutter mobile application for managing personal clothing items and creating outfit combinations through an interactive visual canvas.

## Project Overview

Digital Wardrobe is a wardrobe management application that helps users organize their clothing collection and experiment with different outfit combinations. The app addresses the common problem of managing a growing wardrobe and visualizing how different pieces work together before actually wearing them.

Users can photograph their clothing items, categorize them, and use an interactive avatar-based canvas to mix and match items visually. This makes outfit planning more intuitive and helps maximize the use of existing wardrobe pieces.

**Academic Context**: This project was developed as a final assignment for a Mobile Development university course, demonstrating practical application of mobile app development concepts including state management, API integration, gesture-based interfaces, and media handling.

## Core Features

### Authentication
- User registration and login system
- Secure session management
- Profile management with user statistics

### Wardrobe Management
- **Add Clothing Items**:
  - Select images from device gallery
  - Capture photos directly using device camera
  - Real-time image preview before submission
  - Option to use background removal tools for cleaner images
  - Categorize items (tops, bottoms, outerwear, shoes, accessories)
  - Add metadata: name, color, and optional notes
  - Support for transparent PNG images

- **Browse Outfits**:
  - Grid view of all clothing items
  - Category-based filtering
  - Search functionality by name
  - Favorites filter to view saved items
  - Quick access to outfit details

- **Outfit Details**:
  - Full-screen outfit viewing
  - Edit existing outfits
  - Delete unwanted items
  - Mark items as favorites

- **Favorites System**:
  - Toggle favorite status on any outfit
  - Dedicated favorites screen
  - Persistent favorite state across sessions

### Avatar Outfit Builder (Mix & Match)
The centerpiece feature allowing visual outfit composition:

- **Interactive Canvas**:
  - Clean 2D canvas with grid background
  - Avatar silhouette as a sizing reference
  - Full-screen workspace for outfit building

- **Drag and Drop**:
  - Long-press clothing items from library
  - Drag items onto canvas
  - Visual feedback during dragging

- **Multi-Touch Gestures**:
  - Move items by dragging
  - Pinch to scale items up or down
  - Two-finger rotation for angle adjustment
  - Smooth, responsive gesture handling

- **Canvas Controls**:
  - Tap items to bring to front (z-order management)
  - Remove individual items
  - Clear entire canvas
  - Save combinations with custom names

- **Expandable Library**:
  - Collapsible outfit library at bottom
  - Category filters (All, tops, bottoms, outerwear, shoes, accessories)
  - Smooth expand/collapse animation
  - Grid layout for easy browsing

### User Interface
- Material Design 3 theming
- Responsive layouts for different screen sizes
- Bottom navigation for main sections
- Intuitive icons and visual feedback
- Error states with helpful messages
- Loading indicators during operations

## Technical Highlights

### State Management
- **Provider pattern** for application-wide state
- Separated providers for different concerns:
  - Authentication state
  - Outfit list management
  - Favorites management
  - Mix & Match canvas state
  - Outfit form handling
- Efficient UI updates using ChangeNotifier

### API Integration
- RESTful API communication using Dio HTTP client
- Multipart form data for image uploads
- Safe error handling with type-checked responses
- Image URL normalization for relative paths
- Automatic token management for authenticated requests

### Media Handling
- Integration with device camera via image_picker
- Gallery image selection
- File preview before upload
- Support for PNG transparency
- Image rendering optimization (anti-aliasing, quality filtering)

### Gesture System
- Custom multi-touch gesture handling
- Stable transform calculations (position, scale, rotation)
- Scale clamping for usability (0.2x to 4.0x)
- Gesture state management for smooth interactions

### Data Safety
- Safe enum parsing with fallback values
- Null-safe implementation throughout
- Comprehensive error handling
- Type validation for API responses

### Cross-Platform Considerations
- Android-specific permission handling (camera)
- Intent queries for URL launching
- Platform-aware UI components
- Responsive layouts

## Technologies Used

### Frontend
- **Flutter SDK** - Cross-platform mobile framework
- **Dart** - Programming language
- **Provider** (^6.0.0) - State management
- **Material Design 3** - UI design system

### Networking
- **Dio** - HTTP client for API communication
- **Multipart uploads** - Image file transmission

### Media & Utilities
- **image_picker** (^1.1.2) - Camera and gallery access
- **url_launcher** (^6.3.1) - External URL handling

### Backend
- REST API (FastAPI-style architecture)
- JSON data format
- Token-based authentication
- File storage for uploaded images

## Application Structure

### Main Screens

1. **Login Screen**
   - Email and password authentication
   - Navigation to registration
   - Automatic redirect on successful login

2. **Home Screen**
   - Recent outfits overview
   - Quick access to main features
   - Bottom navigation bar

3. **Outfit List Screen**
   - Grid display of all outfits
   - Category filter chips
   - Search bar for quick finding
   - Favorites toggle button
   - Navigation to outfit details

4. **Add Outfit Screen**
   - Image selection (gallery/camera)
   - Form fields for outfit details
   - Category dropdown selection
   - Background remover tip dialog
   - Image preview with white background for transparency

5. **Edit Outfit Screen**
   - Similar to add screen
   - Pre-filled with existing data
   - Shows current outfit image
   - Option to change image

6. **Outfit Detail Screen**
   - Full-screen image display
   - Complete outfit information
   - Edit and delete options
   - Favorite toggle button

7. **Favorites Screen**
   - Grid view of favorited items
   - Remove from favorites option
   - Direct navigation to outfit details

8. **Mix & Match Screen**
   - Canvas workspace with grid
   - Avatar silhouette guide
   - Expandable library at bottom
   - Category filters
   - Save combination button
   - Clear canvas option

9. **Profile Screen**
   - User information display
   - Statistics (outfit count, favorites count, combos count)
   - Tappable stats that navigate to respective screens
   - Settings and logout options

## How to Run the App

### Prerequisites
- Flutter SDK (3.0.0 or higher)
- Android Studio / VS Code with Flutter extensions
- Android device or emulator (for Android testing)
- Web browser (for web testing)

### Setup Steps

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd digital_wardrobe
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure backend URL**
   - Open `lib/core/constants/app_constants.dart`
   - Update `baseUrl` and `imageBaseUrl` with your backend server address
   - Example: `http://YOUR_IP:8000`

4. **Run the application**
   
   For Android:
   ```bash
   flutter run
   ```
   
   For Web:
   ```bash
   flutter run -d chrome
   ```

### Backend Setup Notes
- Ensure the backend REST API is running and accessible
- Backend should support endpoints for:
  - User authentication (`/auth/login`, `/auth/register`)
  - Outfit CRUD operations (`/outfits/`, `/outfits/{id}`)
  - Favorites management (`/outfits/{id}/favorite`)
  - Image file uploads
- Configure CORS if running web version

## Learning Outcomes

This project demonstrates practical implementation of:

1. **Mobile Development Fundamentals**
   - Cross-platform development with Flutter
   - Material Design principles
   - Platform-specific features (camera, file access)

2. **State Management**
   - Provider pattern implementation
   - Separation of concerns
   - Efficient state updates

3. **API Integration**
   - RESTful API consumption
   - Authentication flows
   - Multipart file uploads
   - Error handling strategies

4. **Advanced UI/UX**
   - Gesture-based interactions
   - Drag and drop interfaces
   - Multi-touch transformations
   - Expandable/collapsible components
   - Image handling with transparency

5. **Software Architecture**
   - Clean architecture principles
   - Repository pattern
   - Provider-based dependency injection
   - Feature-based project structure

## Project Structure

```
lib/
├── core/                       # Core utilities and constants
│   ├── constants/             # App-wide constants
│   ├── utils/                 # Helper functions and routing
│   └── widgets/               # Shared widgets
├── features/                  # Feature modules
│   ├── auth/                  # Authentication
│   │   ├── data/             # Auth data layer
│   │   ├── domain/           # Auth domain layer
│   │   └── presentation/     # Auth UI
│   ├── wardrobe/             # Outfit management
│   │   ├── data/            # Data sources, repositories
│   │   ├── domain/          # Entities, repository interfaces
│   │   └── presentation/    # UI screens and providers
│   └── mix_match/           # Avatar outfit builder
│       ├── data/
│       ├── domain/
│       └── presentation/
└── main.dart                 # Application entry point
```

## Known Limitations

- Saved combinations currently store basic metadata (implementation can be extended)
- Web version has limited gesture support compared to mobile
- Image processing is client-side (no backend image optimization)
- Background removal requires external tool integration

## Future Enhancements

Potential improvements for continued development:
- Cloud storage integration for images
- Social sharing of outfit combinations
- AI-based outfit recommendations
- Weather-based outfit suggestions
- Calendar integration for outfit planning
- Export combinations as images

## Assignment Notes

**Course**: Mobile Development  
**Purpose**: Final Assignment  
**Focus Areas**:
- Mobile application development with Flutter
- Integration with REST APIs
- State management in mobile apps
- Gesture-based user interfaces
- Media handling (camera and gallery)
- Cross-platform considerations

This project showcases the integration of multiple mobile development concepts into a cohesive, user-friendly application that solves a real-world problem of wardrobe organization and outfit planning.

## License

This project is developed for educational purposes as part of a university course assignment.
