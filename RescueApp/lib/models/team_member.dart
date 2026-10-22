class TeamMember {
  final String id;
  final String name;
  final String role;
  final String specialty;
  final int batteryLevel;
  final String status;
  final String distance;
  final String gpsCoords;
  final String avatarUrl;
  final String bloodGroup;

  const TeamMember({
    required this.id,
    required this.name,
    required this.role,
    required this.specialty,
    required this.batteryLevel,
    required this.status,
    required this.distance,
    required this.gpsCoords,
    required this.avatarUrl,
    required this.bloodGroup,
  });
}

class RescueTeam {
  final String id;
  final String name;
  final String sector;
  final String callsign;
  final String frequency;
  final String commanderName;
  final String commanderPhone;
  final String commanderExperience;
  final String commanderBloodGroup;
  final String commanderAvatar;
  final int syncedCount;
  final int totalCount;
  final String status;
  final List<TeamMember> members;

  const RescueTeam({
    required this.id,
    required this.name,
    required this.sector,
    required this.callsign,
    required this.frequency,
    required this.commanderName,
    required this.commanderPhone,
    required this.commanderExperience,
    required this.commanderBloodGroup,
    required this.commanderAvatar,
    required this.syncedCount,
    required this.totalCount,
    required this.status,
    required this.members,
  });

  static List<RescueTeam> mockTeams() {
    return [
      RescueTeam(
        id: 'TEAM-ALPHA',
        name: 'Team Alpha',
        sector: 'Mountain Quick Response • Sector 4 Grid Alpha',
        callsign: 'GARHWAL-01',
        frequency: 'Ch 4A (156.8MHz)',
        commanderName: 'Capt. Rajesh Negi',
        commanderPhone: '+91 98110 44201',
        commanderExperience: '12 Yrs NDRF Veteran',
        commanderBloodGroup: 'O+',
        commanderAvatar: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDndhddsN_XnhJ5wBRfjI05kxWo4mw-MS5sHHf1p7orshPp_2OG60PJfZJDBYFewJFmq92TU3LMgDrIOL2Ds1YTjctIlXMAr2r-b8SfqmQzZDTEENqlF_FpDTn1JxXmhuYJEAjdP2tpfAy6pRz7GTZfj_sWNS2evUQeeQr-Pu5BpY1JVXKZBtfJurtbLfWGbdsNERxO_3arxTH1PmSRulQGD3oU7HBGSjQZfXzPHrRszAqrqx3cbNQF',
        syncedCount: 4,
        totalCount: 4,
        status: 'OPR-READY',
        members: [
          const TeamMember(
            id: 'MEM-01',
            name: 'Priya Sharma',
            role: 'Paramedic',
            specialty: 'Lead Triage Specialist',
            batteryLevel: 88,
            status: 'Treating casualty',
            distance: '140m NW',
            gpsCoords: '30.5562° N, 79.5670° E',
            avatarUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuA2I7IUEx54A9JvR511lRlRkKrjQwuWfaZ3_M_2kSbOVth-fqSTRKSEV5io1QQ-O5yTe7iTR_2wVnt8cayhAEkZf3xsuozHCGxAMKxeRVuWlYOyM9o5xCh48ZJgZzHENt7zTXQby3Kj8MxbUCni7jET63feM3oINd8M7ilsZVB-TK8cm563babnaPLPz3kGpg_wnuCUoWb2-EglxQl9TwCmSf6ZT1mnZbqUpba6zBnJ7cqS-ZvQTLUa',
            bloodGroup: 'B+',
          ),
          const TeamMember(
            id: 'MEM-02',
            name: 'Vikram Singh',
            role: 'Technical Rescue',
            specialty: 'Rope & Crevasse Specialist',
            batteryLevel: 92,
            status: 'Ascending rope line',
            distance: '320m NE',
            gpsCoords: '30.5574° N, 79.5685° E',
            avatarUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCDXV0JRMtl5gFf9nm8JEv1LTUj9hR_8XjquKXc98oKB2186qAqRFb6qO45CRVwB9ik41AAbcLB_1BQOnMXoq5J9rFOwsp_5NBLscuAQSb4PRG67SW1ig72MLX4Ah4OojAo4lNeWfNZ7QmeewB_QBLu5GYpJkAjg5c_zJJ6Rofw3frk-iBqE2MAUz_NEKYphLJYpc0Q14M8vKOkgQ0N95dDxOzxVfUuzbC8ICNH8NjzxWCbU-aIgVwp',
            bloodGroup: 'A+',
          ),
          const TeamMember(
            id: 'MEM-03',
            name: 'Amit Joshi',
            role: 'Sensors / Drone',
            specialty: 'FLIR Thermal Operator',
            batteryLevel: 75,
            status: 'Drone overwatch sector',
            distance: '450m S',
            gpsCoords: '30.5540° N, 79.5650° E',
            avatarUrl: '',
            bloodGroup: 'AB+',
          ),
          const TeamMember(
            id: 'MEM-04',
            name: 'Sunita Devi',
            role: 'Field Lead',
            specialty: 'Civilian Evac Coordinator',
            batteryLevel: 81,
            status: 'Navigating transport buggy',
            distance: '600m SE',
            gpsCoords: '30.5532° N, 79.5710° E',
            avatarUrl: '',
            bloodGroup: 'O+',
          ),
        ],
      ),
      const RescueTeam(
        id: 'TEAM-BRAVO',
        name: 'Team Bravo',
        sector: 'Alaknanda River Gorge SAR',
        callsign: 'GARHWAL-02',
        frequency: 'Ch 4B (156.85MHz)',
        commanderName: 'Maj. Vikramaditya Rathore',
        commanderPhone: '+91 94561 22890',
        commanderExperience: '15 Yrs Indian Army / SDRF',
        commanderBloodGroup: 'B+',
        commanderAvatar: '',
        syncedCount: 5,
        totalCount: 5,
        status: 'ON-ROUTE',
        members: [],
      ),
      const RescueTeam(
        id: 'TEAM-CHARLIE',
        name: 'Team Charlie',
        sector: 'High Altitude Helitac Rapid Unit',
        callsign: 'GARHWAL-03',
        frequency: 'Ch 4C (156.9MHz)',
        commanderName: 'Capt. Ananya Sen',
        commanderPhone: '+91 97600 11432',
        commanderExperience: '8 Yrs Aeromedical Evac',
        commanderBloodGroup: 'A-',
        commanderAvatar: '',
        syncedCount: 4,
        totalCount: 4,
        status: 'STANDBY',
        members: [],
      ),
    ];
  }
}
