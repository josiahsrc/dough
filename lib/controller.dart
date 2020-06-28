part of dough;

class DoughController with ChangeNotifier {
  final _statusListeners = ObserverList<DoughStatusCallback>();

  bool _isActive = false;
  Offset _origin = Offset.zero;
  Offset _target = Offset.zero;

  bool get isActive => _isActive;
  Offset get origin => _origin;
  Offset get target => _target;
  Offset get delta => this.target - this.origin;

  void addStatusListener(DoughStatusCallback callback) {
    _statusListeners.add(callback);
  }

  void removeStatusListener(DoughStatusCallback callback) {
    _statusListeners.remove(callback);
  }

  void start({
    Offset origin,
    Offset target,
  }) {
    assert(!isActive);

    _isActive = true;
    _origin = origin ?? _origin;
    _target = target ?? _target;

    notifyListeners();
    _notifyStatusListeners(DoughStatus.started);
  }

  void update({
    Offset origin,
    Offset target,
  }) {
    assert(isActive);

    _origin = origin ?? _origin;
    _target = target ?? _target;

    notifyListeners();
  }

  void stop() {
    assert(isActive);

    _isActive = false;

    notifyListeners();
    _notifyStatusListeners(DoughStatus.stopped);
  }

  void _notifyStatusListeners(DoughStatus status) {
    _statusListeners.forEach((fn) => fn(status));
  }
}
