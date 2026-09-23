enum UserRole {
  customer('customer'),
  worker('worker'),
  admin('admin'),
  supervisor('supervisor');

  final String value;
  const UserRole(this.value);

  static UserRole? fromString(String? role) {
    if (role == 'customer') return UserRole.customer;
    if (role == 'worker') return UserRole.worker;
    if (role == 'admin') return UserRole.admin;
    if (role == 'supervisor') return UserRole.supervisor;
    return null;
  }
}
