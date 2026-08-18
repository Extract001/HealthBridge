import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/app_colors.dart';
import '../constants/app_styles.dart';
import '../models/appointment_model.dart';
import '../models/doctor_model.dart';
import '../widgets/custom_button.dart';
import 'appointment_confirmation_screen.dart';

class AboutDoctorScreen extends StatefulWidget {
  final DoctorModel doctor;

  const AboutDoctorScreen({
    super.key,
    required this.doctor,
  });

  @override
  State<AboutDoctorScreen> createState() => _AboutDoctorScreenState();
}

class _AboutDoctorScreenState extends State<AboutDoctorScreen> {
  int _selectedDateIndex = 0; // Default to index 0 matching doctor's nextSlot
  String? _selectedTimeSlot;

  @override
  void initState() {
    super.initState();
    if (widget.doctor.availableDates.isNotEmpty) {
      _selectedDateIndex = 0;
      final dateObj = widget.doctor.availableDates.first;
      if (dateObj.slots.isNotEmpty) {
        _selectedTimeSlot = dateObj.slots.first;
      }
    }
  }

  void _handleBookAppointment() {
    if (_selectedTimeSlot == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select an available appointment time slot.")),
      );
      return;
    }

    final selectedDateObj = widget.doctor.availableDates[_selectedDateIndex];
    final currentYear = DateTime.now().year;
    final fullDateString = "${selectedDateObj.dayOfWeek}, ${selectedDateObj.dateFormatted}, $currentYear";

    final appointment = AppointmentModel(
      doctor: widget.doctor,
      dateFormatted: fullDateString,
      timeSlot: _selectedTimeSlot!,
      totalDue: 0.0,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AppointmentConfirmationScreen(appointment: appointment),
      ),
    );
  }

  Future<void> _openGoogleMaps(double lat, double lng, String label) async {
    final Uri googleMapsAppUri = Uri.parse("geo:$lat,$lng?q=$lat,$lng(${Uri.encodeComponent(label)})");
    final Uri googleMapsWebUri = Uri.parse("https://www.google.com/maps/search/?api=1&query=$lat,$lng");

    try {
      if (await canLaunchUrl(googleMapsAppUri)) {
        await launchUrl(googleMapsAppUri, mode: LaunchMode.externalApplication);
        return;
      }
    } catch (_) {}

    try {
      if (await canLaunchUrl(googleMapsWebUri)) {
        await launchUrl(googleMapsWebUri, mode: LaunchMode.externalApplication);
        return;
      }
      await launchUrl(googleMapsWebUri, mode: LaunchMode.externalApplication);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Opening map for ${widget.doctor.name}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final doctor = widget.doctor;
    final LatLng doctorLocation = LatLng(doctor.latitude, doctor.longitude);

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "HealthBridge",
          style: AppStyles.headingMedium.copyWith(color: AppColors.primaryDark),
        ),
        centerTitle: false,
        actions: [
          const Icon(
            Icons.swap_horiz_rounded,
            color: AppColors.primary,
            size: 20,
          ),
          const SizedBox(width: 12),
          Center(
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primary, width: 1.5),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Image.asset(
                  "assets/images/men_smile.jpg",
                  width: 36,
                  height: 36,
                  fit: BoxFit.cover,
                  errorBuilder: (ctx, err, stack) => const Center(
                    child: Icon(Icons.person_rounded, color: AppColors.primary, size: 20),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Doctor Header Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: AppStyles.cardDecoration,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Photo Avatar
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: doctor.image.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.asset(
                              doctor.image,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                              errorBuilder: (ctx, err, stack) => const Center(
                                child: Icon(Icons.person_rounded, color: AppColors.primary, size: 54),
                              ),
                            ),
                          )
                        : const Center(
                            child: Icon(Icons.person_rounded, color: AppColors.primary, size: 54),
                          ),
                  ),
                  const SizedBox(height: 16),

                  // Doctor Name
                  Text(
                    doctor.name,
                    style: AppStyles.headingLarge.copyWith(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primaryDark,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Badges (Primary Care & 15+ Yrs Exp.)
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: doctor.expertiseTags.map((tag) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: tag == "Primary Care" ? AppColors.softLavender : const Color(0xFFEEEEEE),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          tag,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: tag == "Primary Care" ? AppColors.primaryDark : AppColors.textSecondary,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 14),

                  // Bio Text
                  Text(
                    doctor.bio,
                    style: AppStyles.bodyMedium.copyWith(
                      color: const Color(0xFF4A4A4A),
                      height: 1.45,
                      fontSize: 13.5,
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Accepted Insurance Section
                  Text(
                    "ACCEPTED INSURANCE",
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                      color: AppColors.textSubtle,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: doctor.acceptedInsurance.map((ins) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F5E9),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          ins,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF2E7D32),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Available Appointments Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  "Available Appointments",
                  style: AppStyles.headingSmall.copyWith(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Select a time to book",
                  style: AppStyles.bodySubtle.copyWith(fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Date Selector Columns Strip with Time Slots (Whole Card Clickable)
            if (doctor.availableDates.isNotEmpty)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(doctor.availableDates.length, (index) {
                    final dateObj = doctor.availableDates[index];
                    final isSelected = index == _selectedDateIndex;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedDateIndex = index;
                          if (dateObj.slots.isNotEmpty && (!isSelected || _selectedTimeSlot == null || !dateObj.slots.contains(_selectedTimeSlot))) {
                            _selectedTimeSlot = dateObj.slots.first;
                          }
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 125,
                        margin: const EdgeInsets.only(right: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected ? AppColors.primary : AppColors.borderLight,
                            width: isSelected ? 2 : 1,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: AppColors.primary.withValues(alpha: 0.15),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  )
                                ]
                              : null,
                        ),
                        child: Column(
                          children: [
                            Text(
                              dateObj.dayOfWeek,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: isSelected ? AppColors.primary : AppColors.textSubtle,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              dateObj.dateFormatted,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: isSelected ? AppColors.primaryDark : AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 12),
                            // Time slots for this column
                            Column(
                              children: dateObj.slots.map((slot) {
                                final isSlotSelected = isSelected && slot == _selectedTimeSlot;

                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedDateIndex = index;
                                      _selectedTimeSlot = slot;
                                    });
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    margin: const EdgeInsets.only(bottom: 8),
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                    decoration: BoxDecoration(
                                      color: isSlotSelected ? AppColors.primaryDark : const Color(0xFFF4F3F8),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      slot,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: isSlotSelected ? FontWeight.w800 : FontWeight.w600,
                                        color: isSlotSelected ? Colors.white : AppColors.textPrimary,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),

            const SizedBox(height: 24),

            // Call Front Desk Banner Box (Clean Static Visual Component)
            Container(
              padding: const EdgeInsets.all(18),
              decoration: AppStyles.lavenderBoxDecoration.copyWith(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.phone_in_talk_rounded, color: AppColors.primary, size: 24),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Prefer to book over the phone?",
                          style: AppStyles.headingSmall.copyWith(fontSize: 14, color: AppColors.primaryDark),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Call Dr. Rao's Front Desk\nDirectly at ${doctor.phone}",
                          style: AppStyles.bodySubtle.copyWith(fontSize: 12.5, color: const Color(0xFF5C5C7B)),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "Open Mon-Fri, 8:00 AM - 5:00 PM EST",
                          style: AppStyles.caption.copyWith(fontSize: 11, color: AppColors.textSubtle),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Office Location Card
            Text(
              "Office Location",
              style: AppStyles.headingSmall.copyWith(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: AppStyles.cardDecoration,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.location_on_outlined, color: AppColors.primary, size: 22),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          doctor.officeAddress,
                          style: AppStyles.bodyMedium.copyWith(fontSize: 13.5, height: 1.4),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Live Interactive Map View Widget
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: SizedBox(
                      height: 180,
                      width: double.infinity,
                      child: Stack(
                        children: [
                          FlutterMap(
                            options: MapOptions(
                              initialCenter: doctorLocation,
                              initialZoom: 14.0,
                            ),
                            children: [
                              TileLayer(
                                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                userAgentPackageName: 'com.example.speegile_assignment',
                              ),
                              MarkerLayer(
                                markers: [
                                  Marker(
                                    point: doctorLocation,
                                    width: 50,
                                    height: 50,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: AppColors.primaryDark,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppColors.primaryDark.withValues(alpha: 0.4),
                                            blurRadius: 10,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: const Icon(
                                        Icons.local_hospital_rounded,
                                        color: Colors.white,
                                        size: 26,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          // Open in Google Maps Button Overlay
                          Positioned(
                            bottom: 10,
                            right: 10,
                            child: Material(
                              color: AppColors.primaryDark,
                              borderRadius: BorderRadius.circular(20),
                              child: InkWell(
                                onTap: () => _openGoogleMaps(doctor.latitude, doctor.longitude, doctor.name),
                                borderRadius: BorderRadius.circular(20),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.map_rounded, color: Colors.white, size: 16),
                                      const SizedBox(width: 6),
                                      Text(
                                        "Open in Google Maps",
                                        style: AppStyles.caption.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Scorecard Section
            Container(
              padding: const EdgeInsets.all(18),
              decoration: AppStyles.cardDecoration,
              child: Column(
                children: [
                  _buildScoreItem(Icons.verified_user_outlined, "Verified Care", isBold: true),
                  const Divider(height: 20),
                  _buildScoreItem(Icons.star_outline_rounded, "${doctor.rating} / 5.0 Patient Rating"),
                  const Divider(height: 20),
                  _buildScoreItem(Icons.thumb_up_alt_outlined, "${doctor.recommendRate} Recommend ${doctor.name.split(',')[0]}"),
                  const Divider(height: 20),
                  _buildScoreItem(Icons.access_time_rounded, "Low wait times (${doctor.avgWaitTime})"),
                ],
              ),
            ),

            const SizedBox(height: 28),
          ],
        ),
      ),
      // Sticky Bottom "Book Appointment" Button
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: AppColors.borderLight)),
        ),
        child: CustomButton(
          text: "Book Appointment",
          onPressed: _handleBookAppointment,
        ),
      ),
    );
  }

  Widget _buildScoreItem(IconData icon, String label, {bool isBold = false}) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFFD97706), size: 20),
        const SizedBox(width: 12),
        Text(
          label,
          style: TextStyle(
            fontSize: 13.5,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
            color: isBold ? AppColors.primaryDark : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
