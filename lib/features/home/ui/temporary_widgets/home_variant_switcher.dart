import 'package:flutter/material.dart';

class HomeVariantSwitcher extends StatelessWidget {
  const HomeVariantSwitcher({
    required this.labels,
    required this.selectedVariant,
    required this.onVariantSelected,
    super.key,
  });

  final List<String> labels;
  final int selectedVariant;
  final ValueChanged<int> onVariantSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: List.generate(
          labels.length,
          (index) => Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                right: index == labels.length - 1 ? 0 : 8,
              ),
              child: _HomeVariantButton(
                label: labels[index],
                isSelected: selectedVariant == index,
                onTap: () => onVariantSelected(index),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HomeVariantButton extends StatelessWidget {
  const _HomeVariantButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    const borderRadius = BorderRadius.all(Radius.circular(14));

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        color: isSelected ? Colors.black : Colors.white,
        borderRadius: borderRadius,
        border: isSelected
            ? null
            : Border.all(color: Colors.black.withValues(alpha: 0.12)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: borderRadius,
          onTap: onTap,
          child: SizedBox(
            height: 44,
            child: Center(
              child: Text(
                label,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: isSelected ? Colors.white : Colors.black,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
