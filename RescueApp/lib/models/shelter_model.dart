class Shelter {
  final String id;
  final String name;
  final String location;
  final int capacity;
  final int occupied;
  final String distance;
  final String amenities;
  final bool hasMedical;
  final bool hasAirlift;

  const Shelter({
    required this.id,
    required this.name,
    required this.location,
    required this.capacity,
    required this.occupied,
    required this.distance,
    required this.amenities,
    this.hasMedical = false,
    this.hasAirlift = false,
  });

  double get occupancyRate => (occupied / capacity).clamp(0.0, 1.0);

  static List<Shelter> mockShelters() {
    return [
      const Shelter(
        id: 'SH-01',
        name: 'Govt Higher Secondary Camp',
        location: 'Joshimath Upper Ridge Sector',
        capacity: 300,
        occupied: 264,
        distance: '1.2 km NW',
        amenities: 'Medical tent, Clean water, Hot meals',
        hasMedical: true,
      ),
      const Shelter(
        id: 'SH-02',
        name: 'Community Hall Joshimath',
        location: 'Ward 2 Safe Elevation',
        capacity: 150,
        occupied: 63,
        distance: '2.4 km N',
        amenities: 'Generator power, Blankets, Dry rations',
        hasMedical: false,
      ),
      const Shelter(
        id: 'SH-03',
        name: 'Army Helipad Staging Camp',
        location: 'Military Base Transit Post',
        capacity: 400,
        occupied: 110,
        distance: '4.8 km NE',
        amenities: 'Helitac medevac staging, Surgical unit',
        hasMedical: true,
        hasAirlift: true,
      ),
    ];
  }
}

class Evacuee {
  final String id;
  final String name;
  final int age;
  final String gender;
  final String status; // 'Missing', 'Rescued'
  final String riskLevel; // 'High', 'Moderate', 'Safe'
  final String lastSeen;
  final String notes;
  final String bloodGroup;
  final String assignedShelter;

  const Evacuee({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.status,
    required this.riskLevel,
    required this.lastSeen,
    required this.notes,
    required this.bloodGroup,
    required this.assignedShelter,
  });

  static List<Evacuee> mockEvacuees() {
    return [
      const Evacuee(
        id: 'EV-01',
        name: 'Mohan Lal',
        age: 68,
        gender: 'Male',
        status: 'Missing',
        riskLevel: 'High',
        lastSeen: 'Near old flour mill (08:30 AM)',
        notes: 'Diabetic, restricted mobility, trapped on ground floor',
        bloodGroup: 'B+',
        assignedShelter: 'Govt Higher Secondary Camp',
      ),
      const Evacuee(
        id: 'EV-02',
        name: 'Anita Rawat',
        age: 34,
        gender: 'Female',
        status: 'Rescued',
        riskLevel: 'Safe',
        lastSeen: 'Ward 4 Middle Colony',
        notes: 'In transit via transport buggy with Paramedic Priya',
        bloodGroup: 'O+',
        assignedShelter: 'Govt Higher Secondary Camp',
      ),
      const Evacuee(
        id: 'EV-03',
        name: 'Rakesh Bhandari',
        age: 42,
        gender: 'Male',
        status: 'Missing',
        riskLevel: 'High',
        lastSeen: 'Alaknanda riverbank shop (09:15 AM)',
        notes: 'Flash flood crest zone, radio signal lost',
        bloodGroup: 'A+',
        assignedShelter: 'Pending Rescue',
      ),
      const Evacuee(
        id: 'EV-04',
        name: 'Meena Devi',
        age: 55,
        gender: 'Female',
        status: 'Rescued',
        riskLevel: 'Safe',
        lastSeen: 'Clinic Ward 4',
        notes: 'Mild hypothermia treated with blankets and warm fluids',
        bloodGroup: 'AB+',
        assignedShelter: 'Community Hall Joshimath',
      ),
    ];
  }
}
