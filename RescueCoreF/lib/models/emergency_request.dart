import 'package:flutter/material.dart';
import 'emergency_type.dart';

enum RequestStatus {
  inProgress,
  pending,
  awaitingVerification,
  assigned,
  resolved;

  String get label {
    switch (this) {
      case RequestStatus.inProgress:
        return 'In progress';
      case RequestStatus.pending:
        return 'Pending';
      case RequestStatus.awaitingVerification:
        return 'Awaiting verification';
      case RequestStatus.assigned:
        return 'Assigned';
      case RequestStatus.resolved:
        return 'Resolved';
    }
  }

  Color get dotColor {
    switch (this) {
      case RequestStatus.inProgress:
        return const Color(0xFF60A5FA);
      case RequestStatus.pending:
      case RequestStatus.awaitingVerification:
        return const Color(0xFFFBBF24);
      case RequestStatus.assigned:
        return const Color(0xFFADC6FF);
      case RequestStatus.resolved:
        return const Color(0xFF34D399);
    }
  }

  Color get textColor {
    switch (this) {
      case RequestStatus.inProgress:
        return const Color(0xFF60A5FA);
      case RequestStatus.pending:
      case RequestStatus.awaitingVerification:
        return const Color(0xFFFBBF24);
      case RequestStatus.assigned:
        return const Color(0xFFADC6FF);
      case RequestStatus.resolved:
        return const Color(0xFF34D399);
    }
  }

  Color get backgroundColor {
    switch (this) {
      case RequestStatus.inProgress:
        return const Color(0x332563EB);
      case RequestStatus.pending:
      case RequestStatus.awaitingVerification:
        return const Color(0x33F59E0B);
      case RequestStatus.assigned:
        return const Color(0x330566D9);
      case RequestStatus.resolved:
        return const Color(0x3310B981);
    }
  }
}

class EmergencyRequest {
  final String id;
  final String title;
  final EmergencyType type;
  final RequestStatus status;
  final String timeLabel;
  final String location;
  final String fullAddress;
  final String dispatchUpdate;
  final IconData dispatchIcon;
  final String description;
  final String contactNumber;
  final int photoCount;
  final String? photoAssetPath;
  final DateTime createdAt;
  final bool isRecent;

  const EmergencyRequest({
    required this.id,
    required this.title,
    required this.type,
    required this.status,
    required this.timeLabel,
    required this.location,
    required this.fullAddress,
    required this.dispatchUpdate,
    required this.dispatchIcon,
    required this.description,
    required this.contactNumber,
    this.photoCount = 1,
    this.photoAssetPath,
    required this.createdAt,
    this.isRecent = true,
  });

  EmergencyRequest copyWith({
    String? id,
    String? title,
    EmergencyType? type,
    RequestStatus? status,
    String? timeLabel,
    String? location,
    String? fullAddress,
    String? dispatchUpdate,
    IconData? dispatchIcon,
    String? description,
    String? contactNumber,
    int? photoCount,
    String? photoAssetPath,
    DateTime? createdAt,
    bool? isRecent,
  }) {
    return EmergencyRequest(
      id: id ?? this.id,
      title: title ?? this.title,
      type: type ?? this.type,
      status: status ?? this.status,
      timeLabel: timeLabel ?? this.timeLabel,
      location: location ?? this.location,
      fullAddress: fullAddress ?? this.fullAddress,
      dispatchUpdate: dispatchUpdate ?? this.dispatchUpdate,
      dispatchIcon: dispatchIcon ?? this.dispatchIcon,
      description: description ?? this.description,
      contactNumber: contactNumber ?? this.contactNumber,
      photoCount: photoCount ?? this.photoCount,
      photoAssetPath: photoAssetPath ?? this.photoAssetPath,
      createdAt: createdAt ?? this.createdAt,
      isRecent: isRecent ?? this.isRecent,
    );
  }
}
