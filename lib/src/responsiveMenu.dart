import 'package:flutter/material.dart';
import 'package:flutter_responsive_menu/src/globals.dart';
import 'package:flutter_responsive_menu/src/menuLateral.dart';

class ResponsiveMenu extends StatefulWidget {
  final List menuItens;
  final List<Color> menuColors;
  final Color iconColor;
  final Color textColor;
  final double webMenuWidthActive;
  final double webMenuWidthDisabled;
  final double mobileMenuWidth;
  Widget rota;

  ResponsiveMenu(
      this.menuItens,
      this.menuColors,
      this.rota,
      {
          this.iconColor = Colors.white,
          this.textColor = Colors.white,
          this.webMenuWidthActive = 300,
          this.webMenuWidthDisabled = 65,
          this.mobileMenuWidth = 210
      }
  );

  @override
  _ResponsiveMenuState createState() => _ResponsiveMenuState();
}

class _ResponsiveMenuState extends State<ResponsiveMenu> with SingleTickerProviderStateMixin {

  @override
  initState() {
    super.initState();

    corAppBarConteudo = widget.menuColors[0];
    corAppBarMenu = widget.menuColors[1];
    corMenuConteudo = widget.menuColors[2];

    route = ResponsiveMenu(widget.menuItens, widget.menuColors, widget.rota);
  }


  @override
  Widget build(BuildContext context) {
    getSize();

    return GestureDetector(
      onHorizontalDragEnd: (drag){
        setState(() {
          if(drag.primaryVelocity > 0){
            menuAtivo = true;
          }else{
            menuAtivo = false;
          }
        });
      },
      child: Container(
        child: Stack(
          children: <Widget>[
            AnimatedPositioned(
              right: right,
              bottom: 0,
              width: sizeWidthConteudo,
              height: MediaQuery.of(context).size.height,
              duration: Duration( milliseconds: duracaoMilliseconds),
              child: Container(
                color: Colors.red,
                padding: EdgeInsets.all(0),
                child: MaterialApp(
                  debugShowCheckedModeBanner: false,
                  home: Scaffold(
                    extendBody: true,
                    appBar: AppBar(
                      leading: IconButton(
                          icon: Icon(Icons.menu),
                          onPressed: () {
                            setState(() {
                              menuAtivo = !menuAtivo;
                            });
                          }
                      ),
                      title: Text(widget.menuItens[idTela]["titulo"]),
                      backgroundColor: corAppBarConteudo,
                    ),
                    //backgroundColor: Colors.grey,
                    body: SingleChildScrollView(
                      child: Container(
                        margin: EdgeInsets.only(
                            right: MediaQuery.of(context).size.width * 0.01,
                            left: MediaQuery.of(context).size.width * 0.01,
                            bottom: MediaQuery.of(context).size.width * 0.01,
                            top: MediaQuery.of(context).size.width * 0.01
                        ),
                        child: getPage(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            AnimatedPositioned(
              right: rightMenu + right,
              width: sizeWidthMenu,
              height: MediaQuery.of(context).size.height,
              duration: Duration( milliseconds: duracaoMilliseconds),
              child: Container(
                  width: sizeWidthMenu,
                  height: 100,
                  child: MenuLateral(widget.menuItens, widget.menuColors)
              ),
            ),
          ],
        ),
      ),
    );
  }


  getSize(){
    if(MediaQuery.of(context).size.width > 770){

      if(menuAtivo){
        sizeWidthMenu = widget.webMenuWidthActive;
      }else{
        sizeWidthMenu = widget.webMenuWidthDisabled;
      }


      //rightMenu = sizeWidthMenu - MediaQuery.of(context).size.width;
      rightMenu = MediaQuery.of(context).size.width - sizeWidthMenu;
      sizeWidthConteudo = MediaQuery.of(context).size.width - sizeWidthMenu;
    }else{
      if(menuAtivo){
        right = -(sizeWidthMenu);
      }else{
        right = 0;
      }
      rightMenu = MediaQuery.of(context).size.width;
      sizeWidthMenu = MediaQuery.of(context).size.width  * 0.6;
      sizeWidthConteudo = MediaQuery.of(context).size.width;
    }
  }

  getPage(){

    if(idSubMenu != null){
      return widget.menuItens[idTela]["submenu"][idSubMenu]["widget"];

    }else{
      return widget.menuItens[idTela]["widget"];
    }

  }
}
