import 'package:eschool_saas_staff/ui/widgets/customTextContainer.dart';
import 'package:eschool_saas_staff/utils/constants.dart';
import 'package:eschool_saas_staff/utils/utils.dart';
import 'package:flutter/material.dart';

class WeekdaysContainer extends StatefulWidget {
  final String selectedDayKey;
  final Function(String newSelection) onSelectionChange;
  const WeekdaysContainer({
    super.key,
    required this.selectedDayKey,
    required this.onSelectionChange,
  });

  @override
  State<WeekdaysContainer> createState() => _WeekdaysContainerState();
}

class _WeekdaysContainerState extends State<WeekdaysContainer> {
  late final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToSelectedDay());
  }

  @override
  void didUpdateWidget(covariant WeekdaysContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedDayKey != widget.selectedDayKey) {
      _scrollToSelectedDay();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToSelectedDay() {
    if (!_scrollController.hasClients) return;

    final index = Utils.weekDays.indexOf(widget.selectedDayKey);
    if (index == -1) return;

    // Item width is CircleAvatar diameter (60) + padding (12.5)
    const double itemWidth = 60.0 + 12.5;
    // Initial padding is appContentHorizontalPadding (15)
    final double initialPadding = appContentHorizontalPadding;
    
    // Calculate the target offset to center the selected item
    final screenWidth = MediaQuery.of(context).size.width;
    final targetOffset = (initialPadding + (index * itemWidth) + (60.0 / 2)) - (screenWidth / 2);

    // Clamp the offset between 0 and maxScrollExtent
    final maxScroll = _scrollController.position.maxScrollExtent;
    final clampedOffset = targetOffset.clamp(0.0, maxScroll);

    _scrollController.animateTo(
      clampedOffset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 80.0,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
            bottom: BorderSide(color: Theme.of(context).colorScheme.tertiary)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: SingleChildScrollView(
        controller: _scrollController,
        padding: EdgeInsets.symmetric(horizontal: appContentHorizontalPadding),
        scrollDirection: Axis.horizontal,
        child: Row(
          children: Utils.weekDays.map((dayKey) {
            final isSelected = dayKey == widget.selectedDayKey;
            return Padding(
              padding: const EdgeInsetsDirectional.only(end: 12.5),
              child: GestureDetector(
                onTap: () {
                  if (isSelected) {
                    return;
                  }
                  widget.onSelectionChange(dayKey);
                },
                child: CircleAvatar(
                  radius: 30.0,
                  backgroundColor: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.surface,
                  child: CustomTextContainer(
                    textKey: dayKey,
                    style: TextStyle(
                        color: isSelected
                            ? Theme.of(context).colorScheme.surface
                            : Theme.of(context).colorScheme.secondary),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
