
library chat_flutter;

import 'package:chat_flutter/utils/chat_image_list/chat_image_list.dart';
import 'package:chat_flutter/utils/stable/stable.dart';
import 'package:flutter/widgets.dart';
import 'package:chat_flutter/utils/screenutil/screenutil.dart';
import 'package:chat_flutter/widgets/chat_view_item/chat_view_item.dart';
import 'package:chat_flutter/utils/chat_view_item_record_body_type/chat_view_item_record_body_type.dart';

export 'package:chat_flutter/widgets/chat_view_item/chat_view_item.dart';
export 'package:chat_flutter/utils/parameter_model_set/parameter_model_set.dart';
export 'package:chat_flutter/utils/chat_view_item_record_body_type/chat_view_item_record_body_type.dart';


/// 聊天记录页面容器
class ChatViewWidget extends StatefulWidget {

    /// 记录列表
    final List<ChatViewItem>? children;
    /// 初始渲染时是否滑动到底部
    final bool isNeedScrollBottom;
    /// 是否开启图片预览
    final bool isOpenPreviewImage;
    /// 创建完成时
    /// * [chatViewWidgetListViewController] 列表展示控制器
    /// * [chatViewWidgetController] 列表展示盒子控制器
    final void Function(ScrollController chatViewWidgetListViewController, ChatViewWidgetController chatViewWidgetController)? onCreated;

    const ChatViewWidget({
        super.key,
        this.children,
        this.isNeedScrollBottom = false,
        this.isOpenPreviewImage = false,
        this.onCreated
    });

    @override
    State<ChatViewWidget> createState() => _ChatViewWidgetState();
}

class _ChatViewWidgetState extends State<ChatViewWidget> {
    final ScrollController _chatViewWidgetListViewController = ScrollController ();
    final ChatViewWidgetController _chatViewWidgetController = ChatViewWidgetController ();

    @override
    void initState() {
        super.initState();
        
        // 执行创建完成时回调
        _created ();

        // 注册监听器
        _chatViewWidgetController.registerListeningCallback(_registerListeningCallback);
    }

    @override
    void dispose() {
        _chatViewWidgetController.dispose();
        _chatViewWidgetListViewController.dispose();

        super.dispose();
    }

    @override
    Widget build(BuildContext context) {
        initScreenUtil(context);

        // 对一些需要在构建时需要进行修改的参数进行修改
        _buildModifyParam ();
        
        return FutureBuilder(
            future: _initStateScrollBottom(),
            builder:(context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                    return Container();
                }
                
                return SizedBox(
                    width: sw(375),
                    child: ListView.builder(
                        controller: _chatViewWidgetListViewController,
                        padding: const EdgeInsets.all(0),
                        physics: const AlwaysScrollableScrollPhysics(),
                        reverse: widget.isNeedScrollBottom,
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (BuildContext context, int index) => snapshot.data![index],
                    ),
                );
            },
        );

    }

    /// 根据 初始渲染时是否需要滑动到底部 状态进行设置当前列表记录
    Future<List<ChatViewItem>> _initStateScrollBottom () async {
        if (!widget.isNeedScrollBottom){
            return widget.children ?? [];
        }

        return (widget.children ?? []).reversed.toList();
    }

    /// 对一些需要在构建时需要进行修改的参数进行修改
    void _buildModifyParam () {
        // 修改当前图片可预览状态
        ChatImageList.modyfyIsOpenPreviewImage(status: widget.isOpenPreviewImage);
        // 修改当前翻转状态
        ChatImageList.modifyIsNeedScrollBottom(widget.isNeedScrollBottom);
        // 在每次构建主体时清除所有内容
        ChatImageList.clearImageList();
    }

    /// 记录展示界面控制器-监听器内容
    void _registerListeningCallback (ChatViewWidgetControllerListenType type, {ChatViewItem? chatViewItem, List<ChatViewItem>? chatViewItemList}) {
        
        if (widget.children == null) {
            return;
        }

        switch (type) {
            case ChatViewWidgetControllerListenType.add:
                widget.children!.add(chatViewItem!);
                break;
            case ChatViewWidgetControllerListenType.addAll:
                widget.children!.addAll(chatViewItemList!);
                break;
            case ChatViewWidgetControllerListenType.remove:
                widget.children!.remove(chatViewItem!);
                break;
            case ChatViewWidgetControllerListenType.clear:
                widget.children!.clear();
                break;
        }

        _chatViewWidgetListViewController.animateTo(
            widget.isNeedScrollBottom ? 0 : _chatViewWidgetListViewController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeIn
        );

        if (mounted){
            setState(() {
            
            });
        }
    }

    /// 创建完成时
    Future<void> _created () async {
        // 执行创建完成时回调, 刷新页面
        await Future.delayed(const Duration(milliseconds: 600));

        if (widget.onCreated != null){
            widget.onCreated!(_chatViewWidgetListViewController, _chatViewWidgetController);
        }
    }
}


/// 监听器回调类型
typedef CallbackType = void Function(ChatViewWidgetControllerListenType type, {ChatViewItem? chatViewItem, List<ChatViewItem>? chatViewItemList});

/// 记录展示界面控制器
class ChatViewWidgetController {
    /// 已注册监听回调
    final List<CallbackType> _listeningCallback = [];
    
    /// 添加记录
    void add (ChatViewItem chatViewItem) {
        _notification (
            ChatViewWidgetControllerListenType.add,
            chatViewItem: chatViewItem,
        );
    }

    /// 添加多个记录
    void addAll (List<ChatViewItem> chatViewItemList) {
        _notification (
            ChatViewWidgetControllerListenType.addAll,
            chatViewItemList: chatViewItemList,
        );
    }

    /// 删除
    void remove (ChatViewItem chatViewItem) => _notification (ChatViewWidgetControllerListenType.remove);

    /// 清空
    void clear () => _notification (ChatViewWidgetControllerListenType.clear);

    /// 通知
    void _notification (ChatViewWidgetControllerListenType type, {ChatViewItem? chatViewItem, List<ChatViewItem>? chatViewItemList}) {
        if (_listeningCallback.isNotEmpty) {
            for(var fn in _listeningCallback) {
                fn (
                    type, 
                    chatViewItem: chatViewItem,  
                    chatViewItemList: chatViewItemList
                );
            }
        }
    }

    /// 注册监听回调
    void registerListeningCallback(CallbackType listener) {
        _listeningCallback.add(listener);
    }
    
    /// 移除监听回调
    void removeListeningCallback(CallbackType listener) {
        _listeningCallback.remove(listener);
    }
    
    /// 释放
    void dispose () {
        _listeningCallback.clear();
    }
}


/// 控制器监听回调类型
enum ChatViewWidgetControllerListenType {
    /// 添加
    add,
    /// 添加多个
    addAll,
    /// 移除
    remove,
    /// 清空
    clear
}


