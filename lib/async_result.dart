import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';

sealed class AsyncData<T> {
  const AsyncData();

  bool get isPending => this is Pending;

  bool get hasData => this is Data;

  T? get data => null;
}

@immutable
class Data<T> extends AsyncData<T> {
  @override
  final T data;

  const Data(this.data);

  @override
  String toString() {
    return 'Data{data: $data}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Data &&
          runtimeType == other.runtimeType &&
          (data is List
              ? const ListEquality().equals(data as List, other.data)
              : data == other.data);

  @override
  int get hashCode => data.hashCode;
}

class DataError<T> extends AsyncData<T> {
  final String message;

  const DataError([this.message = 'Error :(...']);
}

class Pending<T> extends AsyncData<T> {
  final double? progress;

  const Pending([this.progress]);
}
