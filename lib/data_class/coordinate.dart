class Coordinates {
  double latitude;
  double longitude;

  Coordinates({
    required this.latitude,
    required this.longitude,
  });

  // Override toString for better debugging output
  @override
  String toString() {
    return 'Coordinates(latitude: $latitude, longitude: $longitude)';
  }

  // Optionally, you can still override == and hashCode for value comparison
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (runtimeType != other.runtimeType) return false;
    final Coordinates otherCoordinates = other as Coordinates;
    return latitude == otherCoordinates.latitude && longitude == otherCoordinates.longitude;
  }

  @override
  int get hashCode => latitude.hashCode ^ longitude.hashCode;
}
