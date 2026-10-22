class ChatMessage {
  final String id;
  final String sender;
  final String initials;
  final String role;
  final String time;
  final String text;
  final String? locationTag;
  final String? attachmentUrl;
  final String? attachmentCoords;
  final bool isAlert;
  final bool isBot;
  final bool isMe;

  const ChatMessage({
    required this.id,
    required this.sender,
    required this.initials,
    required this.role,
    required this.time,
    required this.text,
    this.locationTag,
    this.attachmentUrl,
    this.attachmentCoords,
    this.isAlert = false,
    this.isBot = false,
    this.isMe = false,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json, {String? currentUserName}) {
    final senderStr = json['sender']?.toString() ?? 'Field Unit';
    final isMeBool = json['isSelf'] == true || (currentUserName != null && senderStr.contains(currentUserName));

    return ChatMessage(
      id: json['id']?.toString() ?? 'MSG-${DateTime.now().millisecondsSinceEpoch}',
      sender: senderStr,
      initials: json['initials']?.toString() ?? (senderStr.isNotEmpty ? senderStr[0].toUpperCase() : 'FO'),
      role: json['role']?.toString() ?? 'Responder',
      time: json['time']?.toString() ?? 'Just now',
      text: json['text']?.toString() ?? '',
      locationTag: json['locationTag']?.toString(),
      attachmentUrl: json['attachmentUrl']?.toString(),
      attachmentCoords: json['attachmentCoords']?.toString(),
      isAlert: json['isAlert'] == true,
      isBot: json['isBot'] == true,
      isMe: isMeBool,
    );
  }

  static List<ChatMessage> mockMessages() {
    return [
      const ChatMessage(
        id: 'MSG-01',
        sender: 'Capt. Rajesh Negi',
        initials: 'RN',
        role: 'Lead Comms',
        time: '10:14 AM',
        text: 'Priya, what is the status of the elderly gentleman from Ward 4?',
      ),
      const ChatMessage(
        id: 'MSG-02',
        sender: 'Paramedic Priya Sharma',
        initials: 'PS',
        role: 'Triage Specialist',
        time: '10:16 AM',
        text: 'Stabilized with IV fluid. Sunita is bringing the transport buggy to coordinate evacuation to Govt Higher Secondary Camp.',
        locationTag: 'Ward 4 Clinic (Sector B)',
      ),
      const ChatMessage(
        id: 'MSG-03',
        sender: 'Drone Spec Amit Joshi',
        initials: 'AJ',
        role: 'FLIR Thermal Lead',
        time: '10:19 AM',
        text: 'Thermal camera spotted 2 missing individuals near the old flour mill coordinates (30.5571, 79.5690). Tagged in tactical map.',
        attachmentUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCSBBd9bUHxizGSwEvCYnW41MH4p62S7HTfbgBJzDq65R66r7Ygd36uuWLBqpvVoqRUhPXsrzHZFxeJrDild2aDHyTuRNZLvEVqxYAjTFbmm2o9dbF2CtIxdx_NT7zHaDVLo8Dl74Qpxu1mR54EkmRugV1W5UgNo0U0nvtIAmPWriVzFiD3gpWRfw65aJuAzaRJ40KEaSiKPw5eQ909QJXTVurDNXVbzRzQ-E5XtD470_sWtbJ0buS1',
        attachmentCoords: '30.5571, 79.5690',
      ),
      const ChatMessage(
        id: 'MSG-04',
        sender: 'Dispatch Bot',
        initials: 'BOT',
        role: 'PRIORITY 1',
        time: '10:21 AM',
        text: 'SOS Request received from Sunita Devi (+91 98765-11223) — Trapped on 2nd floor, 3 people.',
        isAlert: true,
        isBot: true,
      ),
    ];
  }
}
