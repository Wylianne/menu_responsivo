import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_responsive_menu/src/globals.dart';
import 'package:flutter_responsive_menu/src/menuLateral.dart';
import 'package:badges/badges.dart';
import 'package:url_launcher/url_launcher.dart';

import 'globals.dart';


enum TypeOpen {Navigator, Push, PushReplacement}

class ResponsiveMenu extends StatefulWidget {
  final List menuItens;
  final List<ItemBarMenu> barMenuItens;
  final List<Color> menuColors;
  final Color iconColor;
  final Color textColor;
  final double webMenuWidthActive;
  final double webMenuWidthDisabled;
  final double mobileMenuWidth;
  final List<Locale> supportedLocales;
  Widget rotaInicial;
  Widget logout;
  String logo;
  String nomeAplicativo;
  IconData iconeLogout;

  ResponsiveMenu({
      @required this.menuItens,
      @required this.barMenuItens,
      @required this.menuColors,
      @required this.rotaInicial,
      @required this.logout,
      @required this.logo,
      @required this.nomeAplicativo,
      @required this.supportedLocales,
          this.iconeLogout = Icons.arrow_back,
          this.iconColor = Colors.white,
          this.textColor = Colors.white,
          this.webMenuWidthActive = 300,
          this.webMenuWidthDisabled = 65,
          this.mobileMenuWidth = 210,

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

    if(widget.rotaInicial != null){
        lastRoute = widget.rotaInicial;
    }


    route = ResponsiveMenu(
        menuItens: widget.menuItens,
        barMenuItens: widget.barMenuItens,
        menuColors: widget.menuColors,
        rotaInicial: lastRoute,
        logout: widget.logout,
        logo: widget.logo,
        nomeAplicativo: widget.nomeAplicativo,
        iconeLogout: widget.iconeLogout,
        iconColor: widget.iconColor,
        textColor: widget.textColor,
        webMenuWidthActive: widget.webMenuWidthActive,
        webMenuWidthDisabled: widget.webMenuWidthDisabled,
        mobileMenuWidth: widget.mobileMenuWidth,
    );
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
                localizationsDelegates: [
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: [
                  const Locale('pt'),
                ],
                home: Scaffold(
                  resizeToAvoidBottomInset: false,
                  appBar: AppBar(
                    leading: IconButton(
                        icon: Icon(Icons.menu),
                        onPressed: () {
                          setState(() {

                            menuAtivo = !menuAtivo;
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => route),
                            );
                          });
                        }
                    ),
                    actions: getBarMenuItens(widget.barMenuItens),
                    title: Text(widget.menuItens[idTela]["titulo"]),
                    backgroundColor: corAppBarConteudo,
                  ),
                  //backgroundColor: Colors.grey,
                  body: Container(
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
                  child: MenuLateral(widget.menuItens, widget.menuColors, widget.logout, widget.iconeLogout, widget.nomeAplicativo, widget.logo)
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

    if(widget.rotaInicial == null){

      if(idSubMenu != null && idTela > -1){
        return widget.menuItens[idTela]["submenu"][idSubMenu]["widget"];
      }else{
        return widget.menuItens[idTela]["widget"];
      }
    }else{
      return widget.rotaInicial;
    }


  }

  getBarMenuItens(itens){
    List<Widget> conteudo = [];

    for(int i = 0; i < itens.length; i++){
      conteudo.add(
          GestureDetector(
            onTap: () async {
                if(itens[i].typeAction == TypeOpen.Navigator){
                  if(itens[i].url != null){
                    await launch(itens[i].url);
                  }else{
                    print("Url is required in TypeOpen.Navigator");
                  }
                }else
                  if(itens[i].typeAction == TypeOpen.Push){
                    setState(() {
                      right = 0;
                      idTela = itens[i].itemMenu;
                      menuAtivo = false;
                      idSubMenu = itens[i].itemSubmenu;

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => route),
                      );
                    });

                  }else
                    if(itens[i].typeAction == TypeOpen.PushReplacement){
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
                    }

            },
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(right: 15),
              child: itens[i].isBandge
                ?
                  Badge(
                    badgeContent: Text(
                      itens[i].textBadge,
                      style: TextStyle(
                          color: Colors.white
                      ),
                    ),
                    toAnimate: true,
                    child: itens[i].icone,
                  )
                :
              itens[i].icone,
            ),
          )
      );
    }

    return conteudo;
  }

}



class ItemBarMenu{
  Widget icone;
  Color corBadge;
  String textBadge;
  TypeOpen typeAction;
  int itemMenu;
  int itemSubmenu;
  bool isBandge;
  String url;

  ItemBarMenu(
      {
        @required this.icone,
        @required this.corBadge,
        @required this.typeAction,
        @required this.textBadge,
        @required this.itemMenu,
        @required this.itemSubmenu,
        this.isBandge = false,
        this.url
      }
  );
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


getSizeWidthConteudo(){
  return sizeWidthConteudo;
}
