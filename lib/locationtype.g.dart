// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'locationtype.dart';

// **************************************************************************
// CollectionGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

class _Sentinel {
  const _Sentinel();
}

const _sentinel = _Sentinel();

/// A collection reference object can be used for adding documents,
/// getting document references, and querying for documents
/// (using the methods inherited from Query).
abstract class LocationTypeCollectionReference
    implements
        LocationTypeQuery,
        FirestoreCollectionReference<LocationTypeQuerySnapshot> {
  factory LocationTypeCollectionReference([
    FirebaseFirestore? firestore,
  ]) = _$LocationTypeCollectionReference;

  static LocationType fromFirestore(
      DocumentSnapshot<Map<String, Object?>> snapshot,
      SnapshotOptions? options,
      ) {
    return LocationType.fromJson(snapshot.data()!);
  }

  static Map<String, Object?> toFirestore(
      LocationType value,
      SetOptions? options,
      ) {
    return value.toJson();
  }

  @override
  LocationTypeDocumentReference doc([String? id]);

  /// Add a new document to this collection with the specified data,
  /// assigning it a document ID automatically.
  Future<LocationTypeDocumentReference> add(LocationType value);
}

class _$LocationTypeCollectionReference extends _$LocationTypeQuery
    implements LocationTypeCollectionReference {
  factory _$LocationTypeCollectionReference([FirebaseFirestore? firestore]) {
    firestore ??= FirebaseFirestore.instance;

    return _$LocationTypeCollectionReference._(
      firestore.collection('LocationTypes').withConverter(
        fromFirestore: LocationTypeCollectionReference.fromFirestore,
        toFirestore: LocationTypeCollectionReference.toFirestore,
      ),
    );
  }

  _$LocationTypeCollectionReference._(
      CollectionReference<LocationType> reference,
      ) : super(reference, reference);

  String get path => reference.path;

  @override
  CollectionReference<LocationType> get reference =>
      super.reference as CollectionReference<LocationType>;

  @override
  LocationTypeDocumentReference doc([String? id]) {
    return LocationTypeDocumentReference(
      reference.doc(id),
    );
  }

  @override
  Future<LocationTypeDocumentReference> add(LocationType value) {
    return reference
        .add(value)
        .then((ref) => LocationTypeDocumentReference(ref));
  }

  @override
  bool operator ==(Object other) {
    return other is _$LocationTypeCollectionReference &&
        other.runtimeType == runtimeType &&
        other.reference == reference;
  }

  @override
  int get hashCode => Object.hash(runtimeType, reference);
}

abstract class LocationTypeDocumentReference
    extends FirestoreDocumentReference<LocationTypeDocumentSnapshot> {
  factory LocationTypeDocumentReference(
      DocumentReference<LocationType> reference) =
  _$LocationTypeDocumentReference;

  DocumentReference<LocationType> get reference;

  /// A reference to the [LocationTypeCollectionReference] containing this document.
  LocationTypeCollectionReference get parent {
    return _$LocationTypeCollectionReference(reference.firestore);
  }

  @override
  Stream<LocationTypeDocumentSnapshot> snapshots();

  @override
  Future<LocationTypeDocumentSnapshot> get([GetOptions? options]);

  @override
  Future<void> delete();

  Future<void> update({
    String name,
  });

  Future<void> set(LocationType value);
}

class _$LocationTypeDocumentReference
    extends FirestoreDocumentReference<LocationTypeDocumentSnapshot>
    implements LocationTypeDocumentReference {
  _$LocationTypeDocumentReference(this.reference);

  @override
  final DocumentReference<LocationType> reference;

  /// A reference to the [LocationTypeCollectionReference] containing this document.
  LocationTypeCollectionReference get parent {
    return _$LocationTypeCollectionReference(reference.firestore);
  }

  @override
  Stream<LocationTypeDocumentSnapshot> snapshots() {
    return reference.snapshots().map((snapshot) {
      return LocationTypeDocumentSnapshot._(
        snapshot,
        snapshot.data(),
      );
    });
  }

  @override
  Future<LocationTypeDocumentSnapshot> get([GetOptions? options]) {
    return reference.get(options).then((snapshot) {
      return LocationTypeDocumentSnapshot._(
        snapshot,
        snapshot.data(),
      );
    });
  }

  @override
  Future<void> delete() {
    return reference.delete();
  }

  Future<void> update({
    Object? name = _sentinel,
  }) async {
    final json = {
      if (name != _sentinel) "name": name as String,
    };

    return reference.update(json);
  }

  Future<void> set(LocationType value) {
    return reference.set(value);
  }

  @override
  bool operator ==(Object other) {
    return other is LocationTypeDocumentReference &&
        other.runtimeType == runtimeType &&
        other.parent == parent &&
        other.id == id;
  }

  @override
  int get hashCode => Object.hash(runtimeType, parent, id);
}

class LocationTypeDocumentSnapshot extends FirestoreDocumentSnapshot {
  LocationTypeDocumentSnapshot._(
      this.snapshot,
      this.data,
      );

  @override
  final DocumentSnapshot<LocationType> snapshot;

  @override
  LocationTypeDocumentReference get reference {
    return LocationTypeDocumentReference(
      snapshot.reference,
    );
  }

  @override
  final LocationType? data;
}

abstract class LocationTypeQuery
    implements QueryReference<LocationTypeQuerySnapshot> {
  @override
  LocationTypeQuery limit(int limit);

  @override
  LocationTypeQuery limitToLast(int limit);

  LocationTypeQuery whereName({
    String? isEqualTo,
    String? isNotEqualTo,
    String? isLessThan,
    String? isLessThanOrEqualTo,
    String? isGreaterThan,
    String? isGreaterThanOrEqualTo,
    bool? isNull,
    List<String>? whereIn,
    List<String>? whereNotIn,
  });

  LocationTypeQuery orderByName({
    bool descending = false,
    String startAt,
    String startAfter,
    String endAt,
    String endBefore,
    LocationTypeDocumentSnapshot? startAtDocument,
    LocationTypeDocumentSnapshot? endAtDocument,
    LocationTypeDocumentSnapshot? endBeforeDocument,
    LocationTypeDocumentSnapshot? startAfterDocument,
  });
}

class _$LocationTypeQuery extends QueryReference<LocationTypeQuerySnapshot>
    implements LocationTypeQuery {
  _$LocationTypeQuery(
      this.reference,
      this._collection,
      );

  final CollectionReference<Object?> _collection;

  @override
  final Query<LocationType> reference;

  LocationTypeQuerySnapshot _decodeSnapshot(
      QuerySnapshot<LocationType> snapshot,
      ) {
    final docs = snapshot.docs.map((e) {
      return LocationTypeQueryDocumentSnapshot._(e, e.data());
    }).toList();

    final docChanges = snapshot.docChanges.map((change) {
      return FirestoreDocumentChange<LocationTypeDocumentSnapshot>(
        type: change.type,
        oldIndex: change.oldIndex,
        newIndex: change.newIndex,
        doc: LocationTypeDocumentSnapshot._(change.doc, change.doc.data()),
      );
    }).toList();

    return LocationTypeQuerySnapshot._(
      snapshot,
      docs,
      docChanges,
    );
  }

  @override
  Stream<LocationTypeQuerySnapshot> snapshots([SnapshotOptions? options]) {
    return reference.snapshots().map(_decodeSnapshot);
  }

  @override
  Future<LocationTypeQuerySnapshot> get([GetOptions? options]) {
    return reference.get(options).then(_decodeSnapshot);
  }

  @override
  LocationTypeQuery limit(int limit) {
    return _$LocationTypeQuery(
      reference.limit(limit),
      _collection,
    );
  }

  @override
  LocationTypeQuery limitToLast(int limit) {
    return _$LocationTypeQuery(
      reference.limitToLast(limit),
      _collection,
    );
  }

  LocationTypeQuery whereName({
    String? isEqualTo,
    String? isNotEqualTo,
    String? isLessThan,
    String? isLessThanOrEqualTo,
    String? isGreaterThan,
    String? isGreaterThanOrEqualTo,
    bool? isNull,
    List<String>? whereIn,
    List<String>? whereNotIn,
  }) {
    return _$LocationTypeQuery(
      reference.where(
        'name',
        isEqualTo: isEqualTo,
        isNotEqualTo: isNotEqualTo,
        isLessThan: isLessThan,
        isLessThanOrEqualTo: isLessThanOrEqualTo,
        isGreaterThan: isGreaterThan,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo,
        isNull: isNull,
        whereIn: whereIn,
        whereNotIn: whereNotIn,
      ),
      _collection,
    );
  }

  LocationTypeQuery orderByName({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    LocationTypeDocumentSnapshot? startAtDocument,
    LocationTypeDocumentSnapshot? endAtDocument,
    LocationTypeDocumentSnapshot? endBeforeDocument,
    LocationTypeDocumentSnapshot? startAfterDocument,
  }) {
    var query = reference.orderBy('name', descending: descending);

    if (startAtDocument != null) {
      query = query.startAtDocument(startAtDocument.snapshot);
    }
    if (startAfterDocument != null) {
      query = query.startAfterDocument(startAfterDocument.snapshot);
    }
    if (endAtDocument != null) {
      query = query.endAtDocument(endAtDocument.snapshot);
    }
    if (endBeforeDocument != null) {
      query = query.endBeforeDocument(endBeforeDocument.snapshot);
    }

    if (startAt != _sentinel) {
      query = query.startAt([startAt]);
    }
    if (startAfter != _sentinel) {
      query = query.startAfter([startAfter]);
    }
    if (endAt != _sentinel) {
      query = query.endAt([endAt]);
    }
    if (endBefore != _sentinel) {
      query = query.endBefore([endBefore]);
    }

    return _$LocationTypeQuery(query, _collection);
  }

  @override
  bool operator ==(Object other) {
    return other is _$LocationTypeQuery &&
        other.runtimeType == runtimeType &&
        other.reference == reference;
  }

  @override
  int get hashCode => Object.hash(runtimeType, reference);
}

class LocationTypeQuerySnapshot
    extends FirestoreQuerySnapshot<LocationTypeQueryDocumentSnapshot> {
  LocationTypeQuerySnapshot._(
      this.snapshot,
      this.docs,
      this.docChanges,
      );

  final QuerySnapshot<LocationType> snapshot;

  @override
  final List<LocationTypeQueryDocumentSnapshot> docs;

  @override
  final List<FirestoreDocumentChange<LocationTypeDocumentSnapshot>> docChanges;
}

class LocationTypeQueryDocumentSnapshot extends FirestoreQueryDocumentSnapshot
    implements LocationTypeDocumentSnapshot {
  LocationTypeQueryDocumentSnapshot._(this.snapshot, this.data);

  @override
  final QueryDocumentSnapshot<LocationType> snapshot;

  @override
  LocationTypeDocumentReference get reference {
    return LocationTypeDocumentReference(snapshot.reference);
  }

  @override
  final LocationType data;
}

/// A collection reference object can be used for adding documents,
/// getting document references, and querying for documents
/// (using the methods inherited from Query).
abstract class LocationCollectionReference
    implements
        LocationQuery,
        FirestoreCollectionReference<LocationQuerySnapshot> {
  factory LocationCollectionReference([
    FirebaseFirestore? firestore,
  ]) = _$LocationCollectionReference;

  static Location fromFirestore(
      DocumentSnapshot<Map<String, Object?>> snapshot,
      SnapshotOptions? options,
      ) {
    return Location.fromJson(snapshot.data()!);
  }

  static Map<String, Object?> toFirestore(
      Location value,
      SetOptions? options,
      ) {
    return value.toJson();
  }

  @override
  LocationDocumentReference doc([String? id]);

  /// Add a new document to this collection with the specified data,
  /// assigning it a document ID automatically.
  Future<LocationDocumentReference> add(Location value);
}

class _$LocationCollectionReference extends _$LocationQuery
    implements LocationCollectionReference {
  factory _$LocationCollectionReference([FirebaseFirestore? firestore]) {
    firestore ??= FirebaseFirestore.instance;

    return _$LocationCollectionReference._(
      firestore.collection('Locations').withConverter(
        fromFirestore: LocationCollectionReference.fromFirestore,
        toFirestore: LocationCollectionReference.toFirestore,
      ),
    );
  }

  _$LocationCollectionReference._(
      CollectionReference<Location> reference,
      ) : super(reference, reference);

  String get path => reference.path;

  @override
  CollectionReference<Location> get reference =>
      super.reference as CollectionReference<Location>;

  @override
  LocationDocumentReference doc([String? id]) {
    return LocationDocumentReference(
      reference.doc(id),
    );
  }

  @override
  Future<LocationDocumentReference> add(Location value) {
    return reference.add(value).then((ref) => LocationDocumentReference(ref));
  }

  @override
  bool operator ==(Object other) {
    return other is _$LocationCollectionReference &&
        other.runtimeType == runtimeType &&
        other.reference == reference;
  }

  @override
  int get hashCode => Object.hash(runtimeType, reference);
}

abstract class LocationDocumentReference
    extends FirestoreDocumentReference<LocationDocumentSnapshot> {
  factory LocationDocumentReference(DocumentReference<Location> reference) =
  _$LocationDocumentReference;

  DocumentReference<Location> get reference;

  /// A reference to the [LocationCollectionReference] containing this document.
  LocationCollectionReference get parent {
    return _$LocationCollectionReference(reference.firestore);
  }

  @override
  Stream<LocationDocumentSnapshot> snapshots();

  @override
  Future<LocationDocumentSnapshot> get([GetOptions? options]);

  @override
  Future<void> delete();

  Future<void> set(Location value);
}

class _$LocationDocumentReference
    extends FirestoreDocumentReference<LocationDocumentSnapshot>
    implements LocationDocumentReference {
  _$LocationDocumentReference(this.reference);

  @override
  final DocumentReference<Location> reference;

  /// A reference to the [LocationCollectionReference] containing this document.
  LocationCollectionReference get parent {
    return _$LocationCollectionReference(reference.firestore);
  }

  @override
  Stream<LocationDocumentSnapshot> snapshots() {
    return reference.snapshots().map((snapshot) {
      return LocationDocumentSnapshot._(
        snapshot,
        snapshot.data(),
      );
    });
  }

  @override
  Future<LocationDocumentSnapshot> get([GetOptions? options]) {
    return reference.get(options).then((snapshot) {
      return LocationDocumentSnapshot._(
        snapshot,
        snapshot.data(),
      );
    });
  }

  @override
  Future<void> delete() {
    return reference.delete();
  }

  Future<void> set(Location value) {
    return reference.set(value);
  }

  @override
  bool operator ==(Object other) {
    return other is LocationDocumentReference &&
        other.runtimeType == runtimeType &&
        other.parent == parent &&
        other.id == id;
  }

  @override
  int get hashCode => Object.hash(runtimeType, parent, id);
}

class LocationDocumentSnapshot extends FirestoreDocumentSnapshot {
  LocationDocumentSnapshot._(
      this.snapshot,
      this.data,
      );

  @override
  final DocumentSnapshot<Location> snapshot;

  @override
  LocationDocumentReference get reference {
    return LocationDocumentReference(
      snapshot.reference,
    );
  }

  @override
  final Location? data;
}

abstract class LocationQuery implements QueryReference<LocationQuerySnapshot> {
  @override
  LocationQuery limit(int limit);

  @override
  LocationQuery limitToLast(int limit);
}

class _$LocationQuery extends QueryReference<LocationQuerySnapshot>
    implements LocationQuery {
  _$LocationQuery(
      this.reference,
      this._collection,
      );

  final CollectionReference<Object?> _collection;

  @override
  final Query<Location> reference;

  LocationQuerySnapshot _decodeSnapshot(
      QuerySnapshot<Location> snapshot,
      ) {
    final docs = snapshot.docs.map((e) {
      return LocationQueryDocumentSnapshot._(e, e.data());
    }).toList();

    final docChanges = snapshot.docChanges.map((change) {
      return FirestoreDocumentChange<LocationDocumentSnapshot>(
        type: change.type,
        oldIndex: change.oldIndex,
        newIndex: change.newIndex,
        doc: LocationDocumentSnapshot._(change.doc, change.doc.data()),
      );
    }).toList();

    return LocationQuerySnapshot._(
      snapshot,
      docs,
      docChanges,
    );
  }

  @override
  Stream<LocationQuerySnapshot> snapshots([SnapshotOptions? options]) {
    return reference.snapshots().map(_decodeSnapshot);
  }

  @override
  Future<LocationQuerySnapshot> get([GetOptions? options]) {
    return reference.get(options).then(_decodeSnapshot);
  }

  @override
  LocationQuery limit(int limit) {
    return _$LocationQuery(
      reference.limit(limit),
      _collection,
    );
  }

  @override
  LocationQuery limitToLast(int limit) {
    return _$LocationQuery(
      reference.limitToLast(limit),
      _collection,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is _$LocationQuery &&
        other.runtimeType == runtimeType &&
        other.reference == reference;
  }

  @override
  int get hashCode => Object.hash(runtimeType, reference);
}

class LocationQuerySnapshot
    extends FirestoreQuerySnapshot<LocationQueryDocumentSnapshot> {
  LocationQuerySnapshot._(
      this.snapshot,
      this.docs,
      this.docChanges,
      );

  final QuerySnapshot<Location> snapshot;

  @override
  final List<LocationQueryDocumentSnapshot> docs;

  @override
  final List<FirestoreDocumentChange<LocationDocumentSnapshot>> docChanges;
}

class LocationQueryDocumentSnapshot extends FirestoreQueryDocumentSnapshot
    implements LocationDocumentSnapshot {
  LocationQueryDocumentSnapshot._(this.snapshot, this.data);

  @override
  final QueryDocumentSnapshot<Location> snapshot;

  @override
  LocationDocumentReference get reference {
    return LocationDocumentReference(snapshot.reference);
  }

  @override
  final Location data;
}

/// A collection reference object can be used for adding documents,
/// getting document references, and querying for documents
/// (using the methods inherited from Query).
abstract class RoleCollectionReference
    implements RoleQuery, FirestoreCollectionReference<RoleQuerySnapshot> {
  factory RoleCollectionReference([
    FirebaseFirestore? firestore,
  ]) = _$RoleCollectionReference;

  static Role fromFirestore(
      DocumentSnapshot<Map<String, Object?>> snapshot,
      SnapshotOptions? options,
      ) {
    return Role.fromJson(snapshot.data()!);
  }

  static Map<String, Object?> toFirestore(
      Role value,
      SetOptions? options,
      ) {
    return value.toJson();
  }

  @override
  RoleDocumentReference doc([String? id]);

  /// Add a new document to this collection with the specified data,
  /// assigning it a document ID automatically.
  Future<RoleDocumentReference> add(Role value);
}

class _$RoleCollectionReference extends _$RoleQuery
    implements RoleCollectionReference {
  factory _$RoleCollectionReference([FirebaseFirestore? firestore]) {
    firestore ??= FirebaseFirestore.instance;

    return _$RoleCollectionReference._(
      firestore.collection('Roles').withConverter(
        fromFirestore: RoleCollectionReference.fromFirestore,
        toFirestore: RoleCollectionReference.toFirestore,
      ),
    );
  }

  _$RoleCollectionReference._(
      CollectionReference<Role> reference,
      ) : super(reference, reference);

  String get path => reference.path;

  @override
  CollectionReference<Role> get reference =>
      super.reference as CollectionReference<Role>;

  @override
  RoleDocumentReference doc([String? id]) {
    return RoleDocumentReference(
      reference.doc(id),
    );
  }

  @override
  Future<RoleDocumentReference> add(Role value) {
    return reference.add(value).then((ref) => RoleDocumentReference(ref));
  }

  @override
  bool operator ==(Object other) {
    return other is _$RoleCollectionReference &&
        other.runtimeType == runtimeType &&
        other.reference == reference;
  }

  @override
  int get hashCode => Object.hash(runtimeType, reference);
}

abstract class RoleDocumentReference
    extends FirestoreDocumentReference<RoleDocumentSnapshot> {
  factory RoleDocumentReference(DocumentReference<Role> reference) =
  _$RoleDocumentReference;

  DocumentReference<Role> get reference;

  /// A reference to the [RoleCollectionReference] containing this document.
  RoleCollectionReference get parent {
    return _$RoleCollectionReference(reference.firestore);
  }

  @override
  Stream<RoleDocumentSnapshot> snapshots();

  @override
  Future<RoleDocumentSnapshot> get([GetOptions? options]);

  @override
  Future<void> delete();

  Future<void> update({
    String name,
  });

  Future<void> set(Role value);
}

class _$RoleDocumentReference
    extends FirestoreDocumentReference<RoleDocumentSnapshot>
    implements RoleDocumentReference {
  _$RoleDocumentReference(this.reference);

  @override
  final DocumentReference<Role> reference;

  /// A reference to the [RoleCollectionReference] containing this document.
  RoleCollectionReference get parent {
    return _$RoleCollectionReference(reference.firestore);
  }

  @override
  Stream<RoleDocumentSnapshot> snapshots() {
    return reference.snapshots().map((snapshot) {
      return RoleDocumentSnapshot._(
        snapshot,
        snapshot.data(),
      );
    });
  }

  @override
  Future<RoleDocumentSnapshot> get([GetOptions? options]) {
    return reference.get(options).then((snapshot) {
      return RoleDocumentSnapshot._(
        snapshot,
        snapshot.data(),
      );
    });
  }

  @override
  Future<void> delete() {
    return reference.delete();
  }

  Future<void> update({
    Object? name = _sentinel,
  }) async {
    final json = {
      if (name != _sentinel) "name": name as String,
    };

    return reference.update(json);
  }

  Future<void> set(Role value) {
    return reference.set(value);
  }

  @override
  bool operator ==(Object other) {
    return other is RoleDocumentReference &&
        other.runtimeType == runtimeType &&
        other.parent == parent &&
        other.id == id;
  }

  @override
  int get hashCode => Object.hash(runtimeType, parent, id);
}

class RoleDocumentSnapshot extends FirestoreDocumentSnapshot {
  RoleDocumentSnapshot._(
      this.snapshot,
      this.data,
      );

  @override
  final DocumentSnapshot<Role> snapshot;

  @override
  RoleDocumentReference get reference {
    return RoleDocumentReference(
      snapshot.reference,
    );
  }

  @override
  final Role? data;
}

abstract class RoleQuery implements QueryReference<RoleQuerySnapshot> {
  @override
  RoleQuery limit(int limit);

  @override
  RoleQuery limitToLast(int limit);

  RoleQuery whereName({
    String? isEqualTo,
    String? isNotEqualTo,
    String? isLessThan,
    String? isLessThanOrEqualTo,
    String? isGreaterThan,
    String? isGreaterThanOrEqualTo,
    bool? isNull,
    List<String>? whereIn,
    List<String>? whereNotIn,
  });

  RoleQuery orderByName({
    bool descending = false,
    String startAt,
    String startAfter,
    String endAt,
    String endBefore,
    RoleDocumentSnapshot? startAtDocument,
    RoleDocumentSnapshot? endAtDocument,
    RoleDocumentSnapshot? endBeforeDocument,
    RoleDocumentSnapshot? startAfterDocument,
  });
}

class _$RoleQuery extends QueryReference<RoleQuerySnapshot>
    implements RoleQuery {
  _$RoleQuery(
      this.reference,
      this._collection,
      );

  final CollectionReference<Object?> _collection;

  @override
  final Query<Role> reference;

  RoleQuerySnapshot _decodeSnapshot(
      QuerySnapshot<Role> snapshot,
      ) {
    final docs = snapshot.docs.map((e) {
      return RoleQueryDocumentSnapshot._(e, e.data());
    }).toList();

    final docChanges = snapshot.docChanges.map((change) {
      return FirestoreDocumentChange<RoleDocumentSnapshot>(
        type: change.type,
        oldIndex: change.oldIndex,
        newIndex: change.newIndex,
        doc: RoleDocumentSnapshot._(change.doc, change.doc.data()),
      );
    }).toList();

    return RoleQuerySnapshot._(
      snapshot,
      docs,
      docChanges,
    );
  }

  @override
  Stream<RoleQuerySnapshot> snapshots([SnapshotOptions? options]) {
    return reference.snapshots().map(_decodeSnapshot);
  }

  @override
  Future<RoleQuerySnapshot> get([GetOptions? options]) {
    return reference.get(options).then(_decodeSnapshot);
  }

  @override
  RoleQuery limit(int limit) {
    return _$RoleQuery(
      reference.limit(limit),
      _collection,
    );
  }

  @override
  RoleQuery limitToLast(int limit) {
    return _$RoleQuery(
      reference.limitToLast(limit),
      _collection,
    );
  }

  RoleQuery whereName({
    String? isEqualTo,
    String? isNotEqualTo,
    String? isLessThan,
    String? isLessThanOrEqualTo,
    String? isGreaterThan,
    String? isGreaterThanOrEqualTo,
    bool? isNull,
    List<String>? whereIn,
    List<String>? whereNotIn,
  }) {
    return _$RoleQuery(
      reference.where(
        'name',
        isEqualTo: isEqualTo,
        isNotEqualTo: isNotEqualTo,
        isLessThan: isLessThan,
        isLessThanOrEqualTo: isLessThanOrEqualTo,
        isGreaterThan: isGreaterThan,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo,
        isNull: isNull,
        whereIn: whereIn,
        whereNotIn: whereNotIn,
      ),
      _collection,
    );
  }

  RoleQuery orderByName({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    RoleDocumentSnapshot? startAtDocument,
    RoleDocumentSnapshot? endAtDocument,
    RoleDocumentSnapshot? endBeforeDocument,
    RoleDocumentSnapshot? startAfterDocument,
  }) {
    var query = reference.orderBy('name', descending: descending);

    if (startAtDocument != null) {
      query = query.startAtDocument(startAtDocument.snapshot);
    }
    if (startAfterDocument != null) {
      query = query.startAfterDocument(startAfterDocument.snapshot);
    }
    if (endAtDocument != null) {
      query = query.endAtDocument(endAtDocument.snapshot);
    }
    if (endBeforeDocument != null) {
      query = query.endBeforeDocument(endBeforeDocument.snapshot);
    }

    if (startAt != _sentinel) {
      query = query.startAt([startAt]);
    }
    if (startAfter != _sentinel) {
      query = query.startAfter([startAfter]);
    }
    if (endAt != _sentinel) {
      query = query.endAt([endAt]);
    }
    if (endBefore != _sentinel) {
      query = query.endBefore([endBefore]);
    }

    return _$RoleQuery(query, _collection);
  }

  @override
  bool operator ==(Object other) {
    return other is _$RoleQuery &&
        other.runtimeType == runtimeType &&
        other.reference == reference;
  }

  @override
  int get hashCode => Object.hash(runtimeType, reference);
}

class RoleQuerySnapshot
    extends FirestoreQuerySnapshot<RoleQueryDocumentSnapshot> {
  RoleQuerySnapshot._(
      this.snapshot,
      this.docs,
      this.docChanges,
      );

  final QuerySnapshot<Role> snapshot;

  @override
  final List<RoleQueryDocumentSnapshot> docs;

  @override
  final List<FirestoreDocumentChange<RoleDocumentSnapshot>> docChanges;
}

class RoleQueryDocumentSnapshot extends FirestoreQueryDocumentSnapshot
    implements RoleDocumentSnapshot {
  RoleQueryDocumentSnapshot._(this.snapshot, this.data);

  @override
  final QueryDocumentSnapshot<Role> snapshot;

  @override
  RoleDocumentReference get reference {
    return RoleDocumentReference(snapshot.reference);
  }

  @override
  final Role data;
}

/// A collection reference object can be used for adding documents,
/// getting document references, and querying for documents
/// (using the methods inherited from Query).
abstract class EventCollectionReference
    implements EventQuery, FirestoreCollectionReference<EventQuerySnapshot> {
  factory EventCollectionReference([
    FirebaseFirestore? firestore,
  ]) = _$EventCollectionReference;

  static Event fromFirestore(
      DocumentSnapshot<Map<String, Object?>> snapshot,
      SnapshotOptions? options,
      ) {
    return Event.fromJson(snapshot.data()!);
  }

  static Map<String, Object?> toFirestore(
      Event value,
      SetOptions? options,
      ) {
    return value.toJson();
  }

  @override
  EventDocumentReference doc([String? id]);

  /// Add a new document to this collection with the specified data,
  /// assigning it a document ID automatically.
  Future<EventDocumentReference> add(Event value);
}

class _$EventCollectionReference extends _$EventQuery
    implements EventCollectionReference {
  factory _$EventCollectionReference([FirebaseFirestore? firestore]) {
    firestore ??= FirebaseFirestore.instance;

    return _$EventCollectionReference._(
      firestore.collection('Events').withConverter(
        fromFirestore: EventCollectionReference.fromFirestore,
        toFirestore: EventCollectionReference.toFirestore,
      ),
    );
  }

  _$EventCollectionReference._(
      CollectionReference<Event> reference,
      ) : super(reference, reference);

  String get path => reference.path;

  @override
  CollectionReference<Event> get reference =>
      super.reference as CollectionReference<Event>;

  @override
  EventDocumentReference doc([String? id]) {
    return EventDocumentReference(
      reference.doc(id),
    );
  }

  @override
  Future<EventDocumentReference> add(Event value) {
    return reference.add(value).then((ref) => EventDocumentReference(ref));
  }

  @override
  bool operator ==(Object other) {
    return other is _$EventCollectionReference &&
        other.runtimeType == runtimeType &&
        other.reference == reference;
  }

  @override
  int get hashCode => Object.hash(runtimeType, reference);
}

abstract class EventDocumentReference
    extends FirestoreDocumentReference<EventDocumentSnapshot> {
  factory EventDocumentReference(DocumentReference<Event> reference) =
  _$EventDocumentReference;

  DocumentReference<Event> get reference;

  /// A reference to the [EventCollectionReference] containing this document.
  EventCollectionReference get parent {
    return _$EventCollectionReference(reference.firestore);
  }

  @override
  Stream<EventDocumentSnapshot> snapshots();

  @override
  Future<EventDocumentSnapshot> get([GetOptions? options]);

  @override
  Future<void> delete();

  Future<void> update({
    String name,
    String description,
    bool complete,
    bool publish,
    List<String> organizers,
    List<String> participants,
    List<String> beforePictures,
    List<String> afterPictures,
    num garbageCollected,
  });

  Future<void> set(Event value);
}

class _$EventDocumentReference
    extends FirestoreDocumentReference<EventDocumentSnapshot>
    implements EventDocumentReference {
  _$EventDocumentReference(this.reference);

  @override
  final DocumentReference<Event> reference;

  /// A reference to the [EventCollectionReference] containing this document.
  EventCollectionReference get parent {
    return _$EventCollectionReference(reference.firestore);
  }

  @override
  Stream<EventDocumentSnapshot> snapshots() {
    return reference.snapshots().map((snapshot) {
      return EventDocumentSnapshot._(
        snapshot,
        snapshot.data(),
      );
    });
  }

  @override
  Future<EventDocumentSnapshot> get([GetOptions? options]) {
    return reference.get(options).then((snapshot) {
      return EventDocumentSnapshot._(
        snapshot,
        snapshot.data(),
      );
    });
  }

  @override
  Future<void> delete() {
    return reference.delete();
  }

  Future<void> update({
    Object? name = _sentinel,
    Object? description = _sentinel,
    Object? complete = _sentinel,
    Object? publish = _sentinel,
    Object? organizers = _sentinel,
    Object? participants = _sentinel,
    Object? beforePictures = _sentinel,
    Object? afterPictures = _sentinel,
    Object? garbageCollected = _sentinel,
  }) async {
    final json = {
      if (name != _sentinel) "name": name as String,
      if (description != _sentinel) "description": description as String,
      if (complete != _sentinel) "complete": complete as bool,
      if (publish != _sentinel) "publish": publish as bool,
      if (organizers != _sentinel) "organizers": organizers as List<String>,
      if (participants != _sentinel)
        "participants": participants as List<String>,
      if (beforePictures != _sentinel)
        "beforePictures": beforePictures as List<String>,
      if (afterPictures != _sentinel)
        "afterPictures": afterPictures as List<String>,
      if (garbageCollected != _sentinel)
        "garbageCollected": garbageCollected as num,
    };

    return reference.update(json);
  }

  Future<void> set(Event value) {
    return reference.set(value);
  }

  @override
  bool operator ==(Object other) {
    return other is EventDocumentReference &&
        other.runtimeType == runtimeType &&
        other.parent == parent &&
        other.id == id;
  }

  @override
  int get hashCode => Object.hash(runtimeType, parent, id);
}

class EventDocumentSnapshot extends FirestoreDocumentSnapshot {
  EventDocumentSnapshot._(
      this.snapshot,
      this.data,
      );

  @override
  final DocumentSnapshot<Event> snapshot;

  @override
  EventDocumentReference get reference {
    return EventDocumentReference(
      snapshot.reference,
    );
  }

  @override
  final Event? data;
}

abstract class EventQuery implements QueryReference<EventQuerySnapshot> {
  @override
  EventQuery limit(int limit);

  @override
  EventQuery limitToLast(int limit);

  EventQuery whereName({
    String? isEqualTo,
    String? isNotEqualTo,
    String? isLessThan,
    String? isLessThanOrEqualTo,
    String? isGreaterThan,
    String? isGreaterThanOrEqualTo,
    bool? isNull,
    List<String>? whereIn,
    List<String>? whereNotIn,
  });
  EventQuery whereDescription({
    String? isEqualTo,
    String? isNotEqualTo,
    String? isLessThan,
    String? isLessThanOrEqualTo,
    String? isGreaterThan,
    String? isGreaterThanOrEqualTo,
    bool? isNull,
    List<String>? whereIn,
    List<String>? whereNotIn,
  });
  EventQuery whereComplete({
    bool? isEqualTo,
    bool? isNotEqualTo,
    bool? isLessThan,
    bool? isLessThanOrEqualTo,
    bool? isGreaterThan,
    bool? isGreaterThanOrEqualTo,
    bool? isNull,
    List<bool>? whereIn,
    List<bool>? whereNotIn,
  });
  EventQuery wherePublish({
    bool? isEqualTo,
    bool? isNotEqualTo,
    bool? isLessThan,
    bool? isLessThanOrEqualTo,
    bool? isGreaterThan,
    bool? isGreaterThanOrEqualTo,
    bool? isNull,
    List<bool>? whereIn,
    List<bool>? whereNotIn,
  });
  EventQuery whereOrganizers({
    List<String>? isEqualTo,
    List<String>? isNotEqualTo,
    List<String>? isLessThan,
    List<String>? isLessThanOrEqualTo,
    List<String>? isGreaterThan,
    List<String>? isGreaterThanOrEqualTo,
    bool? isNull,
    List<String>? arrayContainsAny,
  });
  EventQuery whereParticipants({
    List<String>? isEqualTo,
    List<String>? isNotEqualTo,
    List<String>? isLessThan,
    List<String>? isLessThanOrEqualTo,
    List<String>? isGreaterThan,
    List<String>? isGreaterThanOrEqualTo,
    bool? isNull,
    List<String>? arrayContainsAny,
  });
  EventQuery whereBeforePictures({
    List<String>? isEqualTo,
    List<String>? isNotEqualTo,
    List<String>? isLessThan,
    List<String>? isLessThanOrEqualTo,
    List<String>? isGreaterThan,
    List<String>? isGreaterThanOrEqualTo,
    bool? isNull,
    List<String>? arrayContainsAny,
  });
  EventQuery whereAfterPictures({
    List<String>? isEqualTo,
    List<String>? isNotEqualTo,
    List<String>? isLessThan,
    List<String>? isLessThanOrEqualTo,
    List<String>? isGreaterThan,
    List<String>? isGreaterThanOrEqualTo,
    bool? isNull,
    List<String>? arrayContainsAny,
  });
  EventQuery whereGarbageCollected({
    num? isEqualTo,
    num? isNotEqualTo,
    num? isLessThan,
    num? isLessThanOrEqualTo,
    num? isGreaterThan,
    num? isGreaterThanOrEqualTo,
    bool? isNull,
    List<num>? whereIn,
    List<num>? whereNotIn,
  });

  EventQuery orderByName({
    bool descending = false,
    String startAt,
    String startAfter,
    String endAt,
    String endBefore,
    EventDocumentSnapshot? startAtDocument,
    EventDocumentSnapshot? endAtDocument,
    EventDocumentSnapshot? endBeforeDocument,
    EventDocumentSnapshot? startAfterDocument,
  });

  EventQuery orderByDescription({
    bool descending = false,
    String startAt,
    String startAfter,
    String endAt,
    String endBefore,
    EventDocumentSnapshot? startAtDocument,
    EventDocumentSnapshot? endAtDocument,
    EventDocumentSnapshot? endBeforeDocument,
    EventDocumentSnapshot? startAfterDocument,
  });

  EventQuery orderByComplete({
    bool descending = false,
    bool startAt,
    bool startAfter,
    bool endAt,
    bool endBefore,
    EventDocumentSnapshot? startAtDocument,
    EventDocumentSnapshot? endAtDocument,
    EventDocumentSnapshot? endBeforeDocument,
    EventDocumentSnapshot? startAfterDocument,
  });

  EventQuery orderByPublish({
    bool descending = false,
    bool startAt,
    bool startAfter,
    bool endAt,
    bool endBefore,
    EventDocumentSnapshot? startAtDocument,
    EventDocumentSnapshot? endAtDocument,
    EventDocumentSnapshot? endBeforeDocument,
    EventDocumentSnapshot? startAfterDocument,
  });

  EventQuery orderByOrganizers({
    bool descending = false,
    List<String> startAt,
    List<String> startAfter,
    List<String> endAt,
    List<String> endBefore,
    EventDocumentSnapshot? startAtDocument,
    EventDocumentSnapshot? endAtDocument,
    EventDocumentSnapshot? endBeforeDocument,
    EventDocumentSnapshot? startAfterDocument,
  });

  EventQuery orderByParticipants({
    bool descending = false,
    List<String> startAt,
    List<String> startAfter,
    List<String> endAt,
    List<String> endBefore,
    EventDocumentSnapshot? startAtDocument,
    EventDocumentSnapshot? endAtDocument,
    EventDocumentSnapshot? endBeforeDocument,
    EventDocumentSnapshot? startAfterDocument,
  });

  EventQuery orderByBeforePictures({
    bool descending = false,
    List<String> startAt,
    List<String> startAfter,
    List<String> endAt,
    List<String> endBefore,
    EventDocumentSnapshot? startAtDocument,
    EventDocumentSnapshot? endAtDocument,
    EventDocumentSnapshot? endBeforeDocument,
    EventDocumentSnapshot? startAfterDocument,
  });

  EventQuery orderByAfterPictures({
    bool descending = false,
    List<String> startAt,
    List<String> startAfter,
    List<String> endAt,
    List<String> endBefore,
    EventDocumentSnapshot? startAtDocument,
    EventDocumentSnapshot? endAtDocument,
    EventDocumentSnapshot? endBeforeDocument,
    EventDocumentSnapshot? startAfterDocument,
  });

  EventQuery orderByGarbageCollected({
    bool descending = false,
    num startAt,
    num startAfter,
    num endAt,
    num endBefore,
    EventDocumentSnapshot? startAtDocument,
    EventDocumentSnapshot? endAtDocument,
    EventDocumentSnapshot? endBeforeDocument,
    EventDocumentSnapshot? startAfterDocument,
  });
}

class _$EventQuery extends QueryReference<EventQuerySnapshot>
    implements EventQuery {
  _$EventQuery(
      this.reference,
      this._collection,
      );

  final CollectionReference<Object?> _collection;

  @override
  final Query<Event> reference;

  EventQuerySnapshot _decodeSnapshot(
      QuerySnapshot<Event> snapshot,
      ) {
    final docs = snapshot.docs.map((e) {
      return EventQueryDocumentSnapshot._(e, e.data());
    }).toList();

    final docChanges = snapshot.docChanges.map((change) {
      return FirestoreDocumentChange<EventDocumentSnapshot>(
        type: change.type,
        oldIndex: change.oldIndex,
        newIndex: change.newIndex,
        doc: EventDocumentSnapshot._(change.doc, change.doc.data()),
      );
    }).toList();

    return EventQuerySnapshot._(
      snapshot,
      docs,
      docChanges,
    );
  }

  @override
  Stream<EventQuerySnapshot> snapshots([SnapshotOptions? options]) {
    return reference.snapshots().map(_decodeSnapshot);
  }

  @override
  Future<EventQuerySnapshot> get([GetOptions? options]) {
    return reference.get(options).then(_decodeSnapshot);
  }

  @override
  EventQuery limit(int limit) {
    return _$EventQuery(
      reference.limit(limit),
      _collection,
    );
  }

  @override
  EventQuery limitToLast(int limit) {
    return _$EventQuery(
      reference.limitToLast(limit),
      _collection,
    );
  }

  EventQuery whereName({
    String? isEqualTo,
    String? isNotEqualTo,
    String? isLessThan,
    String? isLessThanOrEqualTo,
    String? isGreaterThan,
    String? isGreaterThanOrEqualTo,
    bool? isNull,
    List<String>? whereIn,
    List<String>? whereNotIn,
  }) {
    return _$EventQuery(
      reference.where(
        'name',
        isEqualTo: isEqualTo,
        isNotEqualTo: isNotEqualTo,
        isLessThan: isLessThan,
        isLessThanOrEqualTo: isLessThanOrEqualTo,
        isGreaterThan: isGreaterThan,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo,
        isNull: isNull,
        whereIn: whereIn,
        whereNotIn: whereNotIn,
      ),
      _collection,
    );
  }

  EventQuery whereDescription({
    String? isEqualTo,
    String? isNotEqualTo,
    String? isLessThan,
    String? isLessThanOrEqualTo,
    String? isGreaterThan,
    String? isGreaterThanOrEqualTo,
    bool? isNull,
    List<String>? whereIn,
    List<String>? whereNotIn,
  }) {
    return _$EventQuery(
      reference.where(
        'description',
        isEqualTo: isEqualTo,
        isNotEqualTo: isNotEqualTo,
        isLessThan: isLessThan,
        isLessThanOrEqualTo: isLessThanOrEqualTo,
        isGreaterThan: isGreaterThan,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo,
        isNull: isNull,
        whereIn: whereIn,
        whereNotIn: whereNotIn,
      ),
      _collection,
    );
  }

  EventQuery whereComplete({
    bool? isEqualTo,
    bool? isNotEqualTo,
    bool? isLessThan,
    bool? isLessThanOrEqualTo,
    bool? isGreaterThan,
    bool? isGreaterThanOrEqualTo,
    bool? isNull,
    List<bool>? whereIn,
    List<bool>? whereNotIn,
  }) {
    return _$EventQuery(
      reference.where(
        'complete',
        isEqualTo: isEqualTo,
        isNotEqualTo: isNotEqualTo,
        isLessThan: isLessThan,
        isLessThanOrEqualTo: isLessThanOrEqualTo,
        isGreaterThan: isGreaterThan,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo,
        isNull: isNull,
        whereIn: whereIn,
        whereNotIn: whereNotIn,
      ),
      _collection,
    );
  }

  EventQuery wherePublish({
    bool? isEqualTo,
    bool? isNotEqualTo,
    bool? isLessThan,
    bool? isLessThanOrEqualTo,
    bool? isGreaterThan,
    bool? isGreaterThanOrEqualTo,
    bool? isNull,
    List<bool>? whereIn,
    List<bool>? whereNotIn,
  }) {
    return _$EventQuery(
      reference.where(
        'publish',
        isEqualTo: isEqualTo,
        isNotEqualTo: isNotEqualTo,
        isLessThan: isLessThan,
        isLessThanOrEqualTo: isLessThanOrEqualTo,
        isGreaterThan: isGreaterThan,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo,
        isNull: isNull,
        whereIn: whereIn,
        whereNotIn: whereNotIn,
      ),
      _collection,
    );
  }

  EventQuery whereOrganizers({
    List<String>? isEqualTo,
    List<String>? isNotEqualTo,
    List<String>? isLessThan,
    List<String>? isLessThanOrEqualTo,
    List<String>? isGreaterThan,
    List<String>? isGreaterThanOrEqualTo,
    bool? isNull,
    List<String>? arrayContainsAny,
  }) {
    return _$EventQuery(
      reference.where(
        'organizers',
        isEqualTo: isEqualTo,
        isNotEqualTo: isNotEqualTo,
        isLessThan: isLessThan,
        isLessThanOrEqualTo: isLessThanOrEqualTo,
        isGreaterThan: isGreaterThan,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo,
        isNull: isNull,
        arrayContainsAny: arrayContainsAny,
      ),
      _collection,
    );
  }

  EventQuery whereParticipants({
    List<String>? isEqualTo,
    List<String>? isNotEqualTo,
    List<String>? isLessThan,
    List<String>? isLessThanOrEqualTo,
    List<String>? isGreaterThan,
    List<String>? isGreaterThanOrEqualTo,
    bool? isNull,
    List<String>? arrayContainsAny,
  }) {
    return _$EventQuery(
      reference.where(
        'participants',
        isEqualTo: isEqualTo,
        isNotEqualTo: isNotEqualTo,
        isLessThan: isLessThan,
        isLessThanOrEqualTo: isLessThanOrEqualTo,
        isGreaterThan: isGreaterThan,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo,
        isNull: isNull,
        arrayContainsAny: arrayContainsAny,
      ),
      _collection,
    );
  }

  EventQuery whereBeforePictures({
    List<String>? isEqualTo,
    List<String>? isNotEqualTo,
    List<String>? isLessThan,
    List<String>? isLessThanOrEqualTo,
    List<String>? isGreaterThan,
    List<String>? isGreaterThanOrEqualTo,
    bool? isNull,
    List<String>? arrayContainsAny,
  }) {
    return _$EventQuery(
      reference.where(
        'beforePictures',
        isEqualTo: isEqualTo,
        isNotEqualTo: isNotEqualTo,
        isLessThan: isLessThan,
        isLessThanOrEqualTo: isLessThanOrEqualTo,
        isGreaterThan: isGreaterThan,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo,
        isNull: isNull,
        arrayContainsAny: arrayContainsAny,
      ),
      _collection,
    );
  }

  EventQuery whereAfterPictures({
    List<String>? isEqualTo,
    List<String>? isNotEqualTo,
    List<String>? isLessThan,
    List<String>? isLessThanOrEqualTo,
    List<String>? isGreaterThan,
    List<String>? isGreaterThanOrEqualTo,
    bool? isNull,
    List<String>? arrayContainsAny,
  }) {
    return _$EventQuery(
      reference.where(
        'afterPictures',
        isEqualTo: isEqualTo,
        isNotEqualTo: isNotEqualTo,
        isLessThan: isLessThan,
        isLessThanOrEqualTo: isLessThanOrEqualTo,
        isGreaterThan: isGreaterThan,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo,
        isNull: isNull,
        arrayContainsAny: arrayContainsAny,
      ),
      _collection,
    );
  }

  EventQuery whereGarbageCollected({
    num? isEqualTo,
    num? isNotEqualTo,
    num? isLessThan,
    num? isLessThanOrEqualTo,
    num? isGreaterThan,
    num? isGreaterThanOrEqualTo,
    bool? isNull,
    List<num>? whereIn,
    List<num>? whereNotIn,
  }) {
    return _$EventQuery(
      reference.where(
        'garbageCollected',
        isEqualTo: isEqualTo,
        isNotEqualTo: isNotEqualTo,
        isLessThan: isLessThan,
        isLessThanOrEqualTo: isLessThanOrEqualTo,
        isGreaterThan: isGreaterThan,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo,
        isNull: isNull,
        whereIn: whereIn,
        whereNotIn: whereNotIn,
      ),
      _collection,
    );
  }

  EventQuery orderByName({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    EventDocumentSnapshot? startAtDocument,
    EventDocumentSnapshot? endAtDocument,
    EventDocumentSnapshot? endBeforeDocument,
    EventDocumentSnapshot? startAfterDocument,
  }) {
    var query = reference.orderBy('name', descending: descending);

    if (startAtDocument != null) {
      query = query.startAtDocument(startAtDocument.snapshot);
    }
    if (startAfterDocument != null) {
      query = query.startAfterDocument(startAfterDocument.snapshot);
    }
    if (endAtDocument != null) {
      query = query.endAtDocument(endAtDocument.snapshot);
    }
    if (endBeforeDocument != null) {
      query = query.endBeforeDocument(endBeforeDocument.snapshot);
    }

    if (startAt != _sentinel) {
      query = query.startAt([startAt]);
    }
    if (startAfter != _sentinel) {
      query = query.startAfter([startAfter]);
    }
    if (endAt != _sentinel) {
      query = query.endAt([endAt]);
    }
    if (endBefore != _sentinel) {
      query = query.endBefore([endBefore]);
    }

    return _$EventQuery(query, _collection);
  }

  EventQuery orderByDescription({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    EventDocumentSnapshot? startAtDocument,
    EventDocumentSnapshot? endAtDocument,
    EventDocumentSnapshot? endBeforeDocument,
    EventDocumentSnapshot? startAfterDocument,
  }) {
    var query = reference.orderBy('description', descending: descending);

    if (startAtDocument != null) {
      query = query.startAtDocument(startAtDocument.snapshot);
    }
    if (startAfterDocument != null) {
      query = query.startAfterDocument(startAfterDocument.snapshot);
    }
    if (endAtDocument != null) {
      query = query.endAtDocument(endAtDocument.snapshot);
    }
    if (endBeforeDocument != null) {
      query = query.endBeforeDocument(endBeforeDocument.snapshot);
    }

    if (startAt != _sentinel) {
      query = query.startAt([startAt]);
    }
    if (startAfter != _sentinel) {
      query = query.startAfter([startAfter]);
    }
    if (endAt != _sentinel) {
      query = query.endAt([endAt]);
    }
    if (endBefore != _sentinel) {
      query = query.endBefore([endBefore]);
    }

    return _$EventQuery(query, _collection);
  }

  EventQuery orderByComplete({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    EventDocumentSnapshot? startAtDocument,
    EventDocumentSnapshot? endAtDocument,
    EventDocumentSnapshot? endBeforeDocument,
    EventDocumentSnapshot? startAfterDocument,
  }) {
    var query = reference.orderBy('complete', descending: descending);

    if (startAtDocument != null) {
      query = query.startAtDocument(startAtDocument.snapshot);
    }
    if (startAfterDocument != null) {
      query = query.startAfterDocument(startAfterDocument.snapshot);
    }
    if (endAtDocument != null) {
      query = query.endAtDocument(endAtDocument.snapshot);
    }
    if (endBeforeDocument != null) {
      query = query.endBeforeDocument(endBeforeDocument.snapshot);
    }

    if (startAt != _sentinel) {
      query = query.startAt([startAt]);
    }
    if (startAfter != _sentinel) {
      query = query.startAfter([startAfter]);
    }
    if (endAt != _sentinel) {
      query = query.endAt([endAt]);
    }
    if (endBefore != _sentinel) {
      query = query.endBefore([endBefore]);
    }

    return _$EventQuery(query, _collection);
  }

  EventQuery orderByPublish({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    EventDocumentSnapshot? startAtDocument,
    EventDocumentSnapshot? endAtDocument,
    EventDocumentSnapshot? endBeforeDocument,
    EventDocumentSnapshot? startAfterDocument,
  }) {
    var query = reference.orderBy('publish', descending: descending);

    if (startAtDocument != null) {
      query = query.startAtDocument(startAtDocument.snapshot);
    }
    if (startAfterDocument != null) {
      query = query.startAfterDocument(startAfterDocument.snapshot);
    }
    if (endAtDocument != null) {
      query = query.endAtDocument(endAtDocument.snapshot);
    }
    if (endBeforeDocument != null) {
      query = query.endBeforeDocument(endBeforeDocument.snapshot);
    }

    if (startAt != _sentinel) {
      query = query.startAt([startAt]);
    }
    if (startAfter != _sentinel) {
      query = query.startAfter([startAfter]);
    }
    if (endAt != _sentinel) {
      query = query.endAt([endAt]);
    }
    if (endBefore != _sentinel) {
      query = query.endBefore([endBefore]);
    }

    return _$EventQuery(query, _collection);
  }

  EventQuery orderByOrganizers({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    EventDocumentSnapshot? startAtDocument,
    EventDocumentSnapshot? endAtDocument,
    EventDocumentSnapshot? endBeforeDocument,
    EventDocumentSnapshot? startAfterDocument,
  }) {
    var query = reference.orderBy('organizers', descending: descending);

    if (startAtDocument != null) {
      query = query.startAtDocument(startAtDocument.snapshot);
    }
    if (startAfterDocument != null) {
      query = query.startAfterDocument(startAfterDocument.snapshot);
    }
    if (endAtDocument != null) {
      query = query.endAtDocument(endAtDocument.snapshot);
    }
    if (endBeforeDocument != null) {
      query = query.endBeforeDocument(endBeforeDocument.snapshot);
    }

    if (startAt != _sentinel) {
      query = query.startAt([startAt]);
    }
    if (startAfter != _sentinel) {
      query = query.startAfter([startAfter]);
    }
    if (endAt != _sentinel) {
      query = query.endAt([endAt]);
    }
    if (endBefore != _sentinel) {
      query = query.endBefore([endBefore]);
    }

    return _$EventQuery(query, _collection);
  }

  EventQuery orderByParticipants({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    EventDocumentSnapshot? startAtDocument,
    EventDocumentSnapshot? endAtDocument,
    EventDocumentSnapshot? endBeforeDocument,
    EventDocumentSnapshot? startAfterDocument,
  }) {
    var query = reference.orderBy('participants', descending: descending);

    if (startAtDocument != null) {
      query = query.startAtDocument(startAtDocument.snapshot);
    }
    if (startAfterDocument != null) {
      query = query.startAfterDocument(startAfterDocument.snapshot);
    }
    if (endAtDocument != null) {
      query = query.endAtDocument(endAtDocument.snapshot);
    }
    if (endBeforeDocument != null) {
      query = query.endBeforeDocument(endBeforeDocument.snapshot);
    }

    if (startAt != _sentinel) {
      query = query.startAt([startAt]);
    }
    if (startAfter != _sentinel) {
      query = query.startAfter([startAfter]);
    }
    if (endAt != _sentinel) {
      query = query.endAt([endAt]);
    }
    if (endBefore != _sentinel) {
      query = query.endBefore([endBefore]);
    }

    return _$EventQuery(query, _collection);
  }

  EventQuery orderByBeforePictures({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    EventDocumentSnapshot? startAtDocument,
    EventDocumentSnapshot? endAtDocument,
    EventDocumentSnapshot? endBeforeDocument,
    EventDocumentSnapshot? startAfterDocument,
  }) {
    var query = reference.orderBy('beforePictures', descending: descending);

    if (startAtDocument != null) {
      query = query.startAtDocument(startAtDocument.snapshot);
    }
    if (startAfterDocument != null) {
      query = query.startAfterDocument(startAfterDocument.snapshot);
    }
    if (endAtDocument != null) {
      query = query.endAtDocument(endAtDocument.snapshot);
    }
    if (endBeforeDocument != null) {
      query = query.endBeforeDocument(endBeforeDocument.snapshot);
    }

    if (startAt != _sentinel) {
      query = query.startAt([startAt]);
    }
    if (startAfter != _sentinel) {
      query = query.startAfter([startAfter]);
    }
    if (endAt != _sentinel) {
      query = query.endAt([endAt]);
    }
    if (endBefore != _sentinel) {
      query = query.endBefore([endBefore]);
    }

    return _$EventQuery(query, _collection);
  }

  EventQuery orderByAfterPictures({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    EventDocumentSnapshot? startAtDocument,
    EventDocumentSnapshot? endAtDocument,
    EventDocumentSnapshot? endBeforeDocument,
    EventDocumentSnapshot? startAfterDocument,
  }) {
    var query = reference.orderBy('afterPictures', descending: descending);

    if (startAtDocument != null) {
      query = query.startAtDocument(startAtDocument.snapshot);
    }
    if (startAfterDocument != null) {
      query = query.startAfterDocument(startAfterDocument.snapshot);
    }
    if (endAtDocument != null) {
      query = query.endAtDocument(endAtDocument.snapshot);
    }
    if (endBeforeDocument != null) {
      query = query.endBeforeDocument(endBeforeDocument.snapshot);
    }

    if (startAt != _sentinel) {
      query = query.startAt([startAt]);
    }
    if (startAfter != _sentinel) {
      query = query.startAfter([startAfter]);
    }
    if (endAt != _sentinel) {
      query = query.endAt([endAt]);
    }
    if (endBefore != _sentinel) {
      query = query.endBefore([endBefore]);
    }

    return _$EventQuery(query, _collection);
  }

  EventQuery orderByGarbageCollected({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    EventDocumentSnapshot? startAtDocument,
    EventDocumentSnapshot? endAtDocument,
    EventDocumentSnapshot? endBeforeDocument,
    EventDocumentSnapshot? startAfterDocument,
  }) {
    var query = reference.orderBy('garbageCollected', descending: descending);

    if (startAtDocument != null) {
      query = query.startAtDocument(startAtDocument.snapshot);
    }
    if (startAfterDocument != null) {
      query = query.startAfterDocument(startAfterDocument.snapshot);
    }
    if (endAtDocument != null) {
      query = query.endAtDocument(endAtDocument.snapshot);
    }
    if (endBeforeDocument != null) {
      query = query.endBeforeDocument(endBeforeDocument.snapshot);
    }

    if (startAt != _sentinel) {
      query = query.startAt([startAt]);
    }
    if (startAfter != _sentinel) {
      query = query.startAfter([startAfter]);
    }
    if (endAt != _sentinel) {
      query = query.endAt([endAt]);
    }
    if (endBefore != _sentinel) {
      query = query.endBefore([endBefore]);
    }

    return _$EventQuery(query, _collection);
  }

  @override
  bool operator ==(Object other) {
    return other is _$EventQuery &&
        other.runtimeType == runtimeType &&
        other.reference == reference;
  }

  @override
  int get hashCode => Object.hash(runtimeType, reference);
}

class EventQuerySnapshot
    extends FirestoreQuerySnapshot<EventQueryDocumentSnapshot> {
  EventQuerySnapshot._(
      this.snapshot,
      this.docs,
      this.docChanges,
      );

  final QuerySnapshot<Event> snapshot;

  @override
  final List<EventQueryDocumentSnapshot> docs;

  @override
  final List<FirestoreDocumentChange<EventDocumentSnapshot>> docChanges;
}

class EventQueryDocumentSnapshot extends FirestoreQueryDocumentSnapshot
    implements EventDocumentSnapshot {
  EventQueryDocumentSnapshot._(this.snapshot, this.data);

  @override
  final QueryDocumentSnapshot<Event> snapshot;

  @override
  EventDocumentReference get reference {
    return EventDocumentReference(snapshot.reference);
  }

  @override
  final Event data;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocationType _$LocationTypeFromJson(Map<String, dynamic> json) => LocationType(
  json['name'] as String,
);

Map<String, dynamic> _$LocationTypeToJson(LocationType instance) =>
    <String, dynamic>{
      'name': instance.name,
    };

Location _$LocationFromJson(Map<String, dynamic> json){


  // String a = "";
  // json["type"].get().then((DocumentSnapshot documentSnapshot) {
  //   if (documentSnapshot.exists) {
  //     a = documentSnapshot["name"];
  //   }});


  return Location(
      Geo.fromGP(json['geo']),
      LocationTypeDocumentReference(json["type"] ) // PROBLEM IS HERE
  );
}

Map<String, dynamic> _$LocationToJson(Location instance) => <String, dynamic>{
  'geo': instance.geo,
  'type': instance.type,
};

Role _$RoleFromJson(Map<String, dynamic> json) => Role(
  json['name'] as String,
  json['members'],
);

Map<String, dynamic> _$RoleToJson(Role instance) => <String, dynamic>{
  'name': instance.name,
  'members': instance.members,
};

Event _$EventFromJson(Map<String, dynamic> json) => Event(
  json['name'] as String,
  json['description'] as String,
  // DateTime.parse(json['creationDate'] as String), // problem was here
  // DateTime.parse(json['orgDate'] as String),
json['creationDate'].toDate() ,
json['orgDate'].toDate(),
  (json['organizers'] as List<dynamic>).map((e) => e as String).toList(),
  (json['participants'] as List<dynamic>).map((e) => e as String).toList(),
  (json['beforePictures'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  (json['afterPictures'] as List<dynamic>).map((e) => e as String).toList(),
  json['garbageCollected'] as num,
  json['location'], // PROBLEM IS HERE
);

Map<String, dynamic> _$EventToJson(Event instance) => <String, dynamic>{
  'name': instance.name,
  'description': instance.description,
  'creationDate': instance.creationDate.toIso8601String(),
  'orgDate': instance.orgDate.toIso8601String(),
  'organizers': instance.organizers,
  'participants': instance.participants,
  'beforePictures': instance.beforePictures,
  'afterPictures': instance.afterPictures,
  'garbageCollected': instance.garbageCollected,
  'location': instance.location,
};
