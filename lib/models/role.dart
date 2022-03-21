import 'package:cloud_firestore/cloud_firestore.dart';

class Role {
  Role(this.name, this.members);
  String name;
  List<String> members;
  String? id;
  factory Role.fromJson(Map<String, Object?> json) => roleFromJson(json);
  factory Role.fromSnapshot(DocumentSnapshot snapshot) =>
      roleFromSnapshot(snapshot);
  Map<String, Object?> toJson() => roleToJson(this);
  @override
  String toString() => toJson().toString();
}

Role roleFromJson(Map<String, Object?> json) {
  return Role(json["name"] as String, json["members"] as List<String>);
}

Map<String, Object?> roleToJson(Role r) {
  return {"name": r.name, "members": r.members};
}

Role roleFromSnapshot(DocumentSnapshot snapshot) {
  var role = roleFromJson(snapshot.data() as Map<String, dynamic>);
  role.id = snapshot.reference.id;
  return role;
}
