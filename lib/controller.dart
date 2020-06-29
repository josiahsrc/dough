part of dough;

/// Controls a dough widget.
class DoughController with ChangeNotifier {
  final _statusListeners = ObserverList<DoughStatusCallback>();

  bool _isActive = false;
  Offset _origin = Offset.zero;
  Offset _target = Offset.zero;

  /// Is this controller maintaining a squish.
  bool get isActive => _isActive;

  /// The starting point of the squish.
  Offset get origin => _origin;

  /// The ending point of the squish.
  Offset get target => _target;

  /// The difference between the target and the origin. The Dough
  /// widget uses this to determine which direction to smoosh its
  /// child.
  Offset get delta => this.target - this.origin;

  /// Adds a status listener.
  void addStatusListener(DoughStatusCallback callback) {
    _statusListeners.add(callback);
  }

  /// Removes a status listener.
  void removeStatusListener(DoughStatusCallback callback) {
    _statusListeners.remove(callback);
  }

  /// Begin squishing the dough. Sets [isActive] to true. Informs all status
  /// listeners that the status has changed to [DoughStatus.started].
  ///
  /// - If no [origin] is provided, the old [origin] will be used instead.
  /// - If no [target] is provided, the old [target] will be used instead.
  ///
  /// **A squish can't already be active when calling this message.**
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

  /// Update the currently active squish.
  ///
  /// - If no [origin] is provided, the old [origin] will be used instead.
  /// - If no [target] is provided, the old [target] will be used instead.
  ///
  /// **A squish must already be active when calling this function.**
  void update({
    Offset origin,
    Offset target,
  }) {
    assert(isActive);

    _origin = origin ?? _origin;
    _target = target ?? _target;

    notifyListeners();
  }

  /// Stops squishing the dough. Sets [isActive] to false. Informs all status
  /// listeners that the status has changed to [DoughStatus.stopped].
  ///
  /// **A squish must already be active when calling this function.**
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
