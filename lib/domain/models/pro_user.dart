import 'package:equatable/equatable.dart';

class ProUser extends Equatable {
  final String? name;
  final String? phone;
  final String? nikNameId;
  final String? email;
  final String? descr;
  final String? imagePath;
  final String? id;

  const ProUser({
    this.nikNameId,
    this.phone,
    this.imagePath,
    this.email,
    this.descr,
    this.name,
    this.id,
  });

  factory ProUser.fromJson(Map<String, dynamic>? json) {
    return ProUser(
      name: json?['name'],
      imagePath: json?['imagePath'],
      phone: json?['phone'],
      descr: json?['descr'],
      nikNameId: json?['nikNameId'],
      email: json?['email'],
    );
  }

  ProUser copyWith({
    String? nikNameId,
    String? imagePath,
    String? phone,
    String? descr,
    String? email,
    String? name,
    String? id,
  }) {
    return ProUser(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      nikNameId: nikNameId ?? this.nikNameId,
      descr: descr ?? this.descr,
      email: email ?? this.email,
      imagePath: imagePath ?? this.imagePath,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone': phone,
      'nikNameId': nikNameId,
      'email': email,
      'descr': descr,
      'imagePath': imagePath,
    };
  }

  @override
  List<Object?> get props {
    return [name, phone, nikNameId, id, descr, email, imagePath];
  }
}
