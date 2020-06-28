part of dough;

typedef DoughStatusCallback = void Function(DoughStatus status);

enum DoughStatus {
  started,
  stopped,
}
