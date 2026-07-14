/// Minimal failure type bundled with the package so consuming projects
/// do not need to define their own for token operations.
class KitFailure {
  const KitFailure({required this.message});

  final String message;

  @override
  String toString() => 'KitFailure($message)';
}
