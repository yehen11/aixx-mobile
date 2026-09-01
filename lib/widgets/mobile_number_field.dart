/*
@Author - yehenSamarasinghe
@Date - 2026/08/29
*/
import 'package:flutter/material.dart';
import '../../../../themes/utils.dart';

class CountryCode {
  final String flag;
  final String code;
  const CountryCode(this.flag, this.code);
}

/// The 5 mandatory regional codes from the design brief.
const List<CountryCode> kSupportedCountryCodes = [
  CountryCode('🇸🇬', '+65'),
  CountryCode('🇲🇾', '+60'),
  CountryCode('🇮🇩', '+62'),
  CountryCode('🇮🇳', '+91'),
  CountryCode('🇱🇰', '+94'),
];

/// Mobile number field with an inline country-code dropdown segment.
class MobileNumberField extends StatefulWidget {
  final TextEditingController? controller;
  final CountryCode initialCode;
  final ValueChanged<CountryCode>? onCodeChanged;

  const MobileNumberField({
    super.key,
    this.controller,
    this.initialCode = const CountryCode('🇱🇰', '+94'),
    this.onCodeChanged,
  });

  @override
  State<MobileNumberField> createState() => _MobileNumberFieldState();
}

class _MobileNumberFieldState extends State<MobileNumberField> {
  late CountryCode _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialCode;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 6),
          child: Text('Mobile Number', style: TextStyle(fontSize: 12, color: mutedTextColor)),
        ),
        Container(
          height: 48,
          decoration: BoxDecoration(
            color: canvasBase,
            borderRadius: BorderRadius.circular(kCardRadius),
            border: Border.all(color: glossOutline),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  border: Border(right: BorderSide(color: glossOutline)),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<CountryCode>(
                    value: _selected,
                    dropdownColor: surfaceCards,
                    icon: Icon(Icons.expand_more, size: 16, color: mutedTextColor),
                    selectedItemBuilder: (context) => kSupportedCountryCodes
                        .map((c) => Center(
                              child: Text('${c.flag} ${c.code}',
                                  style: TextStyle(color: onSurfaceColor)),
                            ))
                        .toList(),
                    items: kSupportedCountryCodes
                        .map((c) => DropdownMenuItem(
                              value: c,
                              child: Text('${c.flag} ${c.code}',
                                  style: TextStyle(color: onSurfaceColor)),
                            ))
                        .toList(),
                    onChanged: (val) {
                      if (val == null) return;
                      setState(() => _selected = val);
                      widget.onCodeChanged?.call(val);
                    },
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: widget.controller,
                  keyboardType: TextInputType.phone,
                  style: TextStyle(color: onSurfaceColor, fontSize: 16),
                  decoration: InputDecoration(
                    hintText: '8123 4567',
                    hintStyle: TextStyle(color: mutedTextColor),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    isDense: true,
                    contentPadding: const EdgeInsets.only(right: 12),
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