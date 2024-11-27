## 3.0.0

Adapt to 3.24.0

## 2.0.2

Optimize known issues.

## 2.0.1

Modify Document Description.

## 2.0.0

- Optimize known issues and some performance issues.

- Reconstructed and assembled `ChatViewItem` parameter transfer to enhance code reading visualization. <br />
  Integration of parameter content based on message display type and avator.

- Add functions such as video display and playback. <br />
  Below is a list of newly added parameters. <br />

Detailed content can be viewed `README.md` or `README_CN.md`.

|          Name           |             Type              |                        Describe                        | Default value |
| :---------------------: | :---------------------------: | :----------------------------------------------------: | :-----------: |
|   `notPlayingWidget`    |           `Widget`            |                Custom widget not played                |      --       |
|   `playingFailWidget`   |           `Widget`            |                Play Error Custom Widget                |      --       |
|      `autoPlaying`      |            `bool`             | Whether to automatically play during interface display |    `true`     |
| `videoLoadFailCallback` | `void Function(Object error)` |              Video loading error callback              |      --       |

## 1.1.0

Add Image preview function.

Below is a list of newly added parameters.
Detailed content can be viewed `README.md` or `README_CN.md`.

|             Name             |                           Type                            |                                                               Describe                                                               | Default value |
| :--------------------------: | :-------------------------------------------------------: | :----------------------------------------------------------------------------------------------------------------------------------: | :-----------: |
|     `isOpenPreviewImage`     |                          `bool`                           |                                                           是否开启图片预览                                                           |    `false`    |
| `previewImageLongPressMenu`  |                      `List<String>`                       |                                               Preview Image Long Press to Display Menu                                               |      --       |
|   `onPreviewImageTapMenu`    | `Function(String data, int index, List<String> menuList)` |                                                  Preview Image Menu Click Callback                                                   |      --       |
| `customPreviewImageCallback` |               `Function(String imagePath)`                | Custom preview image callback. Note: When passing this parameter, the preview scheme provided by the library will no longer be used. |      --       |
|      `customLongPress`       |             `Function(BuildContext context)`              |                                               Custom long press image display callback                                               |      --       |

## 1.0.10

Optimize known issues.

## 1.0.9

Optimize known issues.

## 1.0.8

Optimize.

## 1.0.7

Adjusting and optimizing the UI layout

## 1.0.6

Adjusting and optimizing the UI layout

## 1.0.5

Adjustment structure.

## 1.0.4

Optimize known issues.

## 1.0.3

Add customization of chat time record subject and style.

## 1.0.2

Optimize known issues.

## 1.0.1

Optimize known issues.

## 1.0.0

`chat_flutter` Officially released.
