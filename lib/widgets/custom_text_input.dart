import 'package:flutter/material.dart';
import 'package:wanderly/style/app_text.dart';

class CustomTextInput extends StatefulWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final String? errorText;
  final IconData? icon;
  final bool isPassword;
  final TextInputType keyboardType;

  const CustomTextInput({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    this.errorText,
    this.icon,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
  });

  @override
  State<CustomTextInput> createState() => _CustomTextInputState();
}

class _CustomTextInputState extends State<CustomTextInput> {
  bool _obscure = true;
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// LABEL
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            widget.label,
            style: AppTextStyles.bodyBold(context),
          ),
        ),

        /// INPUT + FOCUS EFFECT
        Focus(
          onFocusChange: (hasFocus) {
            setState(() => _isFocused = hasFocus);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: _isFocused
                  ? [
                      BoxShadow(
                        color: Colors.blue.withValues(alpha: .1),
                        blurRadius: 12,
                        spreadRadius: 1,
                      )
                    ]
                  : [],
            ),
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                TextField(
                  controller: widget.controller,
                  obscureText: widget.isPassword ? _obscure : false,
                  keyboardType: widget.keyboardType,
                  decoration: InputDecoration(
                    hintText: widget.hint,
                    hintStyle: AppTextStyles.textHint(context),
                    filled: true,
                    fillColor: Colors.transparent,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 18,
                      horizontal: 48,
                    ),
                  ),
                ),

                /// LEFT ICON
                if (widget.icon != null)
                  Positioned(
                    left: 16,
                    child: Icon(
                      widget.icon,
                      size: 20,
                      color: Colors.grey,
                    ),
                  ),

                /// PASSWORD TOGGLE
                if (widget.isPassword)
                  Positioned(
                    right: 16,
                    child: GestureDetector(
                      onTap: () {
                        setState(() => _obscure = !_obscure);
                      },
                      child: Icon(
                        _obscure
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        size: 20,
                        color: Colors.grey,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 6),

        /// ERROR (FIXED HEIGHT – NO LAYOUT SHIFT)
        SizedBox(
          height: 18,
          child: AnimatedOpacity(
            opacity: widget.errorText == null ? 0 : 1,
            duration: const Duration(milliseconds: 200),
            child: Text(
              widget.errorText ?? '',
              style: AppTextStyles.errorText(context),
            ),
          ),
        ),
      ],
    );
  }
}
