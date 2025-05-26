import 'dart:io';

import 'package:doclense/configs/app_dimensions.dart';
import 'package:doclense/configs/app_typography.dart';
import 'package:doclense/configs/space.dart';
import 'package:doclense/configs/ui.dart';
import 'package:doclense/constants/appstrings.dart';
import 'package:doclense/constants/route_constants.dart';
import 'package:doclense/ui_components/grid_item.dart';
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
  List<Item>? itemList;
  List<Item>? selectedList;
  File? imageFile;
  final picker = ImagePicker();

  bool _isLoading = true;

  @override
  void initState() {
    loadList();
    super.initState();
    Future.delayed(
      const Duration(seconds: 1),
      () => setState(() {
        _isLoading = false;
      }),
    );
  }

  void loadList() {
    itemList = [];
    selectedList = [];
    for (int i = 0; i < (widget.imageList.length()); i++) {
      itemList?.add(Item(widget.imageList.imagelist.elementAt(i), i));
    }
  }

  Future<void> _showChoiceDialogDel(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.blueGrey[800],
          title: Text(
            S.deleteSelected,
            textAlign: TextAlign.center,
            style: AppText.b1!.cl(Colors.white),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    setState(() {
                      for (int i = 0; i < selectedList!.length; i++) {
                        final int idx = widget.imageList.imagelist.indexOf(
                          itemList![itemList!.indexOf(selectedList![i])]
                              .imageUrl,
                        );
                        widget.imageList.imagelist.removeAt(idx);
                        widget.imageList.imagepath.removeAt(idx);
                        itemList!.remove(selectedList![i]);
                      }
                      selectedList = [];
                    });
                    Navigator.pop(context);
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
                    Navigator.of(context).pop();
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
                    for (int i = 0; i < itemList!.length; i++) {
                      print('i = $i');
                      print(widget.imageList.imagelist.length);
                      final int idx = widget.imageList.imagelist.indexOf(
                        itemList![itemList!.indexOf(itemList![i])].imageUrl,
                      );
                      widget.imageList.imagelist.removeAt(idx);
                      widget.imageList.imagepath.removeAt(idx);
                      // itemList.remove(idx);
                      itemList!.removeAt(idx);
                    }

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

  Future<void> _openGallery() async {
    XFile? picture = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (picture != null) imageFile = File(picture.path);
    });
    if (imageFile != null) {
      Navigator.of(context).pushNamed(
        RouteConstants.imageView,
        arguments: {'imageFile': imageFile, 'imageList': widget.imageList},
      );
    }
  }

  Future<void> _openCamera() async {
    XFile? picture = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (picture != null) imageFile = File(picture.path);
    });
    if (imageFile != null) {
      ImageGallerySaver.saveFile(
        imageFile!.path,
      ).then((value) => print("Image Saved"));
      Navigator.of(context).pushNamed(
        RouteConstants.imageView,
        arguments: {'imageFile': imageFile, 'imageList': widget.imageList},
      );
    }
  }

  Future<void> _showChoiceDialogAdd(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.blueGrey[800],
          title: Text(
            S.addMorePages,
            textAlign: TextAlign.center,
            style: AppText.b1!.cl(Colors.white),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    _openGallery();
                  },
                  child: Text(S.gallery, style: AppText.b1!.cl(Colors.white)),
                ),
                Space.y!,
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    _openCamera();
                  },
                  child: Text(S.camera, style: AppText.b1!.cl(Colors.white)),
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
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (bool didPop, bool? result) {
        if (!didPop && itemList!.isNotEmpty) {
          setState(() {
            widget.imageList.imagelist.removeAt(itemList!.length - 1);
            widget.imageList.imagepath.removeAt(itemList!.length - 1);
            itemList!.removeAt(itemList!.length - 1);
          });
        }
      },
      child: Scaffold(
        // backgroundColor: Colors.blueGrey[100],
        appBar: getAppBar(),
        body:
            _isLoading
                ? const SpinKitRotatingCircle(color: Colors.blue)
                : GridView.builder(
                  itemCount: itemList!.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: UI.width! >= 640 ? 3 : 2,
                    crossAxisSpacing: 4,
                    mainAxisSpacing: 4,
                  ),
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 10,
                      child: GridItem(
                        item: itemList![index],
                        isSelected: (bool value) {
                          setState(() {
                            if (value) {
                              selectedList!.add(itemList![index]);
                            } else {
                              selectedList!.remove(itemList![index]);
                            }
                          });
                          print("$index : $value");
                        },
                        key: Key(itemList![index].rank.toString()),
                      ),
                    );
                  },
                ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: IconButton(
            iconSize: AppDimensions.font(18),
            onPressed: () {
              _showChoiceDialogAdd(context);
            },
            icon: const Icon(Icons.add),
          ),
        ),
      ),
    );
  }

  AppBar getAppBar() {
    return AppBar(
      leading: IconButton(
        onPressed: () {
          if (itemList!.isNotEmpty) {
            setState(() {
              widget.imageList.imagelist.removeAt(itemList!.length - 1);
              widget.imageList.imagepath.removeAt(itemList!.length - 1);
              itemList!.removeAt(itemList!.length - 1);
            });
          }
          Navigator.of(context).pop();
        },
        icon: const Icon(Icons.arrow_back),
      ),
      title: Text(
        selectedList!.isEmpty
            ? S.documents
            : "${selectedList!.length} item selected",
      ),
      actions: <Widget>[
        if (selectedList!.isEmpty)
          Container()
        else
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              _showChoiceDialogDel(context);
            },
          ),
        IconButton(
          icon: const Icon(Icons.picture_as_pdf),
          onPressed: () {
            Navigator.of(context).pushNamed(
              RouteConstants.pdfConversionScreen,
              arguments: widget.imageList,
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.home),
          onPressed: () {
            _showChoiceDialogHome(context);
          },
        ),
      ],
    );
  }
}

class Item {
  File imageUrl;
  int rank;

  Item(this.imageUrl, this.rank);
}
