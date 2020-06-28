part of dough;

enum DoughControllerStatus {
  began,
  ended,
}

typedef DoughControllerStatusCallback = void Function(
  DoughControllerStatus status,
);

class DoughController with ChangeNotifier {
  final _listeners = ObserverList<DoughControllerStatusCallback>();

  bool _isActive = false;
  vmath.Vector2 _start = vmath.Vector2.zero();
  vmath.Vector2 _end = vmath.Vector2.zero();

  bool get isActive => _isActive;
  vmath.Vector2 get start => _start;
  vmath.Vector2 get end => _end;

  vmath.Vector2 get delta => this.end - this.start;

  
}
