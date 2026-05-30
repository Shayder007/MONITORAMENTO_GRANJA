class BarnMotor {
  const BarnMotor({
    required this.id,
    required this.name,
    required this.line,
    required this.hasLiveData,
    required this.isRunning,
  });

  final String id;
  final String name;
  final String line;
  final bool hasLiveData;
  final bool isRunning;

  BarnMotor copyWith({
    String? id,
    String? name,
    String? line,
    bool? hasLiveData,
    bool? isRunning,
  }) {
    return BarnMotor(
      id: id ?? this.id,
      name: name ?? this.name,
      line: line ?? this.line,
      hasLiveData: hasLiveData ?? this.hasLiveData,
      isRunning: isRunning ?? this.isRunning,
    );
  }
}

class BarnUnit {
  const BarnUnit({required this.id, required this.name, required this.motors});

  final String id;
  final String name;
  final List<BarnMotor> motors;

  BarnUnit copyWith({String? id, String? name, List<BarnMotor>? motors}) {
    return BarnUnit(
      id: id ?? this.id,
      name: name ?? this.name,
      motors: motors ?? this.motors,
    );
  }
}

const List<BarnUnit> defaultBarns = [
  BarnUnit(
    id: 'barn_a',
    name: 'Galpão A',
    motors: [
      BarnMotor(
        id: 'm1',
        name: 'Linha Principal',
        line: 'Linha 1',
        hasLiveData: true,
        isRunning: true,
      ),
      BarnMotor(
        id: 'm2',
        name: 'Linha Exaustão',
        line: 'Linha 2',
        hasLiveData: false,
        isRunning: false,
      ),
      BarnMotor(
        id: 'm3',
        name: 'Linha Reserva',
        line: 'Linha 3',
        hasLiveData: false,
        isRunning: false,
      ),
    ],
  ),
  BarnUnit(
    id: 'barn_b',
    name: 'Galpão B',
    motors: [
      BarnMotor(
        id: 'm4',
        name: 'Linha Ventilação 1',
        line: 'Linha 1',
        hasLiveData: false,
        isRunning: false,
      ),
      BarnMotor(
        id: 'm5',
        name: 'Linha Ventilação 2',
        line: 'Linha 2',
        hasLiveData: false,
        isRunning: false,
      ),
    ],
  ),
];
