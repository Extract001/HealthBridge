import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_styles.dart';
import '../models/appointment_model.dart';
import '../models/doctor_model.dart';
import '../services/appointment_service.dart';
import '../services/doctor_service.dart';
import '../widgets/custom_bottom_nav.dart';
import '../widgets/doctor_card.dart';
import '../widgets/filter_chip_bar.dart';
import '../widgets/urgent_care_banner.dart';
import 'about_doctor_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  final String userName;

  const HomeScreen({
    super.key,
    this.userName = "Sophia Martinez",
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentNavIndex = 2; // Default to Search tab
  String _selectedCategory = "All";

  // Advanced Filter Modal Options
  bool _filterInNetworkOnly = false;
  double _minRatingFilter = 0.0;
  String _sortBy = "Distance"; // "Distance", "Rating", "Reviews"

  List<DoctorModel> _allDoctors = [];
  bool _isLoading = true;

  final List<String> _categories = [
    "All",
    "In-Network",
    "Nearest to Me",
    "Specialists",
    "Primary Care",
  ];

  @override
  void initState() {
    super.initState();
    _loadDoctors();
  }

  void _loadDoctors() async {
    final doctors = await DoctorService.getDoctors();
    if (!mounted) return;
    setState(() {
      _allDoctors = doctors;
      _isLoading = false;
    });
  }

  List<DoctorModel> get _filteredDoctors {
    List<DoctorModel> list = _allDoctors.where((doctor) {
      if (_selectedCategory == "In-Network" && !doctor.inNetwork) return false;
      if (_selectedCategory == "Specialists" && doctor.category != "Specialists") return false;
      if (_selectedCategory == "Primary Care" && doctor.category != "Primary Care") return false;

      if (_filterInNetworkOnly && !doctor.inNetwork) return false;
      if (doctor.rating < _minRatingFilter) return false;

      return true;
    }).toList();

    if (_selectedCategory == "Nearest to Me" || _sortBy == "Distance") {
      list.sort((a, b) {
        final double distA = double.tryParse(a.distance.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0.0;
        final double distB = double.tryParse(b.distance.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0.0;
        return distA.compareTo(distB);
      });
    } else if (_sortBy == "Rating") {
      list.sort((a, b) => b.rating.compareTo(a.rating));
    } else if (_sortBy == "Reviews") {
      list.sort((a, b) => b.reviewCount.compareTo(a.reviewCount));
    }

    return list;
  }

  void _navigateToAboutDoctor(DoctorModel doctor) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AboutDoctorScreen(doctor: doctor),
      ),
    ).then((_) {
      setState(() {});
    });
  }

  void _showFilterBottomSheet() {
    bool tempInNetwork = _filterInNetworkOnly;
    double tempMinRating = _minRatingFilter;
    String tempSortBy = _sortBy;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(28),
                  topRight: Radius.circular(28),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Filter & Sort Doctors",
                        style: AppStyles.headingMedium.copyWith(fontSize: 20),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const Divider(height: 20),
                  Text("Sort By", style: AppStyles.headingSmall.copyWith(fontSize: 15)),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    children: ["Distance", "Rating", "Reviews"].map((sortOption) {
                      final isSelected = tempSortBy == sortOption;
                      return ChoiceChip(
                        label: Text(sortOption),
                        selected: isSelected,
                        selectedColor: AppColors.primary,
                        backgroundColor: AppColors.cardLight,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : AppColors.textPrimary,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                        onSelected: (selected) {
                          if (selected) {
                            setModalState(() {
                              tempSortBy = sortOption;
                            });
                          }
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  SwitchListTile(
                    activeTrackColor: AppColors.primary,
                    contentPadding: EdgeInsets.zero,
                    title: Text("In-Network Only", style: AppStyles.headingSmall.copyWith(fontSize: 15)),
                    subtitle: Text("Only show doctors accepting your insurance", style: AppStyles.bodySubtle),
                    value: tempInNetwork,
                    onChanged: (val) {
                      setModalState(() {
                        tempInNetwork = val;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  Text("Minimum Rating", style: AppStyles.headingSmall.copyWith(fontSize: 15)),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    children: [
                      {"label": "All Ratings", "val": 0.0},
                      {"label": "4.5+ Stars", "val": 4.5},
                      {"label": "4.8+ Stars", "val": 4.8},
                    ].map((ratingOpt) {
                      final double ratingVal = ratingOpt["val"] as double;
                      final isSelected = tempMinRating == ratingVal;

                      return ChoiceChip(
                        label: Text(ratingOpt["label"] as String),
                        selected: isSelected,
                        selectedColor: AppColors.primary,
                        backgroundColor: AppColors.cardLight,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : AppColors.textPrimary,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                        onSelected: (selected) {
                          if (selected) {
                            setModalState(() {
                              tempMinRating = ratingVal;
                            });
                          }
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 28),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            side: const BorderSide(color: AppColors.borderLight),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                          onPressed: () {
                            setModalState(() {
                              tempInNetwork = false;
                              tempMinRating = 0.0;
                              tempSortBy = "Distance";
                            });
                          },
                          child: const Text("Reset All", style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                          onPressed: () {
                            setState(() {
                              _filterInNetworkOnly = tempInNetwork;
                              _minRatingFilter = tempMinRating;
                              _sortBy = tempSortBy;
                            });
                            Navigator.pop(context);
                          },
                          child: const Text("Apply Filters", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // --- PERSONAL INFORMATION MODAL ---
  void _showPersonalInformationSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(28),
              topRight: Radius.circular(28),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Personal Information",
                    style: AppStyles.headingMedium.copyWith(fontSize: 20),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(height: 20),
              _buildProfileDetailRow(Icons.person_rounded, "Full Name", widget.userName),
              _buildProfileDetailRow(Icons.email_rounded, "Email Address", "patient@healthbridge.com"),
              _buildProfileDetailRow(Icons.phone_rounded, "Phone Number", "+1 (555) 987-6543"),
              _buildProfileDetailRow(Icons.cake_rounded, "Date of Birth", "Oct 14, 1992 (33 yrs)"),
              _buildProfileDetailRow(Icons.female_rounded, "Gender", "Female"),
              _buildProfileDetailRow(Icons.bloodtype_rounded, "Blood Type", "O Positive (O+)"),
              _buildProfileDetailRow(Icons.home_rounded, "Residential Address", "742 Evergreen Terrace, Apt 4B\nNew York, NY 10001"),
              _buildProfileDetailRow(Icons.contact_phone_rounded, "Emergency Contact", "David Martinez (+1 555 888-9999)"),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProfileDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.softLavender,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.primary, size: 18),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppStyles.caption.copyWith(color: AppColors.textSubtle, fontSize: 11)),
                const SizedBox(height: 2),
                Text(value, style: AppStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600, fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- SEARCH (DOCTORS & SPECIALISTS) TAB VIEW ---
  Widget _buildDoctorsTabView() {
    final doctors = _filteredDoctors;

    return Column(
      children: [
        const SizedBox(height: 10),
        // Category Filter Pills Bar
        FilterChipBar(
          categories: _categories,
          selectedCategory: _selectedCategory,
          onSelected: (cat) {
            setState(() {
              _selectedCategory = cat;
            });
          },
        ),
        const SizedBox(height: 14),

        // Sub-header Row (Results count & Sort option)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${doctors.length} Results for ${_selectedCategory == 'All' ? 'Specialists' : _selectedCategory}",
                style: AppStyles.headingSmall.copyWith(fontSize: 15),
              ),
              GestureDetector(
                onTap: _showFilterBottomSheet,
                child: Row(
                  children: [
                    Text(
                      "SORT BY: ",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textSubtle,
                      ),
                    ),
                    Text(
                      _sortBy,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Doctor List
        Expanded(
          child: doctors.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search_off_rounded, size: 54, color: AppColors.textSubtle),
                      const SizedBox(height: 12),
                      Text("No doctors found", style: AppStyles.headingSmall),
                      const SizedBox(height: 4),
                      Text("Try changing filter options.", style: AppStyles.bodySubtle),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  itemCount: doctors.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 3) {
                      return UrgentCareBanner(
                        onGetDirections: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Opening maps directions for Urgent Care..."),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                      );
                    }

                    final doctorIndex = index > 3 ? index - 1 : index;
                    if (doctorIndex >= doctors.length) return const SizedBox.shrink();

                    final doctor = doctors[doctorIndex];
                    return DoctorCard(
                      doctor: doctor,
                      onTap: () => _navigateToAboutDoctor(doctor),
                    );
                  },
                ),
        ),
      ],
    );
  }

  // --- TAB 1: COVERAGE TAB VIEW ---
  Widget _buildCoverageTabView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Health Coverage & Policy", style: AppStyles.headingMedium),
          const SizedBox(height: 4),
          Text("Manage your insurance policy, network, and claims", style: AppStyles.bodySubtle),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primaryDark, AppColors.primary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("HealthBridge Gold", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text("ACTIVE", style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text("POLICY NUMBER", style: TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                const Text("HBC-987456123", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700, letterSpacing: 1.0)),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("COVERAGE SUM", style: TextStyle(color: Colors.white70, fontSize: 10)),
                        Text("\$500,000", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("MEMBER NAME", style: TextStyle(color: Colors.white70, fontSize: 10)),
                        Text(widget.userName, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: AppStyles.cardDecoration,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Policy Benefits Summary", style: AppStyles.headingSmall),
                const Divider(height: 20),
                _buildBenefitItem(Icons.verified_rounded, "100% Consultation Coverage", "In-network consultations co-pay fully covered"),
                _buildBenefitItem(Icons.medical_services_rounded, "Diagnostic & Lab Test Benefit", "Up to \$1,500 yearly allowance"),
                _buildBenefitItem(Icons.local_pharmacy_rounded, "Pharmacy & Prescription Benefit", "20% discount on partner pharmacies"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitItem(IconData icon, String title, String desc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
                Text(desc, style: AppStyles.bodySubtle.copyWith(fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- TAB 0: TIMELINE (APPOINTMENTS) TAB VIEW DYNAMIC RENDERING ---
  Widget _buildAppointmentsTabView() {
    final bookedAppointments = AppointmentService.getBookedAppointments();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Timeline & Appointments", style: AppStyles.headingMedium),
          const SizedBox(height: 4),
          Text("${bookedAppointments.length} Scheduled consultations & visit history", style: AppStyles.bodySubtle),
          const SizedBox(height: 16),
          if (bookedAppointments.isEmpty)
            Container(
              padding: const EdgeInsets.all(32),
              decoration: AppStyles.cardDecoration,
              child: Center(
                child: Column(
                  children: [
                    const Icon(Icons.event_available_rounded, size: 48, color: AppColors.textSubtle),
                    const SizedBox(height: 12),
                    Text("No Appointments Scheduled", style: AppStyles.headingSmall),
                    const SizedBox(height: 4),
                    Text("Book an appointment with any doctor to see it listed here.", style: AppStyles.bodySubtle, textAlign: TextAlign.center),
                  ],
                ),
              ),
            )
          else
            Column(
              children: bookedAppointments.map((appt) => _buildAppointmentCard(appt)).toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildAppointmentCard(AppointmentModel appointment) {
    final doctor = appointment.doctor;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: AppStyles.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: AppColors.softLavender, borderRadius: BorderRadius.circular(6)),
                child: const Text("UPCOMING", style: TextStyle(color: AppColors.primaryDark, fontSize: 11, fontWeight: FontWeight.bold)),
              ),
              Text(appointment.dateFormatted, style: AppStyles.caption.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(color: AppColors.softLavender, borderRadius: BorderRadius.circular(12)),
                child: doctor.image.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          doctor.image,
                          width: 48,
                          height: 48,
                          fit: BoxFit.cover,
                          errorBuilder: (ctx, err, stack) => const Center(
                            child: Icon(Icons.person_rounded, color: AppColors.primary, size: 30),
                          ),
                        ),
                      )
                    : const Center(
                        child: Icon(Icons.person_rounded, color: AppColors.primary, size: 30),
                      ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(doctor.name, style: AppStyles.headingSmall.copyWith(fontSize: 16)),
                    Text(doctor.specialty, style: AppStyles.bodySubtle),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: 24),
          Row(
            children: [
              const Icon(Icons.access_time_rounded, color: AppColors.textSecondary, size: 16),
              const SizedBox(width: 6),
              Text(appointment.timeSlot, style: AppStyles.bodyMedium),
              const Spacer(),
              const Icon(Icons.location_on_outlined, color: AppColors.textSecondary, size: 16),
              const SizedBox(width: 4),
              Text(doctor.officeAddress.contains(',') ? doctor.officeAddress.split(',').last.trim() : "New York, NY", style: AppStyles.bodySubtle),
            ],
          ),
        ],
      ),
    );
  }

  // --- TAB 3: PROFILE TAB VIEW ---
  Widget _buildProfileTabView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Account Profile", style: AppStyles.headingMedium),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: AppStyles.cardDecoration,
            child: Row(
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: const BoxDecoration(
                    color: AppColors.softLavender,
                    shape: BoxShape.circle,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(27),
                    child: Image.asset(
                      "assets/images/user_profile.jpg",
                      width: 54,
                      height: 54,
                      fit: BoxFit.cover,
                      errorBuilder: (ctx, err, stack) => const Center(
                        child: Text("SM", style: TextStyle(color: AppColors.primary, fontSize: 20, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.userName, style: AppStyles.headingSmall.copyWith(fontSize: 18)),
                      const SizedBox(height: 2),
                      Text("patient@healthbridge.com", style: AppStyles.bodySubtle),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            decoration: AppStyles.cardDecoration,
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.person_outline_rounded, color: AppColors.primary),
                  title: const Text("Personal Information"),
                  subtitle: const Text("View personal details & medical profile"),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: _showPersonalInformationSheet,
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.tune_rounded, color: AppColors.primary),
                  title: const Text("Filter & Preference Settings"),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: _showFilterBottomSheet,
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.logout_rounded, color: AppColors.errorRed),
                  title: const Text("Log Out", style: TextStyle(color: AppColors.errorRed, fontWeight: FontWeight.w600)),
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBackground,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                color: AppColors.softLavender,
                shape: BoxShape.circle,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Image.asset(
                  "assets/images/user_profile.jpg",
                  width: 36,
                  height: 36,
                  fit: BoxFit.cover,
                  errorBuilder: (ctx, err, stack) => const Center(
                    child: Icon(Icons.person_rounded, color: AppColors.primary, size: 22),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              "HealthBridge",
              style: AppStyles.headingMedium.copyWith(
                color: AppColors.primaryDark,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        actions: [
          const Icon(
            Icons.swap_horiz_rounded,
            color: AppColors.primary,
            size: 22,
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : IndexedStack(
              index: _currentNavIndex,
              children: [
                _buildAppointmentsTabView(), // 0: Timeline
                _buildCoverageTabView(),     // 1: Coverage
                _buildDoctorsTabView(),      // 2: Search (Doctors & Specialists)
                _buildProfileTabView(),      // 3: Profile
              ],
            ),
      bottomNavigationBar: CustomBottomNav(
        selectedIndex: _currentNavIndex,
        onItemTapped: (index) {
          setState(() {
            _currentNavIndex = index;
          });
        },
      ),
    );
  }
}
