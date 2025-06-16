import 'dart:io';

import 'package:doclense/configs/app_dimensions.dart';
import 'package:doclense/configs/app_typography.dart';
import 'package:doclense/configs/space.dart';
import 'package:doclense/configs/ui.dart';
import 'package:doclense/constants/appstrings.dart';
import 'package:doclense/constants/route_constants.dart';
import 'package:doclense/ui_components/grid_item.dart';
import 'package:doclense/models/item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';

import '../providers/image_list.dart';

class MultiDelete extends StatefulWidget {
  final ImageList imageList;

  const MultiDelete(this.imageList);

  @override
  _MultiDeleteState createState() => _MultiDeleteState();
}

class _MultiDeleteState extends State<MultiDelete> {
  bool _isLoading = true;
  List<File> files = [];
  String? imageName;
  File? file;
  XFile? imageFile;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    files = [...widget.imageList.imagelist];
    print('IMAGELIST : ${widget.imageList.imagelist}');
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;
        if (await _onBackPress()) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Center(child: Text(S.multiDelete, style: AppText.h4b)),
          actions: [
            IconButton(
              icon: Icon(Icons.refresh, size: AppDimensions.font(13)),
              onPressed: () {
                setState(() {});
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            _chooseDialog();
          },
          label: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              IconButton(
                iconSize: 30,
                icon: const Icon(Icons.camera_alt),
                onPressed: () async {
                  getImage(ImageSource.camera);
                },
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              SizedBox(width: MediaQuery.of(context).size.width * 0.01),
              IconButton(
                iconSize: 30,
                icon: const Icon(Icons.image),
                onPressed: () {
                  getImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        ),
        body:
            _isLoading
                ? const SpinKitRotatingCircle(color: Colors.blue)
                : SafeArea(
                  child: Column(
                    children: <Widget>[
                      files.isEmpty
                          ? Expanded(
                            flex: 10,
                            child: Center(
                              child: Text(S.noImage, style: AppText.h3b),
                            ),
                          )
                          : Expanded(
                            flex: 10,
                            child: GridView.builder(
                              itemCount: files.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 4.0,
                                    mainAxisSpacing: 4.0,
                                  ),
                              itemBuilder: (context, index) {
                                return GridItem(
                                  item: Item(files[index], index),
                                  isSelected:
                                      (bool value) =>
                                          _onSelectionChange(value, index),
                                );
                              },
                            ),
                          ),
                      Expanded(
                        child: Container(
                          padding:
                              Responsive.isMobile(context) ? Space.h : Space.h1,
                          color: Colors.blue,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
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
                              TextButton(
                                onPressed: () {
                                  _confirmDelete(context);
                                },
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                      size: AppDimensions.font(10),
                                    ),
                                    Text(
                                      S.remove,
                                      style: AppText.l1!.cl(Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pushNamed(
                                    RouteConstants.pdfConversionScreen,
                                    arguments: widget.imageList,
                                  );
                                },
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Icon(
                                      Icons.picture_as_pdf,
                                      color: Colors.white,
                                      size: AppDimensions.font(10),
                                    ),
                                    Text(
                                      S.save,
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
      ),
    );
  }

  void _onSelectionChange(bool isSelected, int index) {
    setState(() {
      if (index < 0 || index >= files.length) {
        return;
      }
      print('INDEX : $index');
      print('LENGTH : ${files.length}');
      if (isSelected) {
        widget.imageList.imagelist.removeAt(index);
        files.removeAt(index);
      }
    });
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            backgroundColor: Colors.blueGrey[800],
            title: Text(
              S.confirmRemove,
              textAlign: TextAlign.center,
              style: AppText.b1!.cl(Colors.white),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        files.clear();
                        widget.imageList.imagelist.clear();
                        widget.imageList.imagepath.clear();
                      });
                      Navigator.of(ctx).pop();
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
          ),
    );
  }

  Future<void> getImage(ImageSource imageSource) async {
    try {
      imageFile = await picker.pickImage(source: imageSource);
      if (imageFile == null) return;
      file = File(imageFile!.path);

      if (imageSource == ImageSource.camera) {
        ImageGallerySaver.saveFile(
          imageFile!.path,
        ).then((value) => print("Image Saved"));
      }

      setState(() {
        files.add(file!);
        widget.imageList.imagelist.add(file!);
        widget.imageList.imagepath.add(file!.path);
      });
    } catch (e) {
      print(e);
    }
  }

  Future<bool> _onBackPress() async {
    if (files.isEmpty ||
        (files.length == widget.imageList.imagelist.length &&
            files.every(
              (element) =>
                  widget.imageList.imagelist.any((e) => e.path == element.path),
            ))) {
      return true;
    }
    return await showDialog(
          context: context,
          builder:
              (ctx) => AlertDialog(
                backgroundColor: Colors.blueGrey[800],
                title: Text(
                  S.exitConfirmText,
                  textAlign: TextAlign.center,
                  style: AppText.b1!.cl(Colors.white),
                ),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            widget.imageList.imagelist = files;
                            widget.imageList.imagepath =
                                files.map((e) => e.path).toList();
                          });
                          Navigator.of(ctx).pop(true);
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
                          Navigator.of(ctx).pop(false);
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
              ),
        )
        as bool;
  }

  void _chooseDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text("Opções de Imagem"),
          children: [
            SimpleDialogOption(
              onPressed: () {
                getImage(ImageSource.camera);
                Navigator.of(context).pop();
              },
              child: const Text("Câmera"),
            ),
            SimpleDialogOption(
              onPressed: () {
                getImage(ImageSource.gallery);
                Navigator.of(context).pop();
              },
              child: const Text("Galeria"),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancelar"),
            ),
          ],
        );
      },
    );
  }
}
