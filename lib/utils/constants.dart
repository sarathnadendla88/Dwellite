class Constants {
  static const String USER_TYPE_DATA = "USER_TYPE_DATA";
  static const int maxRetryAttempts = 3;
}

enum UserType {
  resident(1001),
  admin(1003),
  guard(1002);

  final int value;
  const UserType(this.value);
}

enum VisitorType {
  guest(2001),
  cab(2002),
  services(2003),
  maid(2004),
  maintanance(2004);

  final int value;
  const VisitorType(this.value);
}

enum VisitorStatus {
  pending(3001),
  inside(3002),
  out(3003),
  rejected(3004);

  final int value;
  const VisitorStatus(this.value);
}
