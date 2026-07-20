import 'package:flutter/material.dart';

class CustomColors extends ThemeExtension<CustomColors> {
  final Color? success;
  final Color? successContainer;
  final Color? warning;
  final Color? warningContainer;
  final Color? info;
  final Color? infoContainer;
  final LinearGradient? headerGradient;
  final LinearGradient? progressGradient;
  final LinearGradient? ecoCardGradient;

  const CustomColors({
    this.success,
    this.successContainer,
    this.warning,
    this.warningContainer,
    this.info,
    this.infoContainer,
    this.headerGradient,
    this.progressGradient,
    this.ecoCardGradient,
  });

  @override
  ThemeExtension<CustomColors> copyWith({
    Color? success,
    Color? successContainer,
    Color? warning,
    Color? warningContainer,
    Color? info,
    Color? infoContainer,
    LinearGradient? headerGradient,
    LinearGradient? progressGradient,
    LinearGradient? ecoCardGradient,
  }) {
    return CustomColors(
      success: success ?? this.success,
      successContainer: successContainer ?? this.successContainer,
      warning: warning ?? this.warning,
      warningContainer: warningContainer ?? this.warningContainer,
      info: info ?? this.info,
      infoContainer: infoContainer ?? this.infoContainer,
      headerGradient: headerGradient ?? this.headerGradient,
      progressGradient: progressGradient ?? this.progressGradient,
      ecoCardGradient: ecoCardGradient ?? this.ecoCardGradient,
    );
  }

  @override
  ThemeExtension<CustomColors> lerp(
    covariant ThemeExtension<CustomColors>? other,
    double t,
  ) {
    if (other is! CustomColors) return this;
    return CustomColors(
      success: Color.lerp(success, other.success, t),
      successContainer: Color.lerp(successContainer, other.successContainer, t),
      warning: Color.lerp(warning, other.warning, t),
      warningContainer: Color.lerp(warningContainer, other.warningContainer, t),
      info: Color.lerp(info, other.info, t),
      infoContainer: Color.lerp(infoContainer, other.infoContainer, t),
      headerGradient: LinearGradient.lerp(headerGradient, other.headerGradient, t),
      progressGradient: LinearGradient.lerp(progressGradient, other.progressGradient, t),
      ecoCardGradient: LinearGradient.lerp(ecoCardGradient, other.ecoCardGradient, t),
    );
  }
}

extension ThemeContext on BuildContext {
  ThemeData get theme => Theme.of(this);

  ColorScheme get colorScheme => theme.colorScheme;

  TextTheme get textTheme => theme.textTheme;

  CustomColors get extraColors => theme.extension<CustomColors>()!;
}
