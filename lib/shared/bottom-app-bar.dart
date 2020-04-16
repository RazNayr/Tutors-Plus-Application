import 'package:flutter/material.dart';

class FABBottomAppBarItem {
  FABBottomAppBarItem({this.iconData, this.text});
  IconData iconData;
  String text;
}

class FABBottomAppBar extends StatefulWidget {
  FABBottomAppBar({
    this.items,
    this.centerItemText,
    this.currentIndex,
    this.height: 60.0,
    this.iconSize: 24.0,
    this.notchMargin: 4.0,
    this.backgroundColor,
    this.shadowColor,
    this.blurRadius,
    this.color,
    this.selectedColor,
    this.notchedShape,
    this.onTabSelected,
  }) {
    assert(this.items.length == 2 || this.items.length == 4);
  }
  final List<FABBottomAppBarItem> items;
  final String centerItemText;
  final int currentIndex;
  final double height;
  final double iconSize;
  final double notchMargin;
  final double blurRadius;
  final Color backgroundColor;
  final Color shadowColor;
  final Color color;
  final Color selectedColor;
  final NotchedShape notchedShape;
  final ValueChanged<int> onTabSelected;
  
  @override
  State<StatefulWidget> createState() => FABBottomAppBarState();
}

class FABBottomAppBarState extends State<FABBottomAppBar> {

  _updateIndex(int index) {
    widget.onTabSelected(index);
  }

  @override
  Widget build(BuildContext context) {

    List<Widget> items = List.generate(widget.items.length, (int index) {
      return _buildTabItem(
        item: widget.items[index],
        index: index,
        onPressed: _updateIndex,
      );
    });
    
    items.insert(items.length >> 1, _buildMiddleTabItem());

    return Container(
      decoration: BoxDecoration(
        boxShadow: [BoxShadow(color: widget.shadowColor, blurRadius: widget.blurRadius)]
      ),
      child: BottomAppBar(
        shape: widget.notchedShape,
        notchMargin: widget.notchMargin,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: items,
        ),
        color: widget.backgroundColor,
      ),
    );
  }

  Widget _buildMiddleTabItem() {
    return Expanded(
      child: SizedBox(
        height: widget.height,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: widget.iconSize),
            Text(
              widget.centerItemText ?? '',
              style: TextStyle(color: widget.color),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabItem({FABBottomAppBarItem item, int index, ValueChanged<int> onPressed,}) {

    Color color = widget.currentIndex == index ? widget.selectedColor : widget.color;

    Widget _showText(){
      if (widget.currentIndex == index){
        return Text(
          item.text,
          style: TextStyle(color: color),
        );
      }else{
        return SizedBox(height: 0);
      }
    }
    
    return Expanded(
      child: SizedBox(
        height: widget.height,
        child: FlatButton(
          //splashColor: Colors.transparent,  
          //highlightColor: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(item.iconData, color: color, size: widget.iconSize),
              _showText(),
            ],
          ),
          onPressed: () => onPressed(index),
        ),
      ),
    );
  }
}