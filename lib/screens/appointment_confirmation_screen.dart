import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_styles.dart';
import '../models/appointment_model.dart';
import '../widgets/custom_button.dart';

import '../services/appointment_service.dart';

class AppointmentConfirmationScreen extends StatefulWidget {
  final AppointmentModel appointment;

  const AppointmentConfirmationScreen({
    super.key,
    required this.appointment,
  });

  @override
  State<AppointmentConfirmationScreen> createState() => _AppointmentConfirmationScreenState();
}

class _AppointmentConfirmationScreenState extends State<AppointmentConfirmationScreen> {
  bool _autoAddToCalendar = true;
  bool _turnOffSmsReminders = false;

  @override
  void initState() {
    super.initState();
    AppointmentService.addAppointment(widget.appointment);
  }

  void _handleDone() {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    final appointment = widget.appointment;
    final doctor = appointment.doctor;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBackground,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            // ID Image from assets rendered on top-left of header
            Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                color: Color(0xFF37474F),
                shape: BoxShape.circle,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Image.asset(
                  "assets/images/id_badge.jpg",
                  width: 36,
                  height: 36,
                  fit: BoxFit.cover,
                  errorBuilder: (ctx, err, stack) => const Center(
                    child: Icon(Icons.description_outlined, color: Colors.white, size: 18),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              "HealthBridge",
              style: AppStyles.headingMedium.copyWith(color: AppColors.primaryDark, fontWeight: FontWeight.w700),
            ),
          ],
        ),
        actions: [
          // Transfer icon on top-right instead of share button
          const Icon(
            Icons.swap_horiz_rounded,
            color: AppColors.primary,
            size: 22,
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 10),

            // Gold/Green Checkmark Circle Banner Icon
            Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(
                color: Color(0xFFFFF8E1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(
                    color: Colors.amber,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check_rounded, color: Colors.white, size: 28),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Confirmation Text Header
            Text(
              "Booking Confirmed",
              textAlign: TextAlign.center,
              style: AppStyles.headingLarge.copyWith(fontSize: 22),
            ),
            const SizedBox(height: 6),
            Text(
              "Your appointment has been successfully\nscheduled.",
              textAlign: TextAlign.center,
              style: AppStyles.bodySubtle.copyWith(fontSize: 13),
            ),

            const SizedBox(height: 24),

            // Appointment Summary Details Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: AppStyles.cardDecoration,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Doctor Info Row with Doctor Image on top right
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              doctor.name,
                              style: AppStyles.headingSmall.copyWith(fontSize: 17),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              doctor.specialty,
                              style: AppStyles.bodySubtle,
                            ),
                          ],
                        ),
                      ),
                      // Doctor Photo on Top Right
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.softLavender,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: doctor.image.isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(
                                  doctor.image,
                                  width: 48,
                                  height: 48,
                                  fit: BoxFit.cover,
                                  errorBuilder: (ctx, err, stack) => const Center(
                                    child: Icon(Icons.person_rounded, color: AppColors.primary, size: 28),
                                  ),
                                ),
                              )
                            : const Center(
                                child: Icon(Icons.person_rounded, color: AppColors.primary, size: 28),
                              ),
                      ),
                    ],
                  ),

                  const Divider(height: 28, color: AppColors.dividerColor),

                  // Date & Time Row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.softLavender,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.calendar_today_rounded, color: AppColors.primary, size: 20),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Date & Time",
                              style: AppStyles.caption.copyWith(fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              appointment.dateFormatted,
                              style: AppStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                            ),
                            Text(
                              "${appointment.timeSlot} EST",
                              style: AppStyles.bodySubtle,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Location Row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.softLavender,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.location_on_rounded, color: AppColors.primary, size: 20),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Location",
                              style: AppStyles.caption.copyWith(fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              "HealthBridge Medical Center\n${doctor.officeAddress}",
                              style: AppStyles.bodyMedium.copyWith(height: 1.3),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Payment / Cost Breakdown Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: AppStyles.cardDecoration,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Consultation Fee", style: AppStyles.bodyMedium.copyWith(fontSize: 15, color: AppColors.textPrimary)),
                      Text(
                        "\$${doctor.consultationFee.toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 15,
                          color: Color(0xFF9E9E9E),
                          decoration: TextDecoration.lineThrough,
                          decorationColor: Color(0xFF9E9E9E),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Insurance Coverage", style: AppStyles.bodyMedium.copyWith(fontSize: 15, color: AppColors.textPrimary)),
                      Text(
                        "- \$${doctor.insuranceCoverage.toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24, color: AppColors.dividerColor),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Total Due", style: AppStyles.headingSmall.copyWith(fontSize: 18, fontWeight: FontWeight.bold)),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "\$0.00",
                            style: AppStyles.headingLarge.copyWith(
                              color: AppColors.primaryDark,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8F5E9),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              "FULLY COVERED",
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF2E7D32),
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Options / Preferences Card
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: AppStyles.cardDecoration,
              child: Column(
                children: [
                  SwitchListTile(
                    activeTrackColor: AppColors.primary,
                    contentPadding: EdgeInsets.zero,
                    title: Text("Automatically sync to my Google Calendar", style: AppStyles.bodyMedium.copyWith(fontSize: 13)),
                    value: _autoAddToCalendar,
                    onChanged: (val) => setState(() => _autoAddToCalendar = val),
                  ),
                  const Divider(height: 1, color: AppColors.dividerColor),
                  SwitchListTile(
                    activeTrackColor: AppColors.primary,
                    contentPadding: EdgeInsets.zero,
                    title: Text("Turn off duplicate SMS alerts", style: AppStyles.bodySubtle.copyWith(fontSize: 13)),
                    value: _turnOffSmsReminders,
                    onChanged: (val) => setState(() => _turnOffSmsReminders = val),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Send Appointment Receipt Details to Family or Caregiver Card
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFE8E0F0), width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.forum_outlined,
                    color: AppColors.primaryDark,
                    size: 28,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.chat_bubble_outline_rounded,
                              color: AppColors.textSubtle,
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                "Send appointment receipt details",
                                style: AppStyles.bodyMedium.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primaryDark,
                                  fontSize: 14,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Text(
                          "to family or caregiver via text",
                          textAlign: TextAlign.center,
                          style: AppStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryDark,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          "message",
                          textAlign: TextAlign.center,
                          style: AppStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryDark,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Done Button
            CustomButton(
              text: "Done",
              onPressed: _handleDone,
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
