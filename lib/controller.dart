part of dough;

enum DoughControllerStatus {
  started,
  finished,
}

typedef DoughControllerStatusCallback = void Function(
  DoughControllerStatus status,
);

class DoughController with ChangeNotifier {
  final _statusListeners = ObserverList<DoughControllerStatusCallback>();

  bool _isActive = false;
  Offset _origin = Offset.zero;
  Offset _target = Offset.zero;

  bool get isActive => _isActive;
  Offset get origin => _origin;
  Offset get target => _target;
  Offset get delta => this.delta - this.origin;

  void addStatusListener(DoughControllerStatusCallback callback) {
    _statusListeners.add(callback);
  }

  void removeStatusListener(DoughControllerStatusCallback callback) {
    _statusListeners.remove(callback);
  }

  void start(Offset origin) {
    assert(!isActive);

    _isActive = true;
    _origin = origin;
    _target = origin;

    notifyListeners();
    _notifyStatusListeners(DoughControllerStatus.started);
  }

  void update(Offset target) {
    assert(isActive);

    _target = target;
    notifyListeners();
  }

  void finish() {
    assert(isActive);

    _isActive = false;
    notifyListeners();
    _notifyStatusListeners(DoughControllerStatus.finished);
  }

  void _notifyStatusListeners(DoughControllerStatus status) {
    _statusListeners.forEach((fn) => fn(status));
  }
}
