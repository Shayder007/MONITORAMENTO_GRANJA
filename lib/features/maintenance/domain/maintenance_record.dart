enum MaintenanceType {
  beltReplacement('Troca de correia'),
  lubrication('Lubrificação'),
  bearingReplacement('Troca de rolamento'),
  generalInspection('Inspeção geral'),
  cleaning('Limpeza'),
  other('Outro');

  const MaintenanceType(this.label);
  final String label;
}

class MaintenanceRecord {
  MaintenanceRecord({
    required this.id,
    required this.barnId,
    required this.barnName,
    required this.motorId,
    required this.motorLine,
    required this.type,
    required this.description,
    required this.technician,
    required this.performedAt,
    this.notes = '',
  });

  final String id;
  final String barnId;
  final String barnName;
  final String motorId;
  final String motorLine;
  final MaintenanceType type;
  final String description;
  final String technician;
  final DateTime performedAt;
  final String notes;
}
