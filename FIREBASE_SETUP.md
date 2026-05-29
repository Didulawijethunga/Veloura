# Veloura – Firebase Setup Guide

Follow these steps to connect the app to Firebase.

---

## 1. Create a Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Click **Add project** → name it `veloura` → continue
3. Disable Google Analytics (optional) → **Create project**

---

## 2. Add Android App

1. In Firebase Console → **Project settings** → **Add app** → Android
2. Package name: `com.example.veloura` (check `android/app/build.gradle` for your actual name)
3. Download `google-services.json`
4. Place it at: `android/app/google-services.json`

---

## 3. Configure firebase_options.dart

### Option A – FlutterFire CLI (recommended)
```bash
dart pub global activate flutterfire_cli
flutterfire configure
```
This auto-generates `lib/firebase_options.dart` with your real values.

### Option B – Manual
Open `lib/firebase_options.dart` and replace every `YOUR_*` placeholder with
values from **Firebase Console → Project settings → Your apps → SDK config**.

---

## 4. Enable Firebase Services

### Authentication
1. Firebase Console → **Build → Authentication → Get started**
2. **Sign-in method** → Enable **Email/Password**

### Firestore
1. Firebase Console → **Build → Firestore Database → Create database**
2. Choose **Start in test mode** (for development)
3. Select a region → **Enable**

---

## 5. Firestore Security Rules (for production)

Replace the default rules with:

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {

    // Public read for products
    match /products/{productId} {
      allow read: if true;
      allow write: if false;
    }

    // Users can only access their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;

      match /cart/{item} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
      }
    }

    // Orders belong to their creator
    match /orders/{orderId} {
      allow read, write: if request.auth != null &&
        request.auth.uid == resource.data.userId;
      allow create: if request.auth != null &&
        request.auth.uid == request.resource.data.userId;
    }
  }
}
```

---

## 6. Seed Products

The app seeds Firestore automatically on first launch if the `products`
collection is empty. No manual action is needed.

To trigger a manual re-seed:
1. In **Firestore Console**, delete all documents in the `products` collection.
2. Re-launch the app – it will detect the empty collection and seed again.

---

## 7. Firestore Indexes

The orders query requires a composite index. When you first place an order
and view order history, Firestore will print an error in the console with a
direct link to create the index. Click it, wait ~1 minute, done.

Alternatively create it manually:
- Collection: `orders`
- Fields: `userId` (Ascending), `date` (Descending)

---

## 8. Run the App

```bash
flutter pub get
flutter run
```

For release APK:
```bash
flutter build apk --release
```
The APK is at `build/app/outputs/flutter-apk/app-release.apk`.
