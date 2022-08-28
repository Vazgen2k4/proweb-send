import 'package:equatable/equatable.dart';

class ProContact extends Equatable {
  final String name;
  final String phone;
  final String? image;

  const ProContact({
    required this.name,
    required this.phone,
    this.image,
  });

  ProContact copyWith({
    String? name,
    String? phone,
    String? image,
  }) {
    return ProContact(
      name: name ?? this.name,
      phone: phone ?? this.phone,
      image: image ?? this.image,
    );
  }

  @override
  List<Object?> get props => [name, phone, image];
}
