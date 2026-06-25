# ShopHub - Flutter E-Commerce App

A modern, feature-rich e-commerce mobile application built with Flutter. The app includes product browsing, shopping cart management, and a user profile section with clean UI and smooth animations.

## 📸 Features

### Core Features
- **Splash/Login Screen** - Beautiful splash screen with mock login functionality
- **Product Home Screen** - Grid/List view of products with search and category filtering
- **Product Details Screen** - Comprehensive product information with quantity selector
- **Shopping Cart** - Full cart management with quantity controls and price calculation
- **Profile/Orders Screen** - User profile, order history, and app settings

### Bonus Features
- ✅ **Product Search** - Real-time search filtering across all products
- ✅ **Category Filter** - Filter products by category (Electronics, Wearables, Accessories)
- ✅ **Grid/List View Toggle** - Switch between grid and list layouts
- ✅ **Local Storage** - Cart persistence using SharedPreferences
- ✅ **Smooth Animations** - Scale, fade, and transition animations throughout the app
- ✅ **Responsive Design** - Mobile-friendly UI that adapts to different screen sizes
- ✅ **Cart Badge** - Shows item count on cart icon with visual indicator
- ✅ **Professional UI** - Modern design with consistent color scheme and typography
- ✅ **Quantity Management** - Increase/decrease cart quantities
- ✅ **Price Calculations** - Subtotal, tax, and total calculations
- ✅ **Order Checkout** - Mock checkout dialog with order summary

## 🛠️ Technology Stack

- **Framework**: Flutter 3.0+
- **State Management**: Provider 6.0+
- **Local Storage**: SharedPreferences 2.1+
- **UI Components**: Material Design 3
- **Image Loading**: Cached Network Image 3.2+

## 📁 Project Structure

```
flutter_ecommerce/
├── lib/
│   ├── main.dart                    # App entry point
│   ├── screens/
│   │   ├── splash_screen.dart       # Splash/Login screen
│   │   ├── home_screen.dart         # Product listing with filters
│   │   ├── product_detail_screen.dart # Product details
│   │   ├── cart_screen.dart         # Shopping cart
│   │   └── profile_screen.dart      # User profile & orders
│   ├── models/
│   │   ├── product.dart             # Product data model
│   │   └── cart_item.dart           # Cart item model
│   ├── providers/
│   │   └── cart_provider.dart       # Cart state management
│   ├── widgets/
│   │   ├── product_card.dart        # Reusable product card
│   │   └── custom_app_bar.dart      # Custom app bar with cart badge
│   ├── data/
│   │   └── mock_data.dart           # Mock product data
│   └── utils/
│       └── constants.dart           # Colors, spacing, and themes
├── assets/
│   ├── images/                      # (Optional) Local images
│   └── data/                        # (Optional) JSON data
├── pubspec.yaml                     # Dependencies
└── README.md                        # This file
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (version 3.0 or higher)
- Dart SDK (included with Flutter)
- Android Studio / Xcode / VS Code with Flutter extension
- Git

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/flutter_ecommerce.git
   cd flutter_ecommerce
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

   For a specific device:
   ```bash
   flutter run -d <device-id>
   ```

### Building Release APK

```bash
# Build APK for Android
flutter build apk --release

# Build APK with split ABIs (smaller file sizes)
flutter build apk --release --split-per-abi

# Build App Bundle for Google Play
flutter build appbundle --release
```

The built files will be located in:
- APK: `build/app/outputs/flutter-apk/`
- App Bundle: `build/app/outputs/bundle/`

## 📚 Code Walkthrough

### State Management (Provider)

The app uses Provider for state management. The `CartProvider` handles all cart-related operations:

```dart
// Access cart from any widget
final cartProvider = context.watch<CartProvider>();

// Add product to cart
cartProvider.addToCart(product);

// Remove from cart
cartProvider.removeFromCart(productId);

// Update quantity
cartProvider.updateQuantity(productId, newQuantity);

// Get cart total
print(cartProvider.totalPrice); // $XXXX.XX
```

### Local Storage

Cart data is automatically persisted using SharedPreferences:

```dart
// Automatically saved on every cart change
await cartProvider._saveCart();

// Manually load cart on app start
await cartProvider.loadCart();
```

### Mock Data

Products are loaded from `lib/data/mock_data.dart` containing 12 sample products with:
- Product details (name, price, description)
- Ratings and reviews
- Stock information
- Category classification
- Network image URLs

## 🎨 UI/UX Highlights

### Color Scheme
- **Primary**: Indigo (#6366F1)
- **Secondary**: Green (#10B981)
- **Error**: Red (#EF4444)
- **Neutral**: Gray scale for text and backgrounds

### Typography
- **Display**: 32px, Bold (app title)
- **Headline**: 24-18px, Bold (section titles)
- **Body**: 16-12px, Regular (content text)
- **Label**: 14-12px, Medium (labels and badges)

### Spacing System
- **xs**: 4px
- **sm**: 8px
- **md**: 16px
- **lg**: 24px
- **xl**: 32px

## 📱 Responsive Design

The app is fully responsive and adapts to:
- Mobile phones (320px+)
- Tablets (600px+)
- Different orientations (Portrait/Landscape)

The product grid automatically adjusts:
- 2 columns on mobile devices
- 1 column for list view on all devices

## 🔄 Navigation Flow

```
Splash Screen
    ↓
Home Screen (Products Grid)
    ├── Product Card → Product Details
    │       └── Add to Cart
    ├── Search & Filter
    └── Bottom Navigation
        ├── Home
        ├── Cart
        │   └── Checkout
        └── Profile
            └── Order History
```

## 🐛 Troubleshooting

### Build Errors
- **Clear build cache**: `flutter clean && flutter pub get`
- **Update Flutter**: `flutter upgrade`

### Image Loading Issues
- The app uses network images. Ensure internet connection is available
- If images don't load, check `cached_network_image` configuration

### State Management Issues
- Ensure `CartProvider` is provided at the root of the app
- Use `context.watch()` in build methods to rebuild on state changes
- Use `context.read()` only in event handlers

## 📊 Performance Optimization

- **Lazy Loading**: Products loaded with pagination
- **Image Caching**: Local images cached 
- **State Management**: Only affected widgets rebuild on state change
- **List Optimization**: Using GridView builder for efficient rendering

## 🚢 Deployment

### Android
1. Update version in `pubspec.yaml`
2. Configure app signing in `android/app/build.gradle`
3. Build release APK/Bundle: `flutter build appbundle`
4. Upload to Google Play Console

### iOS
1. Update version in `pubspec.yaml`
2. Configure signing in Xcode
3. Build release IPA: `flutter build ios --release`
4. Upload to App Store Connect using Xcode Organizer

## 📝 Git Commit History

The project includes meaningful commit messages documenting each feature:

```
Initial project setup with Flutter
Add models for Product and CartItem
Implement cart state management with Provider
Create reusable UI components (ProductCard, CustomAppBar)
Implement Splash/Login screen with animations
Create Home screen with product grid and filters
Add Product Details screen with quantity selector
Implement Shopping Cart with full CRUD operations
Add Profile/Orders screen with user management
Integrate local storage with SharedPreferences
Add responsive design improvements
Polish animations and UI interactions
Final testing and bug fixes
```

## 🤖 AI Tool Usage

This project was developed with assistance from **Claude AI (Anthropic)**. Here's what Claude assisted with:

### Code Structure & Architecture
- Project folder organization and structure
- Model class design (Product, CartItem)
- Provider implementation for state management
- Widget component hierarchy

### Implementation Details
- Complete Flutter widget implementations
- Animation implementations (FadeTransition, ScaleTransition)
- Responsive grid/list view layouts
- Form validation and error handling

### UI/UX
- Color scheme and typography constants
- Custom app bar with cart badge
- Product card design with hover effects
- Profile screen layout and settings

### Features
- Search and filter functionality
- Cart persistence with SharedPreferences
- Checkout dialog implementation
- Order history mock data

### Documentation
- Code comments and explanations
- README file with comprehensive setup guide
- Architecture documentation
- Deployment instructions

**Note**: While AI provided significant assistance in code generation and structuring, all code has been reviewed, understood, and integrated properly into the application. The developer maintained full understanding of the codebase and can explain any part of the implementation.

## 📄 License

This project is created for educational purposes. Feel free to use it as a reference or template for your own e-commerce applications.

## 👨‍💻 Contributing

If you'd like to contribute to this project, please:
1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Open a pull request

## 📧 Support

For questions or issues, please open an issue on GitHub or contact the developer.

---

