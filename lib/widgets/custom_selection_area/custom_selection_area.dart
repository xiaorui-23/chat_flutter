import 'package:flutter/material.dart';

/// 自定义的选择文字组件
class CustomSelectionArea extends StatefulWidget {
  /// 是否开启
  final bool isOpen;

  /// 子组件
  final Text child;

  /// 文字样式
  final TextStyle? itemBodyTextStyle;

  /// 文本放大镜配置
  final TextMagnifierConfiguration? magnifierConfiguration;

  /// 文本选择控制器
  final TextSelectionControls? selectionControls;

  /// 长按文字菜单选择回调
  final void Function(TextSelection selection, SelectionChangedCause? cause)?
      onSelectionChanged;

  /// SelectableText 创建时
  final void Function(FocusNode focusNode)? createSelectableTextCallback;

  /// 显示的工具菜单
  final Widget Function(
          BuildContext context, EditableTextState editableTextState)?
      contextMenuBuilder;

  const CustomSelectionArea(
      {super.key,
      required this.child,
      this.isOpen = true,
      this.itemBodyTextStyle,
      this.selectionControls,
      this.onSelectionChanged,
      this.contextMenuBuilder,
      this.createSelectableTextCallback,
      this.magnifierConfiguration});

  @override
  State<CustomSelectionArea> createState() => _CustomSelectionAreaState();
}

class _CustomSelectionAreaState extends State<CustomSelectionArea> {
  final FocusNode _customSelectionAreaFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    if (widget.createSelectableTextCallback != null) {
      widget.createSelectableTextCallback!(_customSelectionAreaFocusNode);
    }
  }

  @override
  void dispose() {
    _customSelectionAreaFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: widget.isOpen
          ? SelectableText(
              widget.child.data.toString(),
              focusNode: _customSelectionAreaFocusNode,
              selectionControls: widget.selectionControls,
              magnifierConfiguration: widget.magnifierConfiguration,
              onSelectionChanged: widget.onSelectionChanged,
              contextMenuBuilder: widget.contextMenuBuilder ??
                  (BuildContext context, EditableTextState editableTextState) {
                    return AdaptiveTextSelectionToolbar.buttonItems(
                      anchors: editableTextState.contextMenuAnchors,
                      buttonItems: editableTextState.contextMenuButtonItems,
                    );
                  },
              style: widget.child.style,
              textAlign: widget.child.textAlign,
            )
          : widget.child,
    );
  }
}
