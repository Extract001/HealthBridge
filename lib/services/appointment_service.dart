import '../models/appointment_model.dart';
import '../models/doctor_model.dart';

class AppointmentService {
  static final List<AppointmentModel> _bookedAppointments = [];

  static bool _initialized = false;

  static void _initDefault() {
    if (_initialized) return;
    _initialized = true;

    // Default pre-populated appointment for initial state
    final defaultDoctor = DoctorModel(
      id: "doc_1",
      name: "Dr. Amar Rao, MD",
      specialty: "Primary Care",
      category: "Primary Care",
      statusBadge: "Accepting New Patients",
      rating: 4.9,
      reviewCount: 53,
      distance: "1.2 km",
      nextSlot: "Available Tuesday at 08:30 AM",
      inNetwork: true,
      topRated: true,
      latitude: 40.730610,
      longitude: -73.935242,
      image: "assets/images/dr_amar_rao.jpg",
      bio: "Board-certified internist specializing in holistic preventative care.",
      expertiseTags: ["Primary Care", "15+ Yrs Exp."],
      acceptedInsurance: ["BLUE CROSS", "AETNA GOLD"],
      phone: "+1 (555) 123-4567",
      officeAddress: "1221 Health Plaza, Suite 400, New York, NY 10021",
      consultationFee: 240.0,
      insuranceCoverage: 240.0,
      recommendRate: "98%",
      avgWaitTime: "Avg 8 mins",
      availableDates: [],
    );

    _bookedAppointments.add(
      AppointmentModel(
        doctor: defaultDoctor,
        dateFormatted: "TUE, OCT 24, 2026",
        timeSlot: "08:30 AM",
        totalDue: 0.0,
      ),
    );
  }

  static List<AppointmentModel> getBookedAppointments() {
    _initDefault();
    return List.unmodifiable(_bookedAppointments);
  }

  static void addAppointment(AppointmentModel appointment) {
    _initDefault();
    _bookedAppointments.insert(0, appointment); // Insert newest at top
  }
}
