class Moin {
  final String moin;
  final String zwiebel;
  final int kuh;

  const Moin({required this.moin, required this.zwiebel, required this.kuh});
  // ################################################################

  factory Moin.fromMap(Map<String, dynamic> map) {
    return Moin(moin: map['moin'], zwiebel: map['zwiebel'], kuh: map['kuh']);
  }

  Map<String, dynamic> toMap() {
    return {'moin': moin, 'zwiebel': zwiebel, 'kuh': kuh};
  }
}

// ################################################################
class MoinTwo {
  final String id;
  final Moin moin;
  final List<String> affe;

  const MoinTwo({required this.id, required this.moin, required this.affe});
  // ################################################################

  factory MoinTwo.fromMap(Map<String, dynamic> map) {
    return MoinTwo(
      id: map['id'],
      moin: Moin.fromMap(map['moin']),
      affe: List<String>.from(map['affe']),
    );
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'moin': moin.toMap(), 'affe': affe};
  }

  // ################################################################
}
