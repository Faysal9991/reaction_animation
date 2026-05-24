import 'package:flutter/material.dart';

class PersonCard extends StatelessWidget {
  const PersonCard({
    super.key,
    required this.imageUrl,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.imageKey,
    this.selectedText = 'Selected',
    this.unselectedText = 'Tap to select',
  });

  final String imageUrl;
  final Key? imageKey;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final String selectedText;
  final String unselectedText;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedScale(
        scale: isSelected ? 1.035 : 1,
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOutBack,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isSelected
                  ? [
                      const Color(0xff263bff).withValues(alpha: 0.95),
                      const Color(0xff1c1c24),
                      const Color(0xff1c1c24),
                    ]
                  : [const Color(0xff242431), const Color(0xff171720)],
            ),
            border: Border.all(
              color: isSelected
                  ? Colors.blueAccent
                  : Colors.white.withValues(alpha: 0.06),
              width: isSelected ? 2.5 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: isSelected
                    ? Colors.blueAccent.withValues(alpha: 0.38)
                    : Colors.black.withValues(alpha: 0.35),
                blurRadius: isSelected ? 35 : 18,
                spreadRadius: isSelected ? 2 : 0,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(22),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.network(
                            imageUrl,
                            key: imageKey,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: const Color(0xff2b2b34),
                                alignment: Alignment.center,
                                child: const Icon(
                                  Icons.person,
                                  color: Colors.white54,
                                  size: 72,
                                ),
                              );
                            },
                          ),
                          DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withValues(alpha: 0.50),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isSelected ? selectedText : unselectedText,
                    style: TextStyle(
                      color: isSelected
                          ? Colors.blueAccent.shade100
                          : Colors.white54,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Positioned(
                top: 12,
                right: 12,
                child: AnimatedScale(
                  scale: isSelected ? 1 : 0,
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOutBack,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blueAccent.withValues(alpha: 0.45),
                          blurRadius: 20,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
