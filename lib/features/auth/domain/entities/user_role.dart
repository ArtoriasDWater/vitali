enum UserRole {
  paciente('Paciente', 'paciente'),
  medico('Cuidador', 'cuidador');

  final String label; // Texto para mostrar en la interfaz (UI)
  final String dbValue; // Texto para guardar en la base de datos

  const UserRole(this.label, this.dbValue);
}
