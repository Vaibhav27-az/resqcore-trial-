class UserProfile {
  final String fullName;
  final String phoneNumber;
  final String email;
  final String bloodGroup;
  final String emergencyContactName;
  final String emergencyContactPhone;
  final String address;
  final String sector;
  final String medicalNotes;
  final bool isRegistered;

  const UserProfile({
    required this.fullName,
    required this.phoneNumber,
    required this.email,
    required this.bloodGroup,
    required this.emergencyContactName,
    required this.emergencyContactPhone,
    required this.address,
    required this.sector,
    required this.medicalNotes,
    this.isRegistered = true,
  });

  UserProfile copyWith({
    String? fullName,
    String? phoneNumber,
    String? email,
    String? bloodGroup,
    String? emergencyContactName,
    String? emergencyContactPhone,
    String? address,
    String? sector,
    String? medicalNotes,
    bool? isRegistered,
  }) {
    return UserProfile(
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      emergencyContactName: emergencyContactName ?? this.emergencyContactName,
      emergencyContactPhone: emergencyContactPhone ?? this.emergencyContactPhone,
      address: address ?? this.address,
      sector: sector ?? this.sector,
      medicalNotes: medicalNotes ?? this.medicalNotes,
      isRegistered: isRegistered ?? this.isRegistered,
    );
  }
}
