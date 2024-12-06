import 'package:flutter/material.dart';

import '../../../common/app_colors.dart';
import '../../../common/app_text_style.dart';
import '../../../common/ui_helpers.dart';

class FormRow extends StatelessWidget {
  const FormRow(
      {super.key,
      required this.title,
      this.subtitle,
      this.trailing,
      this.onTap});

  final Widget title;

  final Widget? subtitle;

  final Widget? trailing;

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.fromLTRB(14, 10, 8, 10),
        // constraints: const BoxConstraints(minHeight: 48),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DefaultTextStyle(
                    style: AppTextStyle.h3Normal,
                    child: title,
                  ),
                  const SizedBox(height: 4),
                  if (subtitle != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: DefaultTextStyle(
                        style: AppTextStyle.h3Normal,
                        child: subtitle!,
                      ),
                    ),
                ],
              ),
            ),
            if (trailing != null)
              DefaultTextStyle(
                style: AppTextStyle.h3Normal,
                child: IconTheme(
                  data:
                      const IconThemeData(color: whiteColor, size: mediumSize),
                  child: trailing!,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class FormSection extends StatelessWidget {
  const FormSection(
      {super.key, required this.children, this.header, this.footer});

  final List<Widget> children;

  final Widget? header;

  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Column(
        children: [
          if (header != null)
            Container(
              alignment: Alignment.bottomLeft,
              // padding: const EdgeInsets.fromLTRB(16, 0, 10, 4),
              // constraints: const BoxConstraints(minHeight: 36),
              child: DefaultTextStyle(
                style: AppTextStyle.h3Normal,
                child: header!,
              ),
            ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 2),
            child: Column(
              children: List.generate(
                children.isEmpty ? 0 : children.length * 2 - 1,
                (i) => i.isOdd
                    ? const Divider(height: 1, thickness: 1)
                    : children[i ~/ 2],
              ),
            ),
          ),
          if (footer != null)
            Container(
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.fromLTRB(16, 4, 10, 0),
              // constraints: const BoxConstraints(minHeight: 36),
              child: DefaultTextStyle(
                style: AppTextStyle.withColor(
                  color: whiteColor,
                  style: AppTextStyle.h4Normal.copyWith(fontSize: 18),
                ),
                child: footer!,
              ),
            ),
        ],
      ),
    );
  }
}
