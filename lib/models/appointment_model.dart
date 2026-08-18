import 'doctor_model.dart';

class AppointmentModel {
  final DoctorModel doctor;
  final String dateFormatted;
  final String timeSlot;
  final double totalDue;

  AppointmentModel({
    required this.doctor,
    required this.dateFormatted,
    required this.timeSlot,
    this.totalDue = 0.0,
  });
}
