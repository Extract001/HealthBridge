class DoctorDateSlot {
  final String dayOfWeek;
  final String dateFormatted;
  final List<String> slots;

  DoctorDateSlot({
    required this.dayOfWeek,
    required this.dateFormatted,
    required this.slots,
  });

  factory DoctorDateSlot.fromJson(Map<String, dynamic> json) {
    return DoctorDateSlot(
      dayOfWeek: json['dayOfWeek'] ?? '',
      dateFormatted: json['dateFormatted'] ?? '',
      slots: List<String>.from(json['slots'] ?? []),
    );
  }
}

class DoctorModel {
  final String id;
  final String name;
  final String specialty;
  final String category;
  final String statusBadge;
  final double rating;
  final int reviewCount;
  final String distance;
  final String nextSlot;
  final bool inNetwork;
  final bool topRated;
  final double latitude;
  final double longitude;
  final String bio;
  final String image;
  final List<String> expertiseTags;
  final List<String> acceptedInsurance;
  final String phone;
  final String officeAddress;
  final double consultationFee;
  final double insuranceCoverage;
  final String recommendRate;
  final String avgWaitTime;
  final List<DoctorDateSlot> availableDates;

  DoctorModel({
    required this.id,
    required this.name,
    required this.specialty,
    required this.category,
    required this.statusBadge,
    required this.rating,
    required this.reviewCount,
    required this.distance,
    required this.nextSlot,
    required this.inNetwork,
    required this.topRated,
    required this.latitude,
    required this.longitude,
    required this.bio,
    required this.image,
    required this.expertiseTags,
    required this.acceptedInsurance,
    required this.phone,
    required this.officeAddress,
    required this.consultationFee,
    required this.insuranceCoverage,
    required this.recommendRate,
    required this.avgWaitTime,
    required this.availableDates,
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      specialty: json['specialty'] ?? '',
      category: json['category'] ?? '',
      statusBadge: json['statusBadge'] ?? 'Accepting New Patients',
      rating: (json['rating'] as num?)?.toDouble() ?? 4.9,
      reviewCount: json['reviewCount'] ?? 0,
      distance: (json['distance'] ?? '').toString().replaceAll('miles', 'km').replaceAll('mile', 'km'),
      nextSlot: json['nextSlot'] ?? '',
      inNetwork: json['inNetwork'] ?? true,
      topRated: json['topRated'] ?? false,
      latitude: (json['latitude'] as num?)?.toDouble() ?? 40.730610,
      longitude: (json['longitude'] as num?)?.toDouble() ?? -73.935242,
      bio: json['bio'] ?? '',
      image: json['image'] ?? '',
      expertiseTags: List<String>.from(json['expertiseTags'] ?? []),
      acceptedInsurance: List<String>.from(json['acceptedInsurance'] ?? ["BLUE CROSS", "AETNA GOLD", "UNITEDHEALTH", "CIGNA PPO"]),
      phone: json['phone'] ?? '+1 (555) 123-4567',
      officeAddress: json['officeAddress'] ?? '',
      consultationFee: (json['consultationFee'] as num?)?.toDouble() ?? 240.0,
      insuranceCoverage: (json['insuranceCoverage'] as num?)?.toDouble() ?? 240.0,
      recommendRate: json['recommendRate'] ?? '98%',
      avgWaitTime: json['avgWaitTime'] ?? 'Avg 8 mins',
      availableDates: (json['availableDates'] as List? ?? [])
          .map((e) => DoctorDateSlot.fromJson(e))
          .toList(),
    );
  }
}
