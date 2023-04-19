
# chat_flutter

这是一个纯 `dart` 开发的开发的 聊天记录 列表展示的组件包，支持图片、文件、语音、文字、视频的基础内容展示。




[English](https://github.com/xiaorui-23/chat_flutter/blob/master/README.md)



## 效果图



<div>
    <img src="https://raw.githubusercontent.com/xiaorui-23/chat_flutter/master/example/assets/rendering/rendering_1.png" width="200" height="400" />
    <img src="https://raw.githubusercontent.com/xiaorui-23/chat_flutter/master/example/assets/rendering/rendering_2.png" width="200" height="400" />
</div>

## 特点



此工具组件可以展示聊天记录，常用于聊天记录内容的展示。

展示内容支持以下基础内容：

- 图片 -> image
- 文件 -> file
- 文字 -> text
- 音频 -> audio
- 视频 -> video  <--> 暂不支持




## 安装



### 一、

你可以直接在`pubspec.yaml`文件中的`dependencies`下添加以进行安装。

```dart
chat_flutter: ^1.0.0
```

如下面这样：

```dart
dependencies:
  chat_flutter: ^1.0.0
```

### 二、

你还可以在处于项目根目录的终端中执行下面这条命令进行安装：

```dart
flutter pub add chat_flutter
```

## 使用 

在需要使用的页面进行引入：

```dart
import 'package:chat_flutter/chat_flutter.dart';
```

完整使用案例：

```dart
import 'package:flutter/material.dart';
import 'package:chat_flutter/chat_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
            children: [
                Expanded(
                    child: ChatViewWidget()
                )
            ],
        ),
    );
  }
}
```



更多使用案例可点击[这里](https://github.com/xiaorui-23/chat_flutter)中的`/example/lib/main.dart`进行查看。



## 使用注意



本插件只提供展示，不提供功能的实现。如以下功能并未实现：

- 当展示记录内容为音频时，本插件并未实现音频的播放，需要使用者自己实现音频播放功能。



本插件未对插件内容进行宽度、高度限制，故此您在使用的过程中需要对插件包裹的`widget`盒子进行设定宽高。



## 关于插件机型适配问题



本插件自身以`flutter_screenutil`插件为基础进行了多机型适配，故此您在使用的过程中不必担心在使用的过程中遇到`UI`错乱等问题，若您使用的机型未进行到适配，导致 `UI` 样式错乱等问题，您可以通过下方的联系方式联系我，以便为您提供帮助。



## 关于插件依赖问题



作者发现插件中使用的依赖有更新后，将在第一时间进行依赖更新。为了您在使用过程中有更顺畅的体验，建议您第一时间更新插件，或者在`pubspec.yaml`文件中版本号前添加`^`符号，以便使用最新版本的插件。



## 关于自定义



此插件提供了高度的自定义，以方便您不满足时插件方面提供的功能及`UI`时进行自定义，以达到您的需求。



## 案例及详细使用参考指南



若您感觉到本页面提供的案例、使用帮助无法让您顺利成功上手此插件，您可以点击[这里](https://github.com/xiaorui-23/chat_flutter)并进入`example/lib/main.dart`文件查看详细的使用案例。或者您可以通过下方的联系方式进行联系我。



## API参数说明

### `ChatViewWidget` 说明

| 名称 | 类型 | 描述 | 默认值 |
| :----: | :----: | :----: | :----: |
| `children` | `List<ChatViewItem>` | 记录列表  | `[]` |
| `isNeedScrollBottom` | `bool` | 初始渲染时是否滑动到底部  | `false` |
| `onCreated` | `Function(ScrollController chatViewWidgetController)` | 创建完成时, 返回一个`ScrollController`类型的列表滑动控制器  | -- |


### `ChatViewItem` 说明



#### 公共参数 API



| 名称 | 类型 | 描述 | 默认值 |
| :----: | :----: | :----: | :----: |
| `itemBody` | `dynamic` | 内容。根据`itemBodyType`的类型不同时所传递的内容也不同。当 `itemBodyType = ChatViewItemRecordBodyType.audio`时可不传递，详细使用可参考案例。  | -- |
| `senderRight` | `bool` | 是否为 右侧 己方  | `true` |
| `avatarPath` | `String` | 头像地址, 当未传递时，将采用 默认头像地址，若都未传递，则采用 自带的 icon 头像方案  | -- |
| `defaultAvatarPath` | `String` | 默认头像地址 | -- |
| `isAvatarShow` | `bool` | 是否展示头像 | `true` |
| `avatarSize` | `double` | 头像大小 | 适配后的 `45` |
| `avatarColor` | `Color` | 头像颜色 | -- |
| `customAvatar` | `Widget` | 自定义头像 | -- |
| `customRecordTimeWidget` | `Widget` | 自定义时间记录 `widget` | -- |
| `customRecordTimeStyle` | `TextStyle` | 自定义时间记录样式 | -- |
| `chatViewItemRecordBodyBoxConstraints` | `BoxConstraints` | 内容主体约束 | -- |
| `itemBodyType` | `ChatViewItemRecordBodyType` | 当前记录内容类型 | `文本｜text` |
| `customAvatarWidget` | `Widget` | 自定义头像 | -- |
| `itemBodyRecordTime` | `String` | 记录时间 | -- |
| `backgroundColor` | `Color` | 记录主体的背景色 | `Colors.white` |
| `customItem` | `Widget` | 自定义记录主体 | -- |
| `avatarTap` | `Function` | 头像点击回调 | -- |
| `itemBodyTap` | `Function` | 内容主体点击事件 | -- |
| `itemBodyMediaTap` | `Function(ChatViewItemRecordBodyType type)` | 文件、图片、音频 点击事件 | -- |



#### 文本



| 名称 | 类型 | 描述 | 默认值 |
| :----: | :----: | :----: | :----: |
| `selectionControls` | `TextSelectionControls` | 文本选择控制器。当 `isOpenTextSelect` 开启有效。 | -- |
| `itemBodyTextStyle` | `TextStyle` | 记录主体的文字样式 | `TextStyle (color: const Color(0xff1989fa),fontSize: 16` |
| `isOpenTextSelect` | `bool` | 是否打开长按文字菜单 | `true` |
| `contextMenuBuilder` | `Widget Function(BuildContext context, SelectableRegionState selectableRegionState)` | 显示的工具菜单 | -- |
| `onSelectionChanged` | `Function(SelectedContent?)` | 长按文字菜单选择回调 | -- |
| `createSelectableTextCallback` | `Function(FocusNode focusNode)` | 可选文字内容 `widget` 创建时的回调 | -- |



#### 音频



| 名称 | 类型 | 描述 | 默认值 |
| :----: | :----: | :----: | :----: |
| `audioTimelength` | `int` | 音频时长  | `0` |
| `audioPlayStatus` | `bool` | 播放状态  | `false` |



#### 图片



无特别参数说明。



#### 视频



暂不支持。



## 联系作者



当您在使用的过程中遇到了问题，可点击[这里](https://github.com/xiaorui-23/chat_flutter)进行`issue`提出问题或者通过下方的联系方式联系我，看到您的联系时或提出的`issue`我将第一时间进行回复并联系您。

- [github](https://github.com/xiaorui-23/chat_flutter)
- [gitee](https://gitee.com/xiaorui-23/flutter_chat)

