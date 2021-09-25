import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Provider utilities.
class ProviderUtils {
  const ProviderUtils._();

  /// Retrieve [TData] from the [context]. Refer to the [fallback] when no
  /// [TData] can be found.
  static TData of<TData>({
    required BuildContext context,
    required bool listen,
    required TData fallback,
  }) {
    try {
      return Provider.of<TData>(context, listen: listen);
    } on ProviderNotFoundException catch (_) {
      return fallback;
    }
  }
}
