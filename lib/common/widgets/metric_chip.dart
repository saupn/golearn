import 'package:flutter/material.dart';
import '../../common/models/level.dart';
import '../../common/models/module.dart';
import '../../common/models/lesson.dart';

class MetricChip extends StatelessWidget {
  final String label;
  final MetricStatus status;
  final Color? backgroundColor;
  final Color? textColor;

  const MetricChip({
    super.key,
    required this.label,
    required this.status,
    this.backgroundColor,
    this.textColor,
  });

  factory MetricChip.fromLevelStatus(LevelStatus status) {
    return MetricChip(
      label: _getLevelStatusLabel(status),
      status: _getLevelMetricStatus(status),
    );
  }

  factory MetricChip.fromModuleStatus(ModuleStatus status) {
    return MetricChip(
      label: _getModuleStatusLabel(status),
      status: _getModuleMetricStatus(status),
    );
  }

  factory MetricChip.fromLessonStatus(LessonStatus status) {
    return MetricChip(
      label: _getLessonStatusLabel(status),
      status: _getLessonMetricStatus(status),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = _getStatusColors(context, status);

    return Chip(
      label: Text(
        label,
        style: TextStyle(
          color: textColor ?? colors.textColor,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
      backgroundColor: backgroundColor ?? colors.backgroundColor,
      side: BorderSide.none,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    );
  }

  static String _getLevelStatusLabel(LevelStatus status) {
    switch (status) {
      case LevelStatus.locked:
        return 'Locked';
      case LevelStatus.inProgress:
        return 'In Progress';
      case LevelStatus.passed:
        return 'Passed';
    }
  }

  static String _getModuleStatusLabel(ModuleStatus status) {
    switch (status) {
      case ModuleStatus.locked:
        return 'Locked';
      case ModuleStatus.inProgress:
        return 'In Progress';
      case ModuleStatus.completed:
        return 'Completed';
    }
  }

  static String _getLessonStatusLabel(LessonStatus status) {
    switch (status) {
      case LessonStatus.locked:
        return 'Locked';
      case LessonStatus.inProgress:
        return 'In Progress';
      case LessonStatus.completed:
        return 'Completed';
    }
  }

  static MetricStatus _getLevelMetricStatus(LevelStatus status) {
    switch (status) {
      case LevelStatus.locked:
        return MetricStatus.locked;
      case LevelStatus.inProgress:
        return MetricStatus.inProgress;
      case LevelStatus.passed:
        return MetricStatus.passed;
    }
  }

  static MetricStatus _getModuleMetricStatus(ModuleStatus status) {
    switch (status) {
      case ModuleStatus.locked:
        return MetricStatus.locked;
      case ModuleStatus.inProgress:
        return MetricStatus.inProgress;
      case ModuleStatus.completed:
        return MetricStatus.passed;
    }
  }

  static MetricStatus _getLessonMetricStatus(LessonStatus status) {
    switch (status) {
      case LessonStatus.locked:
        return MetricStatus.locked;
      case LessonStatus.inProgress:
        return MetricStatus.inProgress;
      case LessonStatus.completed:
        return MetricStatus.passed;
    }
  }

  _StatusColors _getStatusColors(BuildContext context, MetricStatus status) {
    final theme = Theme.of(context);

    switch (status) {
      case MetricStatus.locked:
        return _StatusColors(
          backgroundColor: theme.colorScheme.surfaceVariant,
          textColor: theme.colorScheme.onSurfaceVariant,
        );
      case MetricStatus.inProgress:
        return _StatusColors(
          backgroundColor: theme.colorScheme.primaryContainer,
          textColor: theme.colorScheme.onPrimaryContainer,
        );
      case MetricStatus.passed:
        return _StatusColors(
          backgroundColor: theme.colorScheme.secondaryContainer,
          textColor: theme.colorScheme.onSecondaryContainer,
        );
    }
  }
}

enum MetricStatus { locked, inProgress, passed }

class _StatusColors {
  final Color backgroundColor;
  final Color textColor;

  _StatusColors({required this.backgroundColor, required this.textColor});
}
