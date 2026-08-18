# HealthBridge - Healthcare Appointment Booking App (Flutter)

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

## Setup & Execution Instructions

1. **Prerequisites**:
   - Flutter SDK (v3.0.0 or higher)
   - Android Studio / VS Code with Flutter extension
   - Android Emulator or physical device

2. **Installation Steps**:
   ```bash
   # Clone repository
   git clone https://github.com/Extract001/HealthBridge.git
   cd HealthBridge

   # Fetch dependencies
   flutter pub get
   ```

3. **Static Analysis & Testing**:
   ```bash
   # Run static code analysis
   flutter analyze

   # Run automated unit tests
   flutter test
   ```

4. **Run Application**:
   ```bash
   # Launch application on connected device/emulator
   flutter run
   ```

5. **Build Release / Debug APK**:
   ```bash
   # Build Android Release APK
   flutter build apk --release
   ```
   *Output binary path:* `build/app/outputs/flutter-apk/app-release.apk`

---

## Libraries & Packages Used

```yaml
dependencies:
  flutter:
    sdk: flutter
  google_fonts: ^6.2.1   # Custom Google Typography (Inter/Poppins)
  intl: ^0.19.0          # Date formatting & time parsing utilities
  flutter_map: ^6.1.0    # Open-source interactive map rendering
  latlong2: ^0.9.0       # Geographic latitude/longitude coordinates
  url_launcher: ^6.3.0   # External URI launcher for Google Maps & phone calls
  flutter_launcher_icons: ^0.13.1 # Native app launcher icon generator
```

---

## Assumptions Made During Development

1. **Authentication Scope**: Patient authentication is validated locally against mock credentials stored in `assets/data/users.json` for patient persona **Sophia Martinez** (`patient@healthbridge.com` / `password123`).
2. **In-Memory State Persistence**: Newly booked appointments are appended to shared in-memory state (`AppointmentService`) during the active session and rendered in real-time on the **Timeline tab**.
3. **Insurance Co-Pay Standard**: In-network consultations assume 100% insurance coverage co-pay under the active *HealthBridge Gold* policy (#HBC-987456123), showing total due as `$0.00` with strikethrough fee decoration.
4. **Distance Units**: Proximity and distance metrics across doctor cards are strictly standardized in kilometers (`km`).
5. **Dynamic Time Slot Matching**: Pre-selected appointment date and time slots on the doctor profile page dynamically align with the specific `nextSlot` availability displayed on the Home Screen card.
6. **External Map Launcher**: Tapping "Open in Google Maps" launches external device maps via `url_launcher` using standard lat/long coordinates.
7. **System Back Navigation**: Android back button preserves normal Flutter navigator stack hierarchy without quitting the app unexpectedly.

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
   - Appointment detail summary card (`PHYSICIAN` header, Doctor name, specialty, date/time, bold `HealthBridge Medical Center` location title).
   - Payment summary breakdown card with strikethrough Consultation Fee decoration, insurance coverage, total due `$0.00`, and **`FULLY COVERED`** green pill badge.
   - Text message receipt details card (*"Send appointment receipt details to family or caregiver via text message"*).
   - UI-only preference toggles for Google Calendar auto-add & SMS reminders.
   - **Done** button returning to Home Screen, while Android system back button preserves normal stack navigation.

---

## Project Structure

```
HealthBridge/
├── HealthBridge_Application_Screenshots.pdf # PDF Application Documentation
├── assets/
│   ├── data/
│   │   ├── users.json
│   │   └── doctors.json
│   └── images/
│       ├── Healthbridge_logo.jpg
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

## Demo Credentials

| Username / Email | Password | Patient Name |
| :--- | :--- | :--- |
| `patient@healthbridge.com` | `password123` | Sophia Martinez |

---

## Verified Checklist

- [x] Clear project setup and execution steps (`flutter pub get`, `flutter run`, `flutter analyze`, `flutter test`)
- [x] Complete list of libraries and package dependencies (`google_fonts`, `intl`, `flutter_map`, `latlong2`, `url_launcher`, `flutter_launcher_icons`)
- [x] Explicit assumptions made during development
- [x] Static analysis (`flutter analyze`) passes with 0 errors
- [x] Unit tests (`flutter test`) pass 3/3 tests
- [x] Release APK compiled for testing (`app-release.apk`)
