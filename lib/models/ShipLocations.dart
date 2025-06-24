import 'package:collection/collection.dart';

class ShipLocations {
  final Map<int, String> _indexToLocations;
  final Map<String, int> _locationToIndex;

  ShipLocations()
      : _indexToLocations = {
          for (int i = 0; i < locationKeys.length; i++) i: locationKeys[i],
        },
        _locationToIndex = {
          for (int i = 0; i < locationKeys.length; i++) locationKeys[i]: i,
        };

  static const List<String> locationKeys = [
    "A1",
    "A2",
    "A3",
    "A4",
    "A5",
    "B1",
    "B2",
    "B3",
    "B4",
    "B5",
    "C1",
    "C2",
    "C3",
    "C4",
    "C5",
    "D1",
    "D2",
    "D3",
    "D4",
    "D5",
    "E1",
    "E2",
    "E3",
    "E4",
    "E5",
  ];

  Map<int, String> get indexToLocations => _indexToLocations;

  Map<String, int> get locationToIndex => _locationToIndex;
}
