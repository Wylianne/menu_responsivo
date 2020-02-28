import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_responsive_menu/src/globals.dart';
import 'package:flutter_responsive_menu/src/menuLateral.dart';
import 'package:badges/badges.dart';

class ResponsiveMenu extends StatefulWidget {
  final List menuItens;
  final List barMenuItens;
  final List<Color> menuColors;
  final Color iconColor;
  final Color textColor;
  final double webMenuWidthActive;
  final double webMenuWidthDisabled;
  final double mobileMenuWidth;
  Widget rota;

  ResponsiveMenu(
      this.menuItens,
      this.barMenuItens,
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

    route = ResponsiveMenu(widget.menuItens, widget.barMenuItens, widget.menuColors, widget.rota);
  }


  @override
  Widget build(BuildContext context) {
    getSize();

    marginConteudo = MediaQuery.of(context).size.width * 0.01;

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
              child: MaterialApp(
                debugShowCheckedModeBanner: false,
                home: Scaffold(
                  resizeToAvoidBottomInset: false,
                  appBar: AppBar(
                    leading: IconButton(
                        icon: Icon(Icons.menu),
                        onPressed: () {
                          setState(() {
                            menuAtivo = !menuAtivo;
                          });
                        }
                    ),
                    actions: getBarMenuItens(widget.barMenuItens),
                    title: Text(widget.menuItens[idTela]["titulo"]),
                    backgroundColor: corAppBarConteudo,
                  ),
                  //backgroundColor: Colors.grey,
                  body: Container(
                    margin: EdgeInsets.only(
                      right: marginConteudo,
                      left: marginConteudo,
                      top: marginConteudo,
                    ),
                    child: getPage(),
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

  getBarMenuItens(itens){
    List<Widget> conteudo = [];

    for(int i = 0; i < itens.length; i++){
      conteudo.add(
          GestureDetector(
            onTap: (){
              setState(() {
                right = 0;
                idTela = itens[i].itemMenu;
                menuAtivo = false;
                idSubMenu = itens[i].itemSubmenu;

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => route),
                );
              });
            },
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(right: 15),
              child: Badge(
                badgeContent: Text(
                  itens[i].textBadge,
                  style: TextStyle(
                      color: Colors.white
                  ),
                ),
                toAnimate: true,
                child: Icon(itens[i].icone),
              ),
            ),
          )
      );
    }

    return conteudo;
  }

}



class ItemBarMenu{
  IconData icone;
  Color corBadge;
  String textBadge;
  int itemMenu;
  int itemSubmenu;

  ItemBarMenu({@required this.icone, @required this.corBadge, @required this.textBadge, @required this.itemMenu, @required this.itemSubmenu});
}

class Submenu{
  int id;
  IconData icone;
  String titulo;
  Widget widget;

  Submenu({@required this.id, @required this.icone, @required this.titulo, @required this.widget});
}

class ItemMenu{
  IconData icone;
  bool visivel;
  String titulo;
  Widget widget;
  int submenuAtivo;
  List<Submenu> submenu;

  ItemMenu({@required this.icone, @required this.visivel, @required this.titulo, @required this.widget, @required this.submenuAtivo, @required this.submenu});
}

