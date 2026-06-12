import 'package:flutter/material.dart';
import '../../data/data.dart';
import '../../data/entry.dart';
import '../../theme/app_constants.dart';

class DateStrip extends StatelessWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;
  final MoodEntry? Function(DateTime) entryForDate;
  final ScrollController scrollController;

  const DateStrip({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
    required this.entryForDate,
    required this.scrollController,
  });

  String _dayAbbr(DateTime date) {
    const weekdays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
    return weekdays[date.weekday - 1];
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final start = DateTime(today.year, today.month, today.day - 13);

    return SizedBox(
      height: Sizes.dateStripHeight,
      child: ListView.separated(
        controller: scrollController,
        scrollDirection: Axis.horizontal,
        itemCount: 14,
        separatorBuilder: (_, _) => const SizedBox(width: Insets.md),
        itemBuilder: (context, i) {
          final date = DateTime(start.year, start.month, start.day + i);
          final isSelected = date.day == selectedDate.day &&
              date.month == selectedDate.month &&
              date.year == selectedDate.year;

          final entry = entryForDate(date);
          Color? dotColor;
          if (entry != null &&
              entry.mood >= 0 &&
              entry.mood < moodLibrary.length) {
            dotColor = moodLibrary[entry.mood].bgColor;
          }

          return GestureDetector(
            onTap: () => onDateSelected(date),
            child: Container(
              width: Sizes.datePill,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.darkButton : Colors.transparent,
                borderRadius: BorderRadius.circular(Radii.md),
                border: !isSelected
                    ? Border.all(color: Colors.grey.shade300, width: 1)
                    : null,
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _dayAbbr(date),
                          style: TextStyle(
                            fontSize: FontSizes.xs,
                            color: isSelected
                                ? Colors.white70
                                : Colors.grey.shade500,
                          ),
                        ),
                        const SizedBox(height: Insets.xs),
                        Text(
                          "${date.day}",
                          style: TextStyle(
                            fontSize: FontSizes.lg,
                            fontWeight: FontWeights.bold,
                            color: isSelected ? Colors.white : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (dotColor != null)
                    Positioned(
                      top: Insets.xs,
                      right: Insets.xs,
                      child: Container(
                        width: Sizes.dotIndicator,
                        height: Sizes.dotIndicator,
                        decoration: BoxDecoration(
                          color: dotColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
