import 'package:flutter/material.dart';

class ProgressStepIndicator extends StatelessWidget {
  final double currentStep;
  final int totalSteps;
  final Color activeColor;
  final Color inactiveColor;

  const ProgressStepIndicator({
    super.key,
    required this.currentStep,
    this.totalSteps = 5,
    this.activeColor = const Color(0xFF2B5C43),
    this.inactiveColor = const Color(0xFFD7E8D5),
  });

  @override
  Widget build(BuildContext context) {
    final fullSteps = currentStep.floor();
    final hasHalfStep = currentStep - fullSteps > 0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalSteps, (index) {
        final isCompleted = index < fullSteps;
        final isHalf = hasHalfStep && index == fullSteps;
        final isActive = isCompleted || isHalf;

        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: index == totalSteps - 1 ? 0 : 8),
            child: SizedBox(
              height: 6,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(3),
                child: Stack(
                  children: [
                    Positioned.fill(child: Container(color: inactiveColor)),
                    if (isHalf)
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: FractionallySizedBox(
                            widthFactor: 0.5,
                            child: Container(color: activeColor),
                          ),
                        ),
                      )
                    else if (isActive)
                      Positioned.fill(child: Container(color: activeColor)),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
