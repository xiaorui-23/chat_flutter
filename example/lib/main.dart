
import 'package:flutter/material.dart';
import 'package:flutter_chat/flutter_chat.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
    const MyApp({super.key});

    @override
    State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
    FocusNode? _focusNode;

    List<ChatViewItem> chatRecordList = [];

    @override
    void initState() {

        super.initState();
        
        chatRecordList = [
            ChatViewItem(
                itemBody: "hello",
            ),
            ChatViewItem(
                senderRight: false,
                itemBody: "Hi",
            ),
            ChatViewItem(
                itemBody: "不显示头像",
                isAvatarShow: false,
                isOpenTextSelect: true
            ),
            ChatViewItem(
                itemBodyType: ChatViewItemRecordBodyType.audio,
            ),
            ChatViewItem(
                audioTimelength: 10,
                itemBodyType: ChatViewItemRecordBodyType.audio,
            ),
            ChatViewItem(
                senderRight: false,
                itemBody: "Hi, 就阿萨德理解啊睡了多久啊是 啊可是建档立卡上的结论是",
            ),
            ChatViewItem(
                customItem: Text('自定义消息主体'),
            ),
            ChatViewItem(
                isOpenTextSelect: true,
                itemBody: "我是长按文字会出现菜单的文字",
                createSelectableTextCallback:(focusNode) {
                    _focusNode = focusNode;
                },
            ),
            ChatViewItem(
                senderRight: false,
                avatarPath: "https://img1.baidu.com/it/u=3007048469,3759326707&fm=253&fmt=auto&app=120&f=JPEG?w=889&h=500",
                itemBodyRecordTime: '2023-12-13',
                itemBody: "带记录时间",
            ),
            ChatViewItem(
                itemBodyType: ChatViewItemRecordBodyType.image,
                itemBody: "https://img1.baidu.com/it/u=3007048469,3759326707&fm=253&fmt=auto&app=120&f=JPEG?w=889&h=500",
            ),
            ChatViewItem(
                senderRight: false,
                itemBodyType: ChatViewItemRecordBodyType.image,
                itemBody: "https://img1.baidu.com",
            ),
            ChatViewItem(
                senderRight: false,
                avatarPath: "https://img1.baidu.com/it/u=3007048469,3759326707&fm=253&fmt=auto&app=120&f=JPEG?w=889&h=500",
                itemBody: "头像网络图片",
            ),
            ChatViewItem(
                avatarPath: "assets/logo.png",
                itemBody: "头像本地图片",
            ),
            ChatViewItem(
                itemBodyType: ChatViewItemRecordBodyType.file,
                itemBody: "我是文件名称",
            ),
        ];
    }
    

    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            home: Scaffold(
                appBar: AppBar(
                    centerTitle: true,
                    // title: const Text('flutter_chat 插件展示案例'),
                ),
                backgroundColor: const Color.fromARGB(255, 239, 238, 234),
                body: GestureDetector(
                    onTap: () {
                        if (_focusNode != null){
                            _focusNode!.unfocus();
                        }
                    },
                    child: Column(
                        children: [
                            Expanded(
                                child: ChatViewWidget(
                                    isNeedScrollBottom: true,
                                    children: chatRecordList,
                                    onCreated: (chatViewWidgetController) {},
                                )
                            ),
                        ],
                    ),
                ),
            ),
        );
    }
}

