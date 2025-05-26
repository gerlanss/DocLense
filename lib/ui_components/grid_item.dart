import 'package:doclense/configs/app_dimensions.dart';
import 'package:doclense/configs/space.dart';
import 'package:flutter/material.dart';

import 'multi_select_delete.dart';

class GridItem extends StatefulWidget {
  const GridItem({Key? key, required this.item, required this.isSelected})
      : super(key: key);

  final ValueChanged<bool> isSelected;
  final Item item;

  @override
  _GridItemState createState() => _GridItemState();
}

class _GridItemState extends State<GridItem> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          isSelected = !isSelected;
          widget.isSelected(isSelected);
        });
      },
      child: Stack(
        children: <Widget>[
          Image.file(
            widget.item.imageUrl,
            color: Colors.black.withAlpha(isSelected ? 230 : 0),
            colorBlendMode: BlendMode.color,
            fit: BoxFit.fill, //Determines the size ratio of the gridimage
            width: AppDimensions.width(50),
            height: AppDimensions.width(50),
          ),
          if (isSelected)
            Container(
              alignment: Alignment.bottomRight,
              padding: Space.all(),
              child: Icon(
                Icons.check_circle,
                color: Colors.black,
                size: AppDimensions.font(
                  11,
                ),
              ),
            )
          else
            Container()
        ],
      ),
    );
  }
}
