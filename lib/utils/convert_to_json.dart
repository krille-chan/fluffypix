extension ConvertToJson on Map {
  dynamic _castValue(dynamic value) {
    if (value is Map) {
      return value.toJson();
    }
    if (value is List) {
      return value.map(_castValue).toList();
    }
    return value;
  }

  /// Hive always gives back an `_InternalLinkedHasMap<dynamic, dynamic>`. This
  /// creates a deep copy of the json and makes sure that the format is always
  /// `Map<String, dynamic>`.
  Map<String, dynamic> toJson() {
    final copy = Map<String, dynamic>.from(this);
    for (final entry in copy.entries) {
      copy[entry.key] = _castValue(entry.value);
    }
    return copy;
  }
}
