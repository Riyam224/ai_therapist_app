import 'package:flutter/material.dart';
import 'app_extra_colors.dart';

extension ExtraColorsExtension on BuildContext {
  AppExtraColors get extra => Theme.of(this).extension<AppExtraColors>()!;
}
