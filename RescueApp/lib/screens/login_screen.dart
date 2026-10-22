import 'package:flutter/material.dart';
import '../theme/tactical_theme.dart';
import '../models/app_state.dart';

class LoginScreen extends StatefulWidget {
  final AppState appState;
  final VoidCallback onLoginSuccess;
  final VoidCallback onSosPressed;

  const LoginScreen({
    super.key,
    required this.appState,
    required this.onLoginSuccess,
    required this.onSosPressed,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController(text: '98110 44201');
  final TextEditingController _otpController = TextEditingController(text: '739201');
  String _selectedRole = 'Team Leader / Commander';
  bool _otpSent = true;
  String? _statusBanner;

  final List<String> _roles = [
    'Team Leader / Commander',
    'Volunteer Rescuer',
    'Medical Personnel',
    'Civilian',
  ];

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  void _selectDemoRole(String role, String phone, String persona) {
    setState(() {
      _selectedRole = role;
      _phoneController.text = phone.replaceAll('+91 ', '');
      _otpController.text = '739201';
      _otpSent = true;
      _statusBanner = '$role Loaded: $persona • Ready for field dispatch';
    });
    widget.appState.setDemoRole(role, phone, persona);
  }

  void _submitAuth() {
    widget.appState.login(_selectedRole, '+91 ${_phoneController.text.trim()}');
    widget.onLoginSuccess();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TacticalColors.surface,
      body: Stack(
        children: [
          // Tactical Rescue Hero Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/hero_rescue.png',
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
              errorBuilder: (_, __, ___) => const SizedBox.shrink(),
            ),
          ),
          // Deep Tactical Scrim Gradient for high contrast & anti-glare
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    TacticalColors.surface.withValues(alpha: 0.78),
                    TacticalColors.surface.withValues(alpha: 0.92),
                    TacticalColors.surface,
                  ],
                  stops: const [0.0, 0.38, 0.75],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Top Utility Control: SatLink & Night Ops Toggle
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: TacticalColors.surfaceContainerHigh,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 7,
                              height: 7,
                              decoration: const BoxDecoration(
                                color: TacticalColors.tertiary,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Text(
                              'SATLINK ACTIVE • UK-07',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: TacticalColors.tertiary,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          widget.appState.toggleNightOps();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                widget.appState.nightOpsEnabled ? 'Night Ops Mode active' : 'Day Ops Mode active',
                              ),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: TacticalColors.surfaceContainer,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFF1E293B)),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.dark_mode, color: TacticalColors.primary, size: 14),
                              SizedBox(width: 5),
                              Text(
                                'Night Ops',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: TacticalColors.onSurface,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Compact Brand Header
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFF1E293B),
                          TacticalColors.surfaceContainerLowest,
                        ],
                      ),
                      border: Border.all(color: const Color(0xFF1E293B)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: TacticalColors.primaryContainer,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.emergency,
                            color: TacticalColors.onPrimaryContainer,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                children: [
                                  const Text(
                                    'RescueTeam',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: TacticalColors.onSurface,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                                    decoration: BoxDecoration(
                                      color: TacticalColors.tertiaryContainer.withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Text(
                                      'OPS V3.2',
                                      style: TextStyle(
                                        fontSize: 9,
                                        fontWeight: FontWeight.w800,
                                        color: TacticalColors.tertiary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const Text(
                                'Uttarakhand Field Command · Respond • Save Lives',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: TacticalColors.onSurfaceVariant,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Instant Demo Mode Selector Pill
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: TacticalColors.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFF1E293B)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Flexible(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.bolt, color: TacticalColors.tertiary, size: 15),
                                  SizedBox(width: 4),
                                  Flexible(
                                    child: Text(
                                      '1-TAP DEMO PERSONAS',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: TacticalColors.onSurface,
                                        letterSpacing: 0.5,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 6),
                            Text(
                              'Preloaded Data',
                              style: TextStyle(
                                fontSize: 10,
                                color: TacticalColors.outline,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: _buildDemoRoleBtn(
                                title: 'Commander',
                                icon: Icons.military_tech,
                                iconColor: TacticalColors.primary,
                                onTap: () => _selectDemoRole(
                                  'Team Leader / Commander',
                                  '+91 98110 44201',
                                  'HQ Commander Rawat',
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: _buildDemoRoleBtn(
                                title: 'Volunteer',
                                icon: Icons.hiking,
                                iconColor: TacticalColors.tertiary,
                                onTap: () => _selectDemoRole(
                                  'Volunteer Rescuer',
                                  '+91 94561 22890',
                                  'Field Lead Sunita',
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: _buildDemoRoleBtn(
                                title: 'Civilian',
                                icon: Icons.person_pin_circle,
                                iconColor: TacticalColors.secondary,
                                onTap: () => _selectDemoRole(
                                  'Civilian',
                                  '+91 97600 11432',
                                  'Citizen Distress Signal',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Standard Tactical Authentication Card
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: TacticalColors.surfaceContainer,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFF1E293B)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Flexible(
                              child: Text(
                                'Field Authentication',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: TacticalColors.onSurface,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(width: 6),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.lock, color: TacticalColors.tertiary, size: 12),
                                SizedBox(width: 4),
                                Text(
                                  '256-bit Encrypted',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: TacticalColors.tertiary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Operational Role Selector
                        Container(
                          height: 38,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: TacticalColors.surfaceContainerLowest,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFF1E293B)),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedRole,
                              isExpanded: true,
                              dropdownColor: TacticalColors.surfaceContainerHigh,
                              icon: const Icon(Icons.expand_more, color: TacticalColors.outline, size: 18),
                              items: _roles.map((role) {
                                return DropdownMenuItem<String>(
                                  value: role,
                                  child: Text(
                                    role,
                                    style: const TextStyle(
                                      color: TacticalColors.onSurface,
                                      fontSize: 12,
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: (val) {
                                if (val != null) setState(() => _selectedRole = val);
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Phone Input + Get OTP
                        Row(
                          children: [
                            Container(
                              height: 38,
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: TacticalColors.surfaceContainerLowest,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: const Color(0xFF1E293B)),
                              ),
                              child: const Text(
                                '🇮🇳 +91',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: TacticalColors.onSurface,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Container(
                                height: 38,
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                  color: TacticalColors.surfaceContainerLowest,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: const Color(0xFF1E293B)),
                                ),
                                child: TextField(
                                  controller: _phoneController,
                                  keyboardType: TextInputType.phone,
                                  style: const TextStyle(
                                    color: TacticalColors.onSurface,
                                    fontSize: 13,
                                  ),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    isDense: true,
                                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                                    hintText: '98765 43210',
                                    hintStyle: const TextStyle(color: TacticalColors.outline, fontSize: 12),
                                    suffixIcon: InkWell(
                                      onTap: () {
                                        setState(() {
                                          _otpSent = true;
                                          _otpController.text = '739201';
                                          _statusBanner = 'SMS OTP Dispatched to ${_phoneController.text}';
                                        });
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                                        margin: const EdgeInsets.symmetric(vertical: 6),
                                        decoration: BoxDecoration(
                                          color: TacticalColors.surfaceContainerHigh,
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: const Center(
                                          child: Text(
                                            'Get OTP',
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              color: TacticalColors.primary,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        if (_otpSent) ...[
                          const SizedBox(height: 8),
                          Container(
                            height: 38,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: TacticalColors.surfaceContainerLowest,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: const Color(0xFF1E293B)),
                            ),
                            child: TextField(
                              controller: _otpController,
                              keyboardType: TextInputType.number,
                              style: const TextStyle(
                                color: TacticalColors.onSurface,
                                fontSize: 13,
                                letterSpacing: 3,
                                fontWeight: FontWeight.bold,
                              ),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(vertical: 10),
                                icon: Icon(Icons.pin, color: TacticalColors.outline, size: 16),
                                hintText: 'Enter 6-digit code',
                                hintStyle: TextStyle(
                                  color: TacticalColors.outline,
                                  letterSpacing: 0,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ],

                        const SizedBox(height: 10),
                        // Login Button
                        SizedBox(
                          width: double.infinity,
                          height: 42,
                          child: ElevatedButton.icon(
                            onPressed: _submitAuth,
                            icon: const Icon(Icons.fingerprint, size: 18),
                            label: const Text(
                              'Authenticate & Enter Command',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Emergency Helpline Banner (Direct Civilian SOS)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      color: TacticalColors.errorContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 30,
                          height: 30,
                          decoration: const BoxDecoration(
                            color: TacticalColors.emergencyRed,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.sos, color: Colors.white, size: 16),
                        ),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'CIVILIAN DISTRESS? NO LOGIN NEEDED',
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                  color: TacticalColors.onErrorContainer,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              Text(
                                'Direct Dial 112 / Disaster SOS',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: TacticalColors.onErrorContainer,
                                ),
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: widget.onSosPressed,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: TacticalColors.emergencyRed,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.call, color: Colors.white, size: 12),
                                SizedBox(width: 4),
                                Text(
                                  'SOS',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
    ],
  ),
);
  }

  Widget _buildDemoRoleBtn({
    required String title,
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
        decoration: BoxDecoration(
          color: TacticalColors.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFF1E293B)),
        ),
        child: Column(
          children: [
            Icon(icon, color: iconColor, size: 20),
            const SizedBox(height: 4),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: TacticalColors.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
