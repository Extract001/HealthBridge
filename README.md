# HealthBridge - Healthcare Appointment Booking App (Flutter)

A mobile application built in Flutter for the HealthBridge healthcare appointment system located inside `C:\Al-am\app\alamgir\speegile_assignment`.

---

## Application Architecture & Navigation Flow

```
                    HealthBridge
                         │
                    LoginScreen
                         │
                 ┌───────▼───────┐
                 │  AuthService  │
                 │  users.json   │
                 └───────┬───────┘
                         │
                       Valid
                         │
                    HomeScreen
                         │
          ┌──────────────┼──────────────┐
          │              │              │
      Timeline        Coverage       Search ────► Profile
      (Booked)       (Benefits)     (Doctors)     (Patient)
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
```

---

## Screen Implementations

1. **Login Screen (`LoginScreen`)**:
   - Manual user credential sign-in validating against local `assets/data/users.json`.
   - Error handling for empty fields or invalid credentials with inline error banners.
   - Password visibility toggle (`obscureText`).
   - Hero branding badge header.

2. **Home Screen (`HomeScreen`)**:
   - IndexedStack navigation architecture with 4 main tabs (*Timeline*, *Coverage*, *Search*, *Profile*).
   - Efficient `ListView.builder` displaying doctor records loaded from `assets/data/doctors.json`.
   - Category filter chip bar (*All*, *In-Network*, *Nearest to Me*, *Specialists*, *Primary Care*).
   - Category icons: `In-Network` checkmark icon (`Icons.check_circle_rounded`) and `Nearest to Me` navigation icon (`Icons.near_me_outlined`).
   - Automatic distance-based doctor sorting when *Nearest to Me* is selected.
   - Interactive Filter & Sort bottom sheet supporting in-network filtering, minimum rating threshold, and sorting by Distance, Rating, or Reviews.
   - Dynamic **Timeline tab** listing all newly booked appointments in real-time.
   - **Personal Information Sheet** under Profile tab displaying patient attributes (*Sophia Martinez*, DOB, blood type, address, emergency contact).
   - Reusable `DoctorCard` displaying status badges (*In-Network*, *Out-of-Network* with bullet dot), ratings, distance in km, uppercase `NEXT SLOT` box, and `View Profile & Book >` action link.
   - Promotional Urgent Care Wait Times banner card.

3. **About Doctor Screen (`AboutDoctorScreen`)**:
   - Receives selected `DoctorModel` passed from Home Screen.
   - Full doctor profile header, badges, bio description, and expertise chips wrapped in `Wrap` layout to prevent overflow.
   - Interactive Date Selector strip (*Mon OCT 23, Tue OCT 24, Wed OCT 25*) and Time Slot choice grid.
   - Appointment date columns and pre-selected time slot dynamically aligned with doctor's Home Screen `nextSlot` availability timing.
   - Call Front-Desk box and office location card with map graphic and Open in Google Maps launcher (`url_launcher`).
   - Scorecard with personalized recommendation rate, doctor name, and wait times per doctor.
   - Sticky **"Book Appointment"** button creating an `AppointmentModel` and navigating to confirmation.

4. **Appointment Confirmation Screen (`AppointmentConfirmationScreen`)**:
   - Receives booked `AppointmentModel` (Doctor, Date, Time).
   - Automatically appends newly booked appointment to `AppointmentService` for real-time display on the Timeline tab.
   - Success header with checkmark badge and formatted two-line confirmation message (*"Your appointment has been successfully\nscheduled."*).
   - Appointment detail summary card (Doctor name, specialty, date/time, office address).
   - Payment summary breakdown card with strikethrough Consultation Fee decoration, insurance coverage, total due `$0.00`, and **`FULLY COVERED`** green pill badge.
   - Text message receipt details card (*"Send appointment receipt details to family or caregiver via text message"*).
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
│       ├── dr_amar_rao.jpg
│       ├── dr_anjali_rao.jpg
│       ├── dr_elena_petrova.jpg
│       ├── dr_james_wilson.jpg
│       ├── dr_marcus_thorne.jpg
│       ├── dr_sarah_chen.jpg
│       └── user_profile.jpg
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
│   │   ├── custom_bottom_nav.dart
│   │   ├── custom_button.dart
│   │   ├── custom_text_field.dart
│   │   ├── doctor_card.dart
│   │   ├── filter_chip_bar.dart
│   │   └── urgent_care_banner.dart
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

| Username / Email | Password | Patient Name |
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
4. Run on Android device or emulator:
   ```bash
   flutter run
   ```
5. Build Android Debug APK (for testing):
   ```bash
   flutter build apk --debug
   ```
   *Output path:* `build/app/outputs/flutter-apk/app-debug.apk`

---

## Verified Checklist

- [x] Manual login validation against local JSON (`users.json`)
- [x] Password visibility toggle & validation error handling
- [x] Dynamic doctor listing using `ListView.builder` (`doctors.json`)
- [x] Category filters (*All, In-Network, Nearest to Me, Specialists, Primary Care*) with distance-based sorting
- [x] Out-of-Network and In-Network status badges with left bullet dot
- [x] Uppercase `NEXT SLOT` box & `View Profile & Book >` action link
- [x] Pre-selected appointment date/time slots aligned with Home Screen availability timing
- [x] Personalized doctor scorecards (*Recommendation Rate, Wait Times*)
- [x] Appointment confirmation summary, strikethrough fee decoration, and `FULLY COVERED` badge
- [x] Dynamic appointment persistence to Timeline tab (`AppointmentService`)
- [x] Personal information modal under Profile tab (*Sophia Martinez*)
- [x] System back button preserves navigation hierarchy
- [x] UI-only toggles for Google Calendar & SMS reminders
- [x] Live map view & Open in Google Maps launcher (`url_launcher`)
- [x] Distance unit strictly enforced in `km`
- [x] Fixed filter chip button sizes on tap
- [x] Zero RenderFlex overflow issues
- [x] Static analysis (`flutter analyze`) passes with 0 errors
- [x] Unit tests (`flutter test`) pass 3/3 tests
- [x] Debug APK compiled for testing (`app-debug.apk`)
