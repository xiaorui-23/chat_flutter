
import 'package:flutter/material.dart';
import 'package:chat_flutter/chat_flutter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('test chat_flutter', (WidgetTester tester) async {
    await tester.runAsync(() async {
      await tester.pumpWidget(const App());

      expect(find.byType(App), findsOneWidget);
    });
  });
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  List<ChatViewItem> chatRecordList = [];

  @override
  void initState() {
    super.initState();

    chatRecordList = [
      const ChatViewItem(
        itemBody: "hello",
      ),
      const ChatViewItem(
        senderRight: false,
        itemBody: "Hi",
      ),
      ChatViewItem(
        itemBody: "不显示头像",
        avatarModel: ChatViewItemAvatarModel(
          isAvatarShow: false,
        ),
        textTypeModel: ChatViewItemTextTypeModel(isOpenTextSelect: true),
      ),
      const ChatViewItem(
        itemBodyType: ChatViewItemRecordBodyType.audio,
      ),
      ChatViewItem(
        audioTypeModel: ChatViewItemAudioTypeModel(
          audioTimelength: 10,
        ),
        itemBodyType: ChatViewItemRecordBodyType.audio,
      ),
      const ChatViewItem(
        senderRight: false,
        itemBody: "Hi, 就阿萨德理解啊睡了多久啊是 啊可是建档立卡上的结论是",
      ),
      const ChatViewItem(
        customItem: Text('自定义消息主体'),
      ),
      ChatViewItem(
        itemBody: "我是长按文字会出现菜单的文字",
        textTypeModel: ChatViewItemTextTypeModel(
          isOpenTextSelect: true,
          createSelectableTextCallback: (focusNode) {},
        ),
      ),
      ChatViewItem(
        senderRight: false,
        avatarModel: ChatViewItemAvatarModel(
          avatarPath:
              "https://img1.baidu.com/it/u=3007048469,3759326707&fm=253&fmt=auto&app=120&f=JPEG?w=889&h=500",
        ),
        itemBodyRecordTime: '2023-12-13',
        itemBody: "带记录时间",
      ),
      const ChatViewItem(
        itemBodyType: ChatViewItemRecordBodyType.image,
        itemBody:
            "https://img1.baidu.com/it/u=3007048469,3759326707&fm=253&fmt=auto&app=120&f=JPEG?w=889&h=500",
      ),
      const ChatViewItem(
        senderRight: false,
        itemBodyType: ChatViewItemRecordBodyType.image,
        itemBody: "https://img1.baidu.com",
      ),
      ChatViewItem(
        senderRight: false,
        avatarModel: ChatViewItemAvatarModel(
          avatarPath:
              "https://img1.baidu.com/it/u=3007048469,3759326707&fm=253&fmt=auto&app=120&f=JPEG?w=889&h=500",
        ),
        itemBody: "头像网络图片",
      ),
      ChatViewItem(
        avatarModel: ChatViewItemAvatarModel(
          avatarPath: "assets/logo.png",
        ),
        itemBody: "头像本地图片",
      ),
      const ChatViewItem(
        itemBodyType: ChatViewItemRecordBodyType.file,
        itemBody: "我是文件名称",
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: ChatViewWidget(
          children: chatRecordList,
        ),
      ),
    );
  }
}
