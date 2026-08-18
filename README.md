# HealthBridge - Healthcare Appointment Booking App (Flutter)

A mobile application built in Flutter for the HealthBridge healthcare appointment system.

---

## Application Architecture & Navigation Flow

```
                    HealthBridge
                         │
                    LoginScreen
                         │
                ┌────────▼────────┐
                │  AuthService    │
                │   users.json    │
                └────────┬────────┘
                         │
                       Valid
                         │
                    HomeScreen
                         │
                ┌────────▼────────┐
                │  DoctorService  │
                │   doctors.json  │
                └────────┬────────┘
                         │
                    DoctorCard
                         │
                         ▼
               AboutDoctorScreen
                         │
                 Select Date/Time
                         │
                         ▼
                AppointmentModel
                         │
                         ▼
          AppointmentConfirmationScreen
                         │
                         ▼
             Done button -> HomeScreen
             (Android Back -> AboutDoctorScreen)
```

---

## Screen Implementations

1. **Login Screen (`LoginScreen`)**:
   - Email/Username and Password validation against local `assets/data/users.json`.
   - Clear error messages for empty fields or invalid credentials.
   - Password visibility toggle (`obscureText`).
   - Manual credential sign-in for secure patient access.

2. **Home Screen (`HomeScreen`)**:
   - Efficient `ListView.builder` displaying doctor records loaded from `assets/data/doctors.json`.
   - Dynamic Timeline tab displaying all newly booked appointments in real-time.
   - Personal Information sheet under Profile displaying patient details, blood group, address, and emergency contact.
   - Category filter pills (*All, In-Network, Nearest to Me, Specialists, Primary Care*).
   - Reusable `DoctorCard` items displaying status badges, ratings, distance (km), next slot details, and action links.
   - Promotional Urgent Care Wait Times banner card.
   - Bottom navigation bar (*Timeline, Coverage, Search, Profile*).

3. **About Doctor Screen (`AboutDoctorScreen`)**:
   - Receives selected `DoctorModel` passed from Home Screen.
   - Full doctor profile header, badges, bio description, and expertise chips.
   - Interactive Date Selector strip (*Mon OCT 23, Tue OCT 24, Wed OCT 25*) and Time Slot choice grid derived from doctor date objects.
   - Call Front-Desk box and office location card with map graphic and Open in Google Maps action button.
   - Scorecard with personalized recommendation rate, doctor name, and wait times per doctor.
   - Sticky **"Book Appointment"** button, creating an `AppointmentModel` and navigating to confirmation.

4. **Appointment Confirmation Screen (`AppointmentConfirmationScreen`)**:
   - Receives booked `AppointmentModel` (Doctor, Date, Time).
   - Automatically persists booked appointment into `AppointmentService`.
   - Success header with checkmark badge.
   - Appointment detail summary card (Doctor name, specialty, date/time, office address).
   - Fee breakdown (Consultation fee, insurance coverage, total due $0.00).
   - UI-only preference toggles for Google Calendar auto-add & SMS reminders.
   - **Done** button returning to Home Screen, while Android system back button preserves normal stack navigation.

---

## Project Structure

```
speegile_assignment/
├── assets/
│   ├── data/
│   │   ├── users.json
│   │   └── doctors.json
│   └── images/
│       ├── .gitkeep
│       └── PLACE_YOUR_IMAGES_HERE.txt
│
├── lib/
│   ├── constants/
│   │   ├── app_colors.dart
│   │   └── app_styles.dart
│   │
│   ├── models/
│   │   ├── user_model.dart
│   │   ├── doctor_model.dart
│   │   └── appointment_model.dart
│   │
│   ├── services/
│   │   ├── auth_service.dart
│   │   ├── doctor_service.dart
│   │   └── appointment_service.dart
│   │
│   ├── widgets/
│   │   ├── custom_button.dart
│   │   ├── custom_text_field.dart
│   │   ├── doctor_card.dart
│   │   ├── filter_chip_bar.dart
│   │   ├── urgent_care_banner.dart
│   │   └── custom_bottom_nav.dart
│   │
│   ├── screens/
│   │   ├── login_screen.dart
│   │   ├── home_screen.dart
│   │   ├── about_doctor_screen.dart
│   │   └── appointment_confirmation_screen.dart
│   │
│   └── main.dart
│
├── test/
│   └── widget_test.dart
├── README.md
└── pubspec.yaml
```

---

## Package Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  google_fonts: ^6.2.1
  intl: ^0.19.0
  flutter_map: ^6.1.0
  latlong2: ^0.9.0
  url_launcher: ^6.3.0
```

---

## Demo Credentials

| Username / Email | Password | Name |
| :--- | :--- | :--- |
| `patient@healthbridge.com` | `password123` | Sophia Martinez |

---

## Setup & Execution Instructions

1. Install dependencies:
   ```bash
   flutter pub get
   ```
2. Run static analysis:
   ```bash
   flutter analyze
   ```
3. Run unit tests:
   ```bash
   flutter test
   ```
4. Run on Android device/emulator:
   ```bash
   flutter run
   ```
5. Build Android Debug APK (for testing):
   ```bash
   flutter build apk --debug
   ```
   *Generated path:* `build/app/outputs/flutter-apk/app-debug.apk`

---

## Verified Checklist

- [x] Login validation against local JSON (`users.json`)
- [x] Password visibility toggle & validation error handling
- [x] Dynamic doctor listing using `ListView.builder` (`doctors.json`)
- [x] Search & filter functionality
- [x] Registered `assets/images/` directory for custom image files
- [x] Passing selected `DoctorModel` to `AboutDoctorScreen`
- [x] Interactive date & time slot selection creating `AppointmentModel`
- [x] Appointment confirmation summary & cost breakdown
- [x] Dynamic appointment persistence to Timeline tab (`AppointmentService`)
- [x] Personal information modal under Profile tab
- [x] System back button preserves navigation hierarchy
- [x] UI-only toggles for Google Calendar & SMS reminders
- [x] Live map view & Open in Google Maps launcher
- [x] No RenderFlex overflow issues
- [x] `flutter analyze` & `flutter test` pass with 0 errors
- [x] Debug APK compiled for testing (`app-debug.apk`)
