import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/rescue_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/app_top_bar.dart';
import 'report_submission_success_screen.dart';

class AddReportDetailsScreen extends StatefulWidget {
  const AddReportDetailsScreen({super.key});

  @override
  State<AddReportDetailsScreen> createState() => _AddReportDetailsScreenState();
}

class _AddReportDetailsScreenState extends State<AddReportDetailsScreen> {
  late TextEditingController _descController;
  late TextEditingController _contactController;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    final provider = context.read<RescueProvider>();
    _descController = TextEditingController(text: provider.draftDescription);
    _contactController = TextEditingController(text: provider.draftContact);
  }

  @override
  void dispose() {
    _descController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  void _onSubmitReport() {
    setState(() {
      _isSubmitting = true;
    });

    Future.delayed(const Duration(milliseconds: 700), () {
      if (mounted) {
        final provider = context.read<RescueProvider>();
        provider.setDraftDescription(_descController.text);
        provider.setDraftContact(_contactController.text);
        provider.submitDraftReport();

        setState(() {
          _isSubmitting = false;
        });

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => const ReportSubmissionSuccessScreen(),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RescueProvider>();

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          children: [
            AppTopBar(
              title: 'New Request',
              showBack: true,
              onBack: () => Navigator.of(context).pop(),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Step & Progress Tracker
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'STEP 3 OF 3 · REPORT DETAILS',
                          style: AppTextStyles.labelSm.copyWith(
                            color: AppColors.primary,
                            letterSpacing: 1.0,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryContainer.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '100%',
                            style: AppTextStyles.labelSm.copyWith(
                              fontSize: 10,
                              letterSpacing: 0.8,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // 3-Segmented Stepper (all active)
                    Row(
                      children: List.generate(3, (index) {
                        return Expanded(
                          child: Container(
                            height: 5,
                            margin: EdgeInsets.only(right: index < 2 ? 6 : 0),
                            decoration: BoxDecoration(
                              color: AppColors.primaryContainer,
                              borderRadius: BorderRadius.circular(999),
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 18),

                    // Headline
                    Text(
                      'Tell us what’s happening.',
                      style: AppTextStyles.headlineXlMobile.copyWith(
                        color: AppColors.textWhite,
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'A few details help the team prepare the right support.',
                      style: AppTextStyles.bodyMd.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Incident Summary Bar
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.strokeBorder,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: AppColors.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              provider.draftType.icon,
                              size: 18,
                              color: AppColors.secondary,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              '${provider.draftType.title} · ${provider.draftAddress}',
                              style: AppTextStyles.labelMd.copyWith(
                                color: AppColors.textWhite,
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          InkWell(
                            onTap: () => Navigator.of(context).pop(),
                            child: const Icon(
                              Icons.edit,
                              size: 18,
                              color: AppColors.outline,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Field 1: Situation Description
                    Row(
                      children: [
                        Text(
                          'Describe the situation ',
                          style: AppTextStyles.labelMd.copyWith(
                            color: AppColors.textWhite,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          '*',
                          style: AppTextStyles.labelMd.copyWith(
                            color: AppColors.error,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerLowest,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.strokeBorder,
                          width: 1,
                        ),
                      ),
                      child: TextField(
                        controller: _descController,
                        maxLines: 3,
                        style: AppTextStyles.bodyMd.copyWith(
                          color: AppColors.textWhite,
                          height: 1.4,
                        ),
                        decoration: const InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                          border: InputBorder.none,
                          hintText: 'Describe people affected and current risk...',
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Include people affected and any urgent medical needs.',
                      style: AppTextStyles.bodySm.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Field 2: Photos (optional)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Photos (optional)',
                          style: AppTextStyles.labelMd.copyWith(
                            color: AppColors.textWhite,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          '1 of 3',
                          style: AppTextStyles.labelSm.copyWith(
                            color: AppColors.outline,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    Row(
                      children: [
                        // Uploaded Photo Thumbnail
                        Expanded(
                          child: InkWell(
                            onTap: () => _showPhotoPickerSheet(context, provider),
                            borderRadius: BorderRadius.circular(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 96,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: AppColors.strokeBorder,
                                      width: 1,
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Stack(
                                      fit: StackFit.expand,
                                      children: [
                                        Image.asset(
                                          provider.draftPhotoAsset,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) => Container(
                                            color: AppColors.surfaceContainerHigh,
                                            child: const Icon(
                                              Icons.image,
                                              color: AppColors.outline,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top: 6,
                                          right: 6,
                                          child: Container(
                                            width: 22,
                                            height: 22,
                                            decoration: BoxDecoration(
                                              color: AppColors.surfaceContainerLowest
                                                  .withValues(alpha: 0.8),
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              Icons.cached,
                                              size: 14,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  provider.draftPhotoName,
                                  style: AppTextStyles.bodySm.copyWith(
                                    fontSize: 11,
                                    color: AppColors.textSecondary,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),

                        // Camera / Upload Action Card
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InkWell(
                                onTap: () => _showPhotoPickerSheet(context, provider),
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  height: 96,
                                  decoration: BoxDecoration(
                                    color: AppColors.surfaceContainerLow,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: AppColors.strokeBorder,
                                      width: 1,
                                    ),
                                  ),
                                  child: Center(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          width: 32,
                                          height: 32,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: AppColors.surfaceContainerHigh,
                                          ),
                                          child: const Icon(
                                            Icons.photo_camera,
                                            size: 18,
                                            color: AppColors.secondary,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          'Camera / upload',
                                          style: AppTextStyles.labelSm.copyWith(
                                            color: AppColors.secondary,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '',
                                style: AppTextStyles.bodySm.copyWith(fontSize: 11),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'JPG or PNG, up to 5 MB each. Only take photos if safe.',
                      style: AppTextStyles.bodySm.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Field 3: Contact number
                    Row(
                      children: [
                        Text(
                          'Contact number ',
                          style: AppTextStyles.labelMd.copyWith(
                            color: AppColors.textWhite,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          '*',
                          style: AppTextStyles.labelMd.copyWith(
                            color: AppColors.error,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Container(
                      height: 48,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerLowest,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.strokeBorder,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.call,
                            size: 18,
                            color: AppColors.outline,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: _contactController,
                              style: AppTextStyles.bodyMd.copyWith(
                                color: AppColors.textWhite,
                              ),
                              keyboardType: TextInputType.phone,
                              decoration: const InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'The assigned team may call this number.',
                      style: AppTextStyles.bodySm.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Consent Checkbox
                    InkWell(
                      onTap: () {
                        provider.setDraftConsent(!provider.draftConsent);
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            margin: const EdgeInsets.only(top: 2),
                            decoration: BoxDecoration(
                              color: provider.draftConsent
                                  ? AppColors.primaryContainer
                                  : AppColors.surfaceContainerHigh,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: provider.draftConsent
                                    ? AppColors.primaryContainer
                                    : AppColors.strokeBorder,
                                width: 1,
                              ),
                            ),
                            child: provider.draftConsent
                                ? const Icon(
                                    Icons.check,
                                    size: 15,
                                    color: Colors.white,
                                  )
                                : null,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'I agree to share this report, location and contact details with the response team.',
                              style: AppTextStyles.bodySm.copyWith(
                                color: AppColors.textWhite,
                                height: 1.35,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 22),

                    // Submit CTA Button
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _isSubmitting ? null : _onSubmitReport,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryContainer,
                          foregroundColor: Colors.white,
                          elevation: 4,
                          shadowColor:
                              AppColors.primaryContainer.withValues(alpha: 0.4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _isSubmitting
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: Colors.white,
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Transform.rotate(
                                    angle: -0.4,
                                    child: const Icon(
                                      Icons.send,
                                      size: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Submit emergency report',
                                    style: AppTextStyles.labelLg.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPhotoPickerSheet(BuildContext context, RescueProvider provider) {
    final photoOptions = [
      {
        'title': 'Swift-Water Inundation Recon',
        'asset': 'assets/images/scenarios/flood_river_boat.png',
        'name': 'flood_boat_recon.png · 1.4 MB',
      },
      {
        'title': 'Urban Street Water Rise Level',
        'asset': 'assets/images/scenarios/flood_response_street.png',
        'name': 'street_water_level.png · 1.8 MB',
      },
      {
        'title': 'Highway & Vehicle Hazard',
        'asset': 'assets/images/scenarios/highway_ambulance_storm.png',
        'name': 'highway_storm_hazard.png · 2.1 MB',
      },
      {
        'title': 'Structural Collapse & Rubble',
        'asset': 'assets/images/scenarios/earthquake_rubble_collapse.png',
        'name': 'structural_rubble.png · 1.9 MB',
      },
      {
        'title': 'Night Terrain / Ravine Sweep',
        'asset': 'assets/images/scenarios/night_canyon_search.png',
        'name': 'ravine_night_sweep.png · 1.6 MB',
      },
      {
        'title': 'High Altitude Alpine Evac',
        'asset': 'assets/images/scenarios/helicopter_mountain_alpine.png',
        'name': 'alpine_helo_evac.png · 2.3 MB',
      },
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceContainerLowest,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Attach Tactical Recon Photo',
                      style: AppTextStyles.labelLg.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: AppColors.textSecondary, size: 20),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
                Text(
                  'Select field photographic evidence for triage command:',
                  style: AppTextStyles.bodySm.copyWith(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  height: 140,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: photoOptions.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 12),
                    itemBuilder: (_, idx) {
                      final opt = photoOptions[idx];
                      final isCurrent = provider.draftPhotoAsset == opt['asset'];
                      return InkWell(
                        onTap: () {
                          provider.setDraftPhoto(opt['asset']!, opt['name']!);
                          Navigator.pop(ctx);
                        },
                        child: Container(
                          width: 120,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isCurrent ? AppColors.primaryContainer : AppColors.strokeBorder,
                              width: isCurrent ? 2 : 1,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(11),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Image.asset(opt['asset']!, fit: BoxFit.cover),
                                Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.transparent,
                                        Colors.black.withValues(alpha: 0.8),
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 6,
                                  left: 6,
                                  right: 6,
                                  child: Text(
                                    opt['title']!,
                                    style: AppTextStyles.labelSm.copyWith(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (isCurrent)
                                  const Positioned(
                                    top: 6,
                                    right: 6,
                                    child: Icon(Icons.check_circle, color: AppColors.primary, size: 18),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }
}
