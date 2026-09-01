/*
@Author - yehenSamarasinghe
@Date - 2026/08/29
*/
import 'package:flutter/material.dart';
import '../../../../themes/utils.dart';

class GlassDropdownItem<T> {
  final T value;
  final String label;
  const GlassDropdownItem({required this.value, required this.label});
}

/// Reusable dropdown matching the glass input style — used for
/// Preferred Language.
class GlassDropdown<T> extends StatelessWidget {
  final String label;
  final IconData icon;
  final List<GlassDropdownItem<T>> items;
  final T value;
  final ValueChanged<T?> onChanged;

  const GlassDropdown({
    super.key,
    required this.label,
    required this.icon,
    required this.items,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 6),
          child: Text(label, style: TextStyle(fontSize: 12, color: mutedTextColor)),
        ),
        Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: canvasBase,
            borderRadius: BorderRadius.circular(kCardRadius),
            border: Border.all(color: glossOutline),
          ),
          child: Row(
            children: [
              Icon(icon, size: 20, color: mutedTextColor),
              const SizedBox(width: 8),
              Expanded(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<T>(
                    value: value,
                    isExpanded: true,
                    dropdownColor: surfaceCards,
                    icon: Icon(Icons.expand_more, size: 16, color: mutedTextColor),
                    style: TextStyle(color: onSurfaceColor, fontSize: 16),
                    items: items
                        .map((item) => DropdownMenuItem<T>(
                              value: item.value,
                              child: Text(item.label,
                                  style: TextStyle(color: onSurfaceColor)),
                            ))
                        .toList(),
                    onChanged: onChanged,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}