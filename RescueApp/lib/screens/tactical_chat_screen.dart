import 'package:flutter/material.dart';
import '../theme/tactical_theme.dart';
import '../models/app_state.dart';
import '../models/chat_message.dart';
import '../widgets/tactical_header.dart';

class TacticalChatScreen extends StatefulWidget {
  final AppState appState;
  final VoidCallback onSosPressed;

  const TacticalChatScreen({
    super.key,
    required this.appState,
    required this.onSosPressed,
  });

  @override
  State<TacticalChatScreen> createState() => _TacticalChatScreenState();
}

class _TacticalChatScreenState extends State<TacticalChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isRecording = false;

  final List<String> _quickBursts = [
    'En route',
    'Need Medevac',
    'Grid cleared',
    'Radio silence',
    'Relay link OK',
  ];

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage({String? customText, String? locationTag}) {
    final text = customText ?? _textController.text;
    if (text.trim().isEmpty) return;
    widget.appState.addMessage(text, locationTag: locationTag);
    if (customText == null) _textController.clear();

    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final messages = widget.appState.messages;

    return Scaffold(
      backgroundColor: TacticalColors.surface,
      appBar: TacticalHeader(
        title: 'Incident Details',
        appState: widget.appState,
        showBackButton: true,
        onSosPressed: widget.onSosPressed,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              children: [
                // Mesh Channel Banner
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: TacticalColors.surfaceContainer,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFF1E293B)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: TacticalColors.tertiary,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Channel 4-Alpha',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: TacticalColors.onSurface,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: TacticalColors.surfaceContainerHigh,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.cell_tower, color: TacticalColors.tertiary, size: 12),
                                SizedBox(width: 4),
                                Text(
                                  'Mesh Synced',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: TacticalColors.tertiary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Offline RF Radio Node • Relay hop: 2 ms',
                            style: TextStyle(
                              fontSize: 11,
                              color: TacticalColors.onSurfaceVariant,
                            ),
                          ),
                          Row(
                            children: [
                              _buildPresenceAvatar('RN', TacticalColors.primaryContainer),
                              _buildPresenceAvatar('PS', TacticalColors.tertiaryContainer),
                              _buildPresenceAvatar('AJ', TacticalColors.surfaceBright),
                              const SizedBox(width: 4),
                              const Text(
                                '4 Active',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: TacticalColors.tertiary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                // Pinned Critical Incident Alert Banner with Scenario Backdrop
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: TacticalColors.secondaryContainer,
                      width: 1.2,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x33A40217),
                        blurRadius: 10,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(13),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Image.asset(
                            'assets/images/scenarios/ravine_night_patrol.png',
                            fit: BoxFit.cover,
                            alignment: Alignment.centerRight,
                            errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                          ),
                        ),
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  const Color(0xFF38080E).withValues(alpha: 0.96),
                                  const Color(0xFF38080E).withValues(alpha: 0.88),
                                  const Color(0xFF4A0E15).withValues(alpha: 0.65),
                                ],
                                stops: const [0.0, 0.65, 1.0],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.warning, color: TacticalColors.secondary, size: 22),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'CRITICAL PINNED ALERT',
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: TacticalColors.secondaryFixed,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                                          decoration: BoxDecoration(
                                            color: TacticalColors.secondaryContainer,
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: const Text(
                                            'T-20 Mins',
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    const Text(
                                      'Flash Flood Crest Alert: Water level rising 0.8m at Bridge 2. Move evacuees to High Ground Shelter within 20 mins.',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: TacticalColors.onSecondaryContainer,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                // Messages Stream
                ...messages.map((msg) => _buildMessageBubble(msg)),
              ],
            ),
          ),

          // Tactical Quick Bursts
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            color: TacticalColors.surfaceContainerLowest,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'TACTICAL QUICK BURSTS',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: TacticalColors.outline,
                    letterSpacing: 0.6,
                  ),
                ),
                const SizedBox(height: 6),
                SizedBox(
                  height: 32,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _quickBursts.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final burst = _quickBursts[index];
                      return ActionChip(
                        backgroundColor: TacticalColors.surfaceContainerHigh,
                        side: const BorderSide(color: Color(0xFF1E293B)),
                        label: Text(
                          burst,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: TacticalColors.onSurface,
                          ),
                        ),
                        onPressed: () => _sendMessage(customText: burst),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Input Bar
          Container(
            padding: EdgeInsets.only(
              left: 12,
              right: 12,
              top: 8,
              bottom: MediaQuery.of(context).padding.bottom + 8,
            ),
            decoration: const BoxDecoration(
              color: TacticalColors.surfaceContainerLow,
              border: Border(
                top: BorderSide(color: Color(0xFF1E293B)),
              ),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.add_location_alt, color: TacticalColors.tertiary, size: 20),
                  onPressed: () {
                    _sendMessage(
                      customText: 'Location ping broadcasted',
                      locationTag: 'Grid Sector 4 (30.5562, 79.5670)',
                    );
                  },
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: TacticalColors.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFF1E293B)),
                    ),
                    child: TextField(
                      controller: _textController,
                      style: const TextStyle(color: TacticalColors.onSurface, fontSize: 14),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Radio message or tactical memo...',
                        hintStyle: TextStyle(color: TacticalColors.outline, fontSize: 13),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                // Push-to-Talk Simulation Button
                GestureDetector(
                  onTapDown: (_) {
                    setState(() => _isRecording = true);
                  },
                  onTapUp: (_) {
                    setState(() => _isRecording = false);
                    _sendMessage(customText: '🎙 [PTT Voice Burst 00:04 transmitted]');
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _isRecording ? TacticalColors.emergencyRed : TacticalColors.surfaceContainerHigh,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.mic,
                      color: _isRecording ? Colors.white : TacticalColors.primary,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                // Send Button
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: TacticalColors.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.send, color: TacticalColors.onPrimaryContainer, size: 18),
                    onPressed: () => _sendMessage(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPresenceAvatar(String text, Color bg) {
    return Container(
      width: 22,
      height: 22,
      margin: const EdgeInsets.only(right: 2),
      decoration: BoxDecoration(
        color: bg,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage msg) {
    final isMe = msg.isMe;

    Color avatarBg;
    if (msg.isBot) {
      avatarBg = TacticalColors.emergencyRed;
    } else if (msg.initials == 'RN') {
      avatarBg = TacticalColors.primaryContainer;
    } else if (msg.initials == 'PS') {
      avatarBg = TacticalColors.tertiaryContainer;
    } else {
      avatarBg = TacticalColors.surfaceBright;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isMe) ...[
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: avatarBg,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: msg.isBot
                    ? const Icon(Icons.smart_toy, color: Colors.white, size: 18)
                    : Text(
                        msg.initials,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
            const SizedBox(width: 10),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      msg.sender,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: msg.isBot ? TacticalColors.emergencyRed : TacticalColors.primary,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${msg.role} • ${msg.time}',
                      style: const TextStyle(
                        fontSize: 10,
                        color: TacticalColors.outline,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isMe
                        ? TacticalColors.primaryContainer
                        : msg.isAlert
                            ? TacticalColors.secondaryContainer.withOpacity(0.3)
                            : TacticalColors.surfaceContainerHigh,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(isMe ? 14 : 2),
                      topRight: Radius.circular(isMe ? 2 : 14),
                      bottomLeft: const Radius.circular(14),
                      bottomRight: const Radius.circular(14),
                    ),
                    border: Border.all(
                      color: msg.isAlert ? TacticalColors.secondaryContainer : const Color(0xFF1E293B),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (msg.locationTag != null) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          margin: const EdgeInsets.only(bottom: 6),
                          decoration: BoxDecoration(
                            color: TacticalColors.surfaceContainerLowest,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.location_on, color: TacticalColors.tertiary, size: 12),
                              const SizedBox(width: 4),
                              Text(
                                msg.locationTag!,
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: TacticalColors.tertiary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      Text(
                        msg.text,
                        style: TextStyle(
                          fontSize: 13,
                          color: isMe ? TacticalColors.onPrimaryContainer : TacticalColors.onSurface,
                          height: 1.4,
                        ),
                      ),
                      if (msg.attachmentUrl != null) ...[
                        const SizedBox(height: 8),
                        Container(
                          height: 120,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: TacticalColors.surfaceContainerLowest,
                            borderRadius: BorderRadius.circular(8),
                            gradient: const LinearGradient(
                              colors: [Color(0xFF0F1A2E), Color(0xFF1E293B)],
                            ),
                          ),
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            color: TacticalColors.surfaceContainerLowest.withOpacity(0.85),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Row(
                                  children: [
                                    Icon(Icons.radar, color: TacticalColors.tertiary, size: 12),
                                    SizedBox(width: 4),
                                    Text(
                                      'Thermal Recon Grid 4',
                                      style: TextStyle(fontSize: 10, color: TacticalColors.tertiary),
                                    ),
                                  ],
                                ),
                                Text(
                                  msg.attachmentCoords ?? '',
                                  style: const TextStyle(fontSize: 9, color: TacticalColors.outline),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                      if (msg.isAlert) ...[
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: TacticalColors.secondaryContainer,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                              ),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Task accepted: Team Alpha responding')),
                                );
                              },
                              icon: const Icon(Icons.check, size: 14),
                              label: const Text('Accept Task'),
                            ),
                            const SizedBox(width: 8),
                            OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: TacticalColors.primary,
                                side: const BorderSide(color: TacticalColors.primary),
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                              ),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Route calculated: 2.1km via Ridge Road')),
                                );
                              },
                              icon: const Icon(Icons.near_me, size: 14),
                              label: const Text('Route Plan'),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (isMe) ...[
            const SizedBox(width: 10),
            Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                color: TacticalColors.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  msg.initials,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: TacticalColors.onPrimaryContainer,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
