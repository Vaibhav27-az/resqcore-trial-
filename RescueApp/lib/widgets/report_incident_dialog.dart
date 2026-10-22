import 'package:flutter/material.dart';
import '../theme/tactical_theme.dart';
import '../models/app_state.dart';

class ReportIncidentDialog extends StatefulWidget {
  final AppState appState;

  const ReportIncidentDialog({super.key, required this.appState});

  @override
  State<ReportIncidentDialog> createState() => _ReportIncidentDialogState();
}

class _ReportIncidentDialogState extends State<ReportIncidentDialog> {
  final _titleController = TextEditingController();
  final _locationController = TextEditingController(text: 'Joshimath Ward 4');
  final _descController = TextEditingController();
  String _severity = 'High';

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_titleController.text.trim().isEmpty) return;
    widget.appState.reportIncident(
      title: _titleController.text.trim(),
      location: _locationController.text.trim(),
      severity: _severity,
      description: _descController.text.trim(),
    );
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Incident reported: ${_titleController.text.trim()} logged to SAR dispatch'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: TacticalColors.surfaceContainer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFF1E293B)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.report_problem, color: TacticalColors.secondary, size: 22),
                      SizedBox(width: 8),
                      Text(
                        'Report Field Incident',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: TacticalColors.onSurface,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: TacticalColors.outline, size: 20),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Incident Title',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: TacticalColors.onSurfaceVariant),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: TacticalColors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFF1E293B)),
                ),
                child: TextField(
                  controller: _titleController,
                  style: const TextStyle(color: TacticalColors.onSurface, fontSize: 14),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'e.g. Flash Flood / Landslide / Structural Collapse',
                    hintStyle: TextStyle(color: TacticalColors.outline, fontSize: 13),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Location / Sector',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: TacticalColors.onSurfaceVariant),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: TacticalColors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFF1E293B)),
                ),
                child: TextField(
                  controller: _locationController,
                  style: const TextStyle(color: TacticalColors.onSurface, fontSize: 14),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Sector, landmark or GPS coords',
                    hintStyle: TextStyle(color: TacticalColors.outline, fontSize: 13),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Severity Level',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: TacticalColors.onSurfaceVariant),
              ),
              const SizedBox(height: 6),
              Row(
                children: ['High', 'Medium', 'Info'].map((level) {
                  final isSelected = _severity == level;
                  Color color = level == 'High'
                      ? TacticalColors.secondary
                      : level == 'Medium'
                          ? TacticalColors.warningAmber
                          : TacticalColors.primary;
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: InkWell(
                        onTap: () => setState(() => _severity = level),
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected ? color.withOpacity(0.25) : TacticalColors.surfaceContainerLowest,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isSelected ? color : const Color(0xFF1E293B),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              level,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: isSelected ? color : TacticalColors.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),
              const Text(
                'Tactical Situation Details',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: TacticalColors.onSurfaceVariant),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: TacticalColors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFF1E293B)),
                ),
                child: TextField(
                  controller: _descController,
                  maxLines: 3,
                  style: const TextStyle(color: TacticalColors.onSurface, fontSize: 13),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Number of people affected, road accessibility, hazards...',
                    hintStyle: TextStyle(color: TacticalColors.outline, fontSize: 12),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton.icon(
                  onPressed: _submit,
                  icon: const Icon(Icons.send, size: 18),
                  label: const Text(
                    'Dispatch Incident Report',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
