# Veloura Fashion Store - Flutter App
## CIT211 Phase 1 Submission

---

## 📁 Project Structure

```
veloura/
├── lib/
│   ├── main.dart                    # App entry + routing
│   ├── models/
│   │   └── models.dart              # Product, CartItem, Order + sample data
│   ├── utils/
│   │   ├── theme.dart               # AppColors + AppTheme
│   │   ├── auth_provider.dart       # Login/Register state (mock, no Firebase)
│   │   └── cart_provider.dart       # Cart, Wishlist, Orders state
│   ├── widgets/
│   │   └── widgets.dart             # Shared: ProductCard, BottomNav, Buttons
│   └── screens/
│       ├── splash_screen.dart       # Page 1 – Landing with "Let's Start"
│       ├── auth_screens.dart        # Login + Register screens
│       ├── main_shell.dart          # Bottom nav shell (4 tabs)
│       ├── home_screen.dart         # Page 2 – Home with search + categories
│       ├── product_detail_screen.dart # Product detail with size/color picker
│       ├── cart_screen.dart         # Cart with order summary
│       ├── checkout_screen.dart     # Page 3 – Checkout (shipping, payment)
│       ├── profile_screen.dart      # Page 4 – Profile / account creation
│       ├── wishlist_screen.dart     # Saved items
│       └── orders_screen.dart       # Order history
└── pubspec.yaml
```

---

## 🚀 How to Run

### 1. Create a new Flutter project (or use this folder directly)

```bash
# If starting fresh:
flutter create veloura
cd veloura

# Replace the generated lib/ with the provided lib/
# Replace pubspec.yaml with the provided one
```

### 2. Install dependencies

```bash
flutter pub get
```

### 3. Run the app

```bash
# On Android emulator or connected device:
flutter run

# To build APK:
flutter build apk --debug
```

---

## 📱 Screens Implemented

| Screen            | Route        | Description                              |
|-------------------|-------------|------------------------------------------|
| Splash            | `/`          | Purple gradient with "Let's Start" CTA  |
| Login             | `/login`     | Email/password + social login UI        |
| Register          | `/register`  | Account creation form                   |
| Home              | `/main` → 0  | Products grid, search, category filter  |
| Wishlist          | `/main` → 1  | Saved/favourited products               |
| Cart              | `/main` → 2  | Items, quantity control, order summary  |
| Profile           | `/main` → 3  | User info, menu, logout                 |
| Product Detail    | `/product`   | Images, size/colour picker, add to cart |
| Checkout          | `/checkout`  | Shipping, delivery, payment, place order|
| Orders            | `/orders`    | Order history list                      |

---

## 🎨 Design System (matches Figma)

- **Primary color:** `#9B30D9` (purple)
- **Font (Display):** Playfair Display
- **Font (Body):** Lato
- **Border radius:** 12–16px cards, 30px buttons
- **Navigation:** 4-tab bottom bar (Home, Wishlist, Cart, Profile)

---

## ⚠️ Phase 1 Notes

- **No Firebase** – Auth and data are mocked locally using ChangeNotifier providers
- State is **in-memory only** (resets on app restart)
- Firebase will be added in **Phase 2**
- Products are defined in `lib/models/models.dart` (to be replaced with Firestore in Phase 2)

---

## 📦 Dependencies

```yaml
google_fonts: ^6.1.0          # Playfair Display + Lato fonts
cached_network_image: ^3.3.1  # Product images from URLs
provider: ^6.1.1              # State management
smooth_page_indicator: ^1.1.0 # (available for onboarding future use)
```

> **Note:** Add `provider` to pubspec.yaml dependencies before running:
> ```yaml
> provider: ^6.1.1
> ```
