part of dough;

/// A callback used to indicate a change in [DoughStatus].
typedef DoughStatusCallback = void Function(DoughStatus status);

/// Represents the state of a [Dough] widget's animation based on its
/// associated [DoughController].
enum DoughStatus {
  /// Indicates that the [DoughController] has entered an active state
  /// and [DoughController.isActive] has been set to true.
  started,

  /// Indicates that the [DoughController] has exited an active state
  /// and [DoughController.isActive] has been set to false.
  stopped,
}

/// Controls a [Dough] widget. Use this to control when a [Dough] widget should
/// squish around.
///
/// - Use [DoughController.start] to start a squish.
/// - Use [DoughController.update] to update a squish.
/// - Use [DoughController.stop] to finish a squish.
class DoughController with ChangeNotifier {
  /// Creates a [DoughController].
  DoughController() : super();

  final _statusListeners = ObserverList<DoughStatusCallback>();

  bool _isActive = false;
  Offset _origin = Offset.zero;
  Offset _target = Offset.zero;
  DoughStatus _status = DoughStatus.stopped;

  /// Whether a "squish" on the [Dough] widget is active.
  bool get isActive => _isActive;

  /// The starting point of the squish or where the [Dough] is stretching
  /// from.
  Offset get origin => _origin;

  /// The ending point of the squish or where the [Dough] is trying
  /// to stretch to.
  Offset get target => _target;

  /// The difference between the [target] and the [origin]. The [Dough]
  /// widget uses this to determine which direction to smoosh its [Dough.child].
  Offset get delta => target - origin;

  /// The last [DoughStatus] that was raised.
  DoughStatus get status => _status;

  /// Adds a status listener.
  void addStatusListener(DoughStatusCallback callback) {
    _statusListeners.add(callback);
  }

  /// Removes a status listener.
  void removeStatusListener(DoughStatusCallback callback) {
    _statusListeners.remove(callback);
  }

  /// Begin squishing the dough. Sets [isActive] to true. Informs all status
  /// listeners that the [status] has changed to [DoughStatus.started].
  ///
  /// - If no [origin] is provided, the old [origin] will be used instead.
  /// - If no [target] is provided, the old [target] will be used instead.
  ///
  /// **A squish can't already be active when calling this function.**
  void start({
    Offset origin,
    Offset target,
  }) {
    assert(!isActive);

    _isActive = true;
    _origin = origin ?? _origin;
    _target = target ?? _target;
    _status = DoughStatus.started;

    notifyListeners();
    _notifyStatusListeners(_status);
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

  /// Stops squishing the [Dough]. Sets [isActive] to false. Informs all status
  /// listeners that the [status] has changed to [DoughStatus.stopped]. The
  /// [Dough] will snap back to the origin and its original shape.
  ///
  /// **A squish must already be active when calling this function.**
  void stop() {
    assert(isActive);

    _isActive = false;
    _status = DoughStatus.stopped;

    notifyListeners();
    _notifyStatusListeners(_status);
  }

  void _notifyStatusListeners(DoughStatus status) {
    for (final listener in _statusListeners) {
      listener?.call(status);
    }
  }
}
