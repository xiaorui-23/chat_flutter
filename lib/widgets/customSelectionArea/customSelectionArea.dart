

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_chat/utils/screenutil/screenutil.dart';

/// 自定义的选择文字组件
class CustomSelectionArea extends StatefulWidget {
    CustomSelectionArea({
        super.key,
        this.child,
        this.itemBodyTextStyle,
        this.selectionControls,
        this.onSelectionChanged,
        this.contextMenuBuilder,
        this.createSelectableTextCallback
    });

    Widget? child;
    /// 文字样式
    TextStyle? itemBodyTextStyle;
    /// 文本放大镜配置
    TextMagnifierConfiguration? magnifierConfiguration;
    /// 文本选择控制器
    TextSelectionControls? selectionControls;
    /// 长按文字菜单选择回调
    Function(SelectedContent?)? onSelectionChanged;
    /// SelectableText 创建时
    Function(FocusNode focusNode)? createSelectableTextCallback;
    /// 显示的工具菜单
    Widget Function(BuildContext, SelectableRegionState)? contextMenuBuilder;

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


