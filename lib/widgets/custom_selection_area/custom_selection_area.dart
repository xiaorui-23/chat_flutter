

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// 自定义的选择文字组件
class CustomSelectionArea extends StatefulWidget {

    final Widget? child;
    /// 文字样式
    final TextStyle? itemBodyTextStyle;
    /// 文本放大镜配置
    final TextMagnifierConfiguration? magnifierConfiguration;
    /// 文本选择控制器
    final TextSelectionControls? selectionControls;
    /// 长按文字菜单选择回调
    final Function(SelectedContent?)? onSelectionChanged;
    /// SelectableText 创建时
    final Function(FocusNode focusNode)? createSelectableTextCallback;
    /// 显示的工具菜单
    final Widget Function(BuildContext, SelectableRegionState)? contextMenuBuilder;

    const CustomSelectionArea({
        super.key,
        this.child,
        this.itemBodyTextStyle,
        this.selectionControls,
        this.onSelectionChanged,
        this.contextMenuBuilder,
        this.createSelectableTextCallback, this.magnifierConfiguration
    });


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
        return SelectionArea(
            focusNode: _customSelectionAreaFocusNode,
            selectionControls: widget.selectionControls,
            magnifierConfiguration: widget.magnifierConfiguration,
            onSelectionChanged: widget.onSelectionChanged,
            contextMenuBuilder: widget.contextMenuBuilder ?? (BuildContext context, SelectableRegionState selectableRegionState) {
                return AdaptiveTextSelectionToolbar.buttonItems(
                    anchors: selectableRegionState.contextMenuAnchors,
                    buttonItems: selectableRegionState.contextMenuButtonItems,
                );
            },
            child: widget.child ?? Container(),
        );
    }
}


