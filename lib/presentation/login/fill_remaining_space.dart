import 'package:flutter/material.dart';

class FillRemainigSpace extends StatelessWidget {
  final Widget? header;
  final Widget toExpand;
  final Widget? footer;

  final ScrollController? controller;

  const FillRemainigSpace({
    super.key,
    this.header,
    required this.toExpand,
    this.footer,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints viewportConstraints) {
        return SingleChildScrollView(
          controller: controller,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: viewportConstraints.maxWidth,
              minHeight: viewportConstraints.maxHeight,
            ),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (header != null) header!,
                  Expanded(child: toExpand),
                  if (footer != null) footer!,
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
