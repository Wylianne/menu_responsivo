import 'package:flutter/material.dart';
import 'package:flutter_responsive_menu/src/globals.dart';


AnimationController animationController;
Animation<double> scaleAnimation;
OverlayEntry overlayEntry;

class OverlaySelector extends StatefulWidget {
  final int idKey;
  final OverlayItemData checkedItemData;
  final List<OverlayItemData> overlayItemDatas;
  final Function(OverlayItemData) onSelectChanged;
  final Color backgroundColor;
  final double topViewPadding;
  final TextStyle selectedTextStyle;
  final TextStyle unselectedTextStyle;
  final Icon selectedIcon;
  final Icon childIcon;
  final TextStyle childTextStyle;
  final EdgeInsets padding;
  final double separationValue;

  OverlaySelector({this.idKey, this.checkedItemData, this.overlayItemDatas, this.onSelectChanged, this.backgroundColor,
    this.topViewPadding = 0, this.selectedTextStyle, this.unselectedTextStyle, this.selectedIcon,
    this.childIcon, this.childTextStyle, this.padding = const EdgeInsets.fromLTRB(20, 20, 20, 20), this.separationValue = 20});

  @override
  _OverlaySelectorState createState() => _OverlaySelectorState();
}

class _OverlaySelectorState extends State<OverlaySelector> with SingleTickerProviderStateMixin{

  List<Widget> selectItems = List();
  //Color containerColor = Colors.transparent;

  @override
  void initState() {
    animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    scaleAnimation = Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: animationController,
          curve: Curves.easeIn,
        )
    );


    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    selectItems.clear();
    for (var data in widget.overlayItemDatas){
      selectItems.add(
          OverlaySelectorItem(
            data,
            widget.checkedItemData.index,
                (selectItemData){
              widget.onSelectChanged(selectItemData);
              animationController.reverse().then((_){
                overlayEntry.remove();
              });
            },
            selectedTextStyle: widget.selectedTextStyle,
            unselectedTextStyle: widget.unselectedTextStyle,
            selectedIcon: widget.selectedIcon,
            padding: widget.padding,
            separationValue: widget.separationValue,
          )
      );
    }
    selectItems.add(SizedBox(height: widget.separationValue));

    return GestureDetector(
      child: Container(
          child: AnimatedBuilder(
              animation: animationController,
              builder: (context2, child){
                return MouseRegion(
                  onHover: (teste){
                    Offset childOffset;

                    if (childKeys[widget.idKey] != null){
                      final RenderBox childRenderBox = childKeys[widget.idKey].currentContext.findRenderObject();

                      childOffset = childRenderBox.localToGlobal(Offset.zero);
                    }
                    animationController.forward();

                    overlayEntry = OverlayEntry(
                        builder: (context2) => Positioned(
                            height: MediaQuery.of(context2).size.height,
                            width: MediaQuery.of(context2).size.width,
                            child: Material(
                                color: Colors.transparent,
                                child: Stack(
                                  children: <Widget>[
                                    GestureDetector(
                                      child: Container(
                                        height: double.infinity,
                                        width: double.infinity,
                                        color: Colors.transparent,
                                      ),
                                      onTap: (){
                                        animationController.reverse().then((_){
                                          // setState(() {
                                          //   containerColor = Colors.transparent;
                                          // });
                                          overlayEntry.remove();
                                        });
                                      },
                                    ),
                                    Positioned(
                                      // - (widget.checkedItemData.index * 40)
                                        top: (childOffset.dy - (widget.checkedItemData.index * (((widget?.selectedIcon?.size ?? 20)) + (widget.separationValue)) + widget.separationValue)) < widget.topViewPadding
                                            ? widget.topViewPadding
                                            : childOffset.dy - (widget.checkedItemData.index * (((widget?.selectedIcon?.size ?? 20)) + (widget.separationValue)) + widget.separationValue),
                                        width: 150,
                                        left: 60,
                                        child: AnimatedBuilder(
                                          animation: animationController,
                                          builder: (context3, child){
                                            return FadeTransition(
                                                opacity: scaleAnimation,
                                                child: Container(
                                                    decoration: BoxDecoration(
                                                        color: Color(0xFF2C3B41),
                                                        borderRadius: BorderRadius.only(
                                                            bottomRight: Radius.circular(10),
                                                            topRight: Radius.circular(10)
                                                        )
                                                    ),
                                                    child: Column(
                                                        children: selectItems
                                                    )
                                                )
                                            );
                                          },
                                        )
                                    )
                                  ],
                                )
                            )
                        )
                    );


                    Overlay.of(context).insert(overlayEntry);
                  },
                  onExit: (teste){

                    Future.delayed(Duration(seconds: 3), () {
                      animationController.reverse().then((_){
                        // setState(() {
                        //   containerColor = Colors.transparent;
                        // });
                        overlayEntry.remove();
                      });
                    });

                    /*animationController.reverse().then((_){
                      // setState(() {
                      //   containerColor = Colors.transparent;
                      // });
                      overlayEntry.remove();
                    });*/
                  },

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    key: childKeys[widget.idKey],
                    children: <Widget>[
                      widget.childIcon,//Icon(Icons.tune, color: Colors.grey[400], size: 28),
                    ],
                  ),
                );
              }
          )
      ),
/*      onTap: (){
        Offset childOffset;

        if (childKey != null){
          final RenderBox childRenderBox = childKey.currentContext.findRenderObject();

          childOffset = childRenderBox.localToGlobal(Offset.zero);
        }
        animationController.forward();

        overlayEntry = OverlayEntry(
            builder: (context2) => Positioned(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Material(
                    color: Colors.transparent,
                    child: Stack(
                      children: <Widget>[
                        GestureDetector(
                          child: Container(
                            height: double.infinity,
                            width: double.infinity,
                            color: Colors.transparent,
                          ),
                          onTap: (){
                            animationController.reverse().then((_){
                              // setState(() {
                              //   containerColor = Colors.transparent;
                              // });
                              overlayEntry.remove();
                            });
                          },
                        ),
                        Positioned(
                          // - (widget.checkedItemData.index * 40)
                            top: (childOffset.dy - (widget.checkedItemData.index * (((widget?.selectedIcon?.size ?? 24)) + (widget.separationValue)) + widget.separationValue)) < widget.topViewPadding
                                ? widget.topViewPadding
                                : childOffset.dy - (widget.checkedItemData.index * (((widget?.selectedIcon?.size ?? 24)) + (widget.separationValue)) + widget.separationValue),
                            width: 150,
                            left: 60,
                            child: AnimatedBuilder(
                              animation: animationController,
                              builder: (context3, child){
                                return FadeTransition(
                                    opacity: scaleAnimation,
                                    child: Container(
                                        decoration: BoxDecoration(
                                            color: Color(0xFF2C3B41),
                                            borderRadius: BorderRadius.only(
                                                bottomRight: Radius.circular(10),
                                                topRight: Radius.circular(10)
                                            )
                                        ),
                                        child: Column(
                                            children: selectItems
                                        )
                                    )
                                );
                              },
                            )
                        )
                      ],
                    )
                )
            )
        );


        Overlay.of(context).insert(overlayEntry);
      },*/
    );
  }
}

class OverlaySelectorItem extends StatelessWidget {
  final OverlayItemData overlayItemData;
  final int checkedIndex;
  final Function(OverlayItemData) onSelectItem;
  final TextStyle selectedTextStyle;
  final TextStyle unselectedTextStyle;
  final Icon selectedIcon;
  final EdgeInsets padding;
  final double separationValue;

  OverlaySelectorItem(this.overlayItemData, this.checkedIndex, this.onSelectItem,
      {Key key, this.selectedTextStyle, this.unselectedTextStyle, this.selectedIcon, this.padding, this.separationValue}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        color: overlayItemData.index == 0 ? corMenuConteudo : null,
        child: ListTile(
          title: Text(
              overlayItemData.name,
              style: TextStyle(color: Colors.white, fontSize: 14)
          ),
        ),
      ),
      onTap: (){

        Future.delayed(Duration(seconds: 3), () {
          animationController.reverse().then((_){
            // setState(() {
            //   containerColor = Colors.transparent;
            // });
            overlayEntry.remove();
          });
        });


        if(overlayItemData.idTela > -1){

          idTela = overlayItemData.idTela;
          idSubMenu = overlayItemData.idSubmenu;

          /*Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
          overlayItemData.router), (Route<dynamic> route) => false);*/

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => overlayItemData.router),
          );



          /*Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => overlayItemData.router),
          );*/

          //Navigator.popUntil(context, MaterialPageRoute(builder: (context) => overlayItemData.router))
        }

      },
    );
  }
}

class OverlayItemData{
  String name;
  String id;
  int index;
  bool isAsc;
  int idTela;
  int idSubmenu;
  Widget router;

  OverlayItemData({this.name, this.id, this.index, this.isAsc, this.idTela, this.idSubmenu, this.router});
}