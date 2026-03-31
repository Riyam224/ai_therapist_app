import 'package:flutter/material.dart';

class MoodEntry {
  final int id;
  final String emoji; // Can be emoji text or image path
  final String title;
  final String preview;
  final Color sideColor;
  final DateTime date;
  final bool isEmojiImage; // Flag to indicate if emoji is an image path

  const MoodEntry({
    required this.id,
    required this.emoji,
    required this.title,
    required this.preview,
    required this.sideColor,
    required this.date,
    this.isEmojiImage = false,
  });
}
