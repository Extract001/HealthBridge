import '../models/appointment_model.dart';

class AppointmentService {
  static final List<AppointmentModel> _bookedAppointments = [];

  static List<AppointmentModel> getBookedAppointments() {
    return List.unmodifiable(_bookedAppointments);
  }

  static void addAppointment(AppointmentModel appointment) {
    _bookedAppointments.insert(0, appointment);
  }
}
