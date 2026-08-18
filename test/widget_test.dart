import 'package:flutter_test/flutter_test.dart';
import 'package:speegile_assignment/models/user_model.dart';
import 'package:speegile_assignment/models/doctor_model.dart';
import 'package:speegile_assignment/models/appointment_model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('HealthBridge Models Test', () {
    test('UserModel serialization test', () {
      final user = UserModel.fromJson({
        'username': 'patient@healthbridge.com',
        'password': 'password123',
        'name': 'Sophia Martinez'
      });

      expect(user.username, 'patient@healthbridge.com');
      expect(user.password, 'password123');
      expect(user.name, 'Sophia Martinez');
    });

    test('DoctorModel serialization test', () {
      final doctor = DoctorModel.fromJson({
        'id': 'doc_1',
        'name': 'Dr. Anjali Rao, MD',
        'specialty': 'Cardiology Specialist',
        'category': 'Specialists',
        'statusBadge': 'Accepting New Patients',
        'rating': 4.9,
        'reviewCount': 53,
        'distance': '1.2 km',
        'nextSlot': 'Available Wednesday at 10:30 AM',
        'inNetwork': true,
        'topRated': true,
        'bio': 'Test Bio',
        'expertiseTags': ['Cardiology'],
        'phone': '+1 (555) 234-5678',
        'officeAddress': '123 Health Plaza',
        'consultationFee': 240.0,
        'insuranceCoverage': 240.0,
        'availableDates': [
          {
            'dayOfWeek': 'Mon',
            'dateFormatted': 'OCT 23',
            'slots': ['09:30 AM']
          }
        ]
      });

      expect(doctor.id, 'doc_1');
      expect(doctor.name, 'Dr. Anjali Rao, MD');
      expect(doctor.rating, 4.9);
      expect(doctor.availableDates.length, 1);
      expect(doctor.availableDates.first.slots.first, '09:30 AM');
    });

    test('AppointmentModel creation test', () {
      final doctor = DoctorModel.fromJson({
        'id': 'doc_1',
        'name': 'Dr. Anjali Rao, MD',
        'specialty': 'Cardiology Specialist',
        'category': 'Specialists',
        'statusBadge': 'Accepting New Patients',
        'rating': 4.9,
        'reviewCount': 53,
        'distance': '1.2 km',
        'nextSlot': 'Available Wednesday at 10:30 AM',
        'inNetwork': true,
        'topRated': true,
        'bio': 'Test Bio',
        'expertiseTags': ['Cardiology'],
        'phone': '+1 (555) 234-5678',
        'officeAddress': '123 Health Plaza',
        'consultationFee': 240.0,
        'insuranceCoverage': 240.0,
        'availableDates': []
      });

      final appointment = AppointmentModel(
        doctor: doctor,
        dateFormatted: 'Mon, OCT 23, 2026',
        timeSlot: '09:30 AM',
        totalDue: 0.0,
      );

      expect(appointment.doctor.name, 'Dr. Anjali Rao, MD');
      expect(appointment.dateFormatted, 'Mon, OCT 23, 2026');
      expect(appointment.timeSlot, '09:30 AM');
      expect(appointment.totalDue, 0.0);
    });
  });
}
