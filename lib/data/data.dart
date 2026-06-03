import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'entry.dart';

class MoodFaceData {
  final String label;

  final Color bgColor;

  // Eyes
  final double eyeRadius;
  final double eyeSpacing;
  final double eyeOpen;
  final double eyeHeart;
  final double eyeRotate;

  final double mouthHeight;
  final double mouthSmile;
  final double mouthClose;
  final double mouthRotation;

  final double extraSize; // tears, stress mark, etc.
  final double tear;
  final double stress;

  const MoodFaceData({
    required this.label,
    required this.bgColor,
    required this.mouthSmile,
    this.eyeRadius = 40,
    this.eyeSpacing = 15,
    this.eyeOpen = 1,
    this.eyeHeart = 0,
    this.eyeRotate = 0,
    this.mouthHeight = 40,
    this.mouthClose = 1,
    this.mouthRotation = 0,
    this.extraSize = 40,
    this.tear = 0,
    this.stress = 0,
  });

  static MoodFaceData lerp(MoodFaceData a, MoodFaceData b, double t) {
    double lerpDouble(double x, double y) => x + (y - x) * t;

    return MoodFaceData(
      label: t < 0.5 ? a.label : b.label,
      bgColor: Color.lerp(a.bgColor, b.bgColor, t)!,

      eyeRadius: lerpDouble(a.eyeRadius, b.eyeRadius),
      eyeSpacing: lerpDouble(a.eyeSpacing, b.eyeSpacing),
      eyeOpen: lerpDouble(a.eyeOpen, b.eyeOpen),
      eyeHeart: lerpDouble(a.eyeHeart, b.eyeHeart),
      eyeRotate: lerpDouble(a.eyeRotate, b.eyeRotate),

      mouthHeight: lerpDouble(a.mouthHeight, b.mouthHeight),
      mouthSmile: lerpDouble(a.mouthSmile, b.mouthSmile),
      mouthClose: lerpDouble(a.mouthClose, b.mouthClose),
      mouthRotation: lerpDouble(a.mouthRotation, b.mouthRotation),

      extraSize: lerpDouble(a.extraSize, b.extraSize),
      tear: lerpDouble(a.tear, b.tear),
      stress: lerpDouble(a.stress, b.stress),
    );
  }
}

const List<MoodFaceData> moodLibrary = [
  MoodFaceData(
    label: "Sad",
    bgColor: Color(0xFFBFD6F2),
    mouthSmile: -1,
    mouthRotation: -0.4,
  ),
  MoodFaceData(
    label: "Calm",
    bgColor: Color(0xFFCDEEE3),
    eyeOpen: -1,
    mouthSmile: 0.7,
  ),
  MoodFaceData(
    label: "Anxious",
    bgColor: Color(0xFFD6CCE8),
    mouthSmile: -1,
    mouthClose: 0,
    tear: 1,
  ),
  MoodFaceData(
    label: "Stressed",
    bgColor: Color(0xFFF2C6B8),
    mouthSmile: -0.7,
    stress: 1,
  ),
  MoodFaceData(
    label: "Happy",
    bgColor: Color(0xFFFFF1B8),
    mouthSmile: 1,
    mouthClose: 0,
    eyeRotate: 1,
  ),
  MoodFaceData(
    label: "Loved",
    bgColor: Color(0xFFF6C1D1),
    eyeHeart: 1,
    mouthSmile: 1,
    mouthClose: 0,
    eyeRotate: 1,
  ),
];

class MoodService {
  static const String _boxName = 'moods';
  late Box<MoodEntry> _box;

  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(MoodEntryAdapter());
    _box = await Hive.openBox<MoodEntry>(_boxName);
  }

  // Add or update mood for a specific day
  Future<void> saveMood(MoodEntry entry) async {
    // Use date as key (normalized to midnight)
    final key = _dateKey(entry.date);
    await _box.put(key, entry);
  }

  // Get mood for specific day
  MoodEntry? getMoodForDate(DateTime date) {
    return _box.get(_dateKey(date));
  }

  // Get all moods (sorted by date)
  List<MoodEntry> getAllMoods() {
    return _box.values.toList()
      ..sort((a, b) => b.date.compareTo(a.date));  // Newest first
  }

  // Get moods for date range (e.g., last 7 days)
  List<MoodEntry> getMoodsForRange(DateTime start, DateTime end) {
    return _box.values.where((mood) {
      return mood.date.isAfter(start) && mood.date.isBefore(end);
    }).toList();
  }

  // Delete mood
  Future<void> deleteMood(DateTime date) async {
    await _box.delete(_dateKey(date));
  }

  // Helper: Normalize date to midnight for consistent keys
  String _dateKey(DateTime date) {
    final normalized = DateTime(date.year, date.month, date.day);
    return normalized.toIso8601String();
  }
}