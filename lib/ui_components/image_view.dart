import 'dart:io';

import 'package:doclense/configs/app_dimensions.dart';
import 'package:doclense/configs/app_typography.dart';
import 'package:doclense/configs/space.dart';
import 'package:doclense/constants/appstrings.dart';
import 'package:doclense/constants/route_constants.dart';
import 'package:doclense/providers/image_list.dart';
import 'package:doclense/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_editor_plus/image_editor_plus.dart' hide ImageCropper;
import 'package:provider/provider.dart';

class Imageview extends StatefulWidget {
  final File file;
  final ImageList list;

  const Imageview(this.file, this.list);

  @override
  _ImageviewState createState() => _ImageviewState();
}

class _ImageviewState extends State<Imageview> {
  bool _isLoading = true;
  List<File> files = [];
  int index = 0;

  @override
  void initState() {
    super.initState();
    files.add(widget.file);
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  Future<void> cropimage(File file, Color appBarColor, Color bgColor) async {
    if (await file.exists()) {
      try {
        final croppedFile = await ImageCropper().cropImage(
          sourcePath: file.path,
          compressQuality: 80,
          uiSettings: [
            AndroidUiSettings(
              toolbarTitle: 'Recortar Imagem',
              toolbarColor: appBarColor,
              toolbarWidgetColor: Colors.white,
              backgroundColor: bgColor,
            ),
          ],
        );

        setState(() {
          if (croppedFile != null) {
            files.add(File(croppedFile.path));
            index++;
          }
        });
      } catch (e) {
        print('Erro ao recortar imagem: $e');
        // Fallback ao editor de imagem se o recorte falhar
        await getFilterImage(context, appBarColor);
      }
    }
  }

  Future<void> getFilterImage(BuildContext context, Color appBarColor) async {
    File filterfile;
    if (files.isNotEmpty) {
      filterfile = files[index];
    } else {
      filterfile = widget.file;
    }

    // Usando o ImageEditor diretamente
    final editedImage = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ImageEditor(image: filterfile.readAsBytesSync()),
      ),
    );

    if (editedImage != null) {
      // Salvar a imagem editada
      final editedFile = File(
        filterfile.path.replaceFirst('.jpg', '_edited.jpg'),
      );
      await editedFile.writeAsBytes(editedImage);

      setState(() {
        files.add(editedFile);
        index++;
      });
      print(editedFile.path);
    }
  }

  Future<void> _showChoiceDialogHome(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          backgroundColor: Colors.blueGrey[800],
          title: Text(
            S.deleteWarning,
            textAlign: TextAlign.center,
            style: AppText.b1!.cl(Colors.white),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    widget.list.imagelist = [];
                    widget.list.imagepath = [];

                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  child: Text(
                    S.yes,
                    textAlign: TextAlign.center,
                    style: AppText.b1!.cl(Colors.white),
                  ),
                ),
                Space.y!,
                GestureDetector(
                  onTap: () {
                    Navigator.of(ctx).pop();
                  },
                  child: Text(
                    S.no,
                    textAlign: TextAlign.center,
                    style: AppText.b1!.cl(Colors.white),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    final Color appBarColor =
        themeChange.darkTheme ? Colors.black : Colors.blue[600]!;
    final Color bgColor = themeChange.darkTheme ? Colors.black54 : Colors.white;

    return Scaffold(
      body:
          _isLoading
              ? const SpinKitRotatingCircle(color: Colors.blue)
              : SafeArea(
                child: Column(
                  children: <Widget>[
                    Expanded(
                      flex: 10,
                      child: Padding(
                        padding: Space.all(0.75),
                        child: Image.file(files[index]),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        color:
                            themeChange.darkTheme
                                ? Colors.black87
                                : Colors.blue[600],
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            TextButton(
                              onPressed: () {
                                _showChoiceDialogHome(context);
                              },
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Icon(
                                    Icons.arrow_back,
                                    color: Colors.white,
                                    size: AppDimensions.font(10),
                                  ),
                                  Text(
                                    S.back,
                                    style: AppText.l1!.cl(Colors.white),
                                  ),
                                ],
                              ),
                            ),
                            Opacity(
                              opacity: index == 0 ? 0.5 : 1,
                              child: TextButton(
                                onPressed: () {
                                  if (index == 0) {
                                    print("no undo possible");
                                  } else {
                                    setState(() {
                                      index--;
                                      files.removeLast();
                                      print(widget.list.imagelist.length);
                                    });
                                  }
                                },
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Icon(
                                      Icons.undo,
                                      color: Colors.white,
                                      size: AppDimensions.font(10),
                                    ),
                                    Text(
                                      S.back,
                                      style: AppText.l1!.cl(Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                if (files.isNotEmpty) {
                                  cropimage(files[index], appBarColor, bgColor);
                                } else {
                                  cropimage(widget.file, appBarColor, bgColor);
                                }
                              },
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Icon(
                                    Icons.crop_rotate,
                                    color: Colors.white,
                                    size: AppDimensions.font(10),
                                  ),
                                  Text(
                                    S.crop,
                                    style: AppText.l1!.cl(Colors.white),
                                  ),
                                ],
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                getFilterImage(context, appBarColor);
                              },
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Icon(
                                    Icons.filter,
                                    color: Colors.white,
                                    size: AppDimensions.font(10),
                                  ),
                                  Text(
                                    S.filter,
                                    style: AppText.l1!.cl(Colors.white),
                                  ),
                                ],
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                if (files.isNotEmpty) {
                                  widget.list.imagelist.add(files[index]);
                                  widget.list.imagepath.add(files[index].path);
                                } else {
                                  widget.list.imagelist.add(widget.file);
                                  widget.list.imagepath.add(widget.file.path);
                                }
                                Navigator.of(context).pushNamed(
                                  RouteConstants.multiDelete,
                                  arguments: widget.list,
                                );
                              },
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Icon(
                                    Icons.arrow_forward,
                                    color: Colors.white,
                                    size: AppDimensions.font(10),
                                  ),
                                  Text(
                                    S.next,
                                    style: AppText.l1!.cl(Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}
