import 'package:flutter/material.dart';
import '../models/emergency_request.dart';
import '../theme/app_text_styles.dart';

class StatusBadge extends StatelessWidget {
  final RequestStatus status;

  const StatusBadge({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: status.backgroundColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: status.dotColor,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            status.label,
            style: AppTextStyles.labelSm.copyWith(
              color: status.textColor,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
