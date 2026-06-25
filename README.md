# ShopHub — Flutter E-Commerce App

A modern e-commerce mobile app built with Flutter.  
All data originates from **`mock_data.dart`** and is automatically persisted to device storage via **SharedPreferences** so every change survives app restarts.

---

## 📸 Features

### Core Features
- **Splash / Login Screen** — Animated splash with mock login
- **Product Home Screen** — Grid / List with live search and category filter
- **Product Details Screen** — Full info with quantity selector
- **Shopping Cart** — Full cart management with price calculations
- **Profile / Orders** — User profile, order history, app settings
- **Address Management** — Add, edit, delete, set default addresses

### Data & Storage Features (v1.1)
| Feature | Detail |
|---|---|
| **Single source of truth** | `lib/data/mock_data.dart` holds all seed data (products, user, orders, addresses) |
| **Auto-persist** | Every change is saved to SharedPreferences instantly — no manual saves |
| **Seed on first launch** | DB is populated from `mock_data.dart` automatically |
| **View all data** | Products, user, addresses, orders all displayed in the UI |
| **Edit records** | Profile, addresses, and products are fully editable |
| **Add new records** | New products, addresses, and orders can be added at runtime |
| **Delete records** | Products and addresses can be deleted with confirmation |
| **Admin screen** | Dedicated product manager: add / edit / delete with form validation |
| **Cart persistence** | Cart survives app restarts |

---

## 🛠️ Technology Stack

| Layer | Package |
|---|---|
| Framework | Flutter 3.0+ |
| State Management | Provider 6.0+ |
| Storage | SharedPreferences 2.1+ |
| UI | Material Design 3 |
| Images | Cached Network Image 3.2+ |

No new dependencies were added — the project uses only packages already in `pubspec.yaml`.

---

## 📁 Project Structure

```
lib/
├── main.dart                           
├── data/
│   └── mock_data.dart                
├── model/
│   ├── cart_item.dart
│   └── product.dart
├── providers/
│   ├── cart_provider.dart              
│   ├── product_provider.dart           
│   ├── theme_provider.dart
│   └── user_data_provider.dart        
├── screens/
│   ├── admin_products_screen.dart      
│   ├── address_management_screen.dart
│   ├── address_screen.dart
│   ├── cart_screen.dart
│   ├── home_screen.dart
│   ├── order_detail_screen.dart
│   ├── product_detail_screen.dart
│   ├── profile_screen.dart
│   └── splash_screen.dart
├── utils/
│   └── constants.dart
└── widgets/
    ├── custom_app_bar.dart
    └── product_card.dart
```

---

## 🗄️ Data Flow

```
mock_data.dart   ──(first launch)──▶  SharedPreferences  ──▶  Provider  ──▶  UI
                                             ▲                    │
                                             └────────────────────┘
                                             (every mutation auto-saved)
```

**SharedPreferences keys:**

| Key | Content |
|---|---|
| `db_products` | JSON list of all products |
| `db_cart` | JSON list of cart items |
| `db_user_profile` | JSON object (name, email, phone) |
| `db_addresses` | JSON list of addresses |
| `db_orders` | JSON list of orders |

---

## 🚀 Getting Started

```bash
git clone https://github.com/yourusername/flutter_ecommerce.git
cd flutter_ecommerce
flutter pub get
flutter run
```

No additional setup required — all data is seeded automatically on first launch.

---

## 🖥️ Admin Product Manager

Open `AdminProductsScreen` (e.g. from Profile → Manage Products) to:

- **View** all products from the database
- **Add** new products (tap `+`, fill the form, tap *Add Product*)
- **Edit** any product (tap the pencil icon)
- **Delete** any product (tap the trash icon, confirm)

Changes appear in the Home screen product grid immediately.

---

## 🐛 Troubleshooting

| Symptom | Fix |
|---|---|
| Old data showing | `flutter clean && flutter pub get` then reinstall the app to clear SharedPreferences |
| Build errors | `flutter clean && flutter pub get && flutter run` |

---

## 📄 License

Educational project — free to use as a reference or template.
