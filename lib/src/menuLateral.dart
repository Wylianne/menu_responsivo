import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'globals.dart';

class MenuLateral extends StatefulWidget {

  List menuItens;
  List<Color> menuColors;
  MenuLateral(this.menuItens, this.menuColors);

  @override
  _MenuLateralState createState() => _MenuLateralState();
}

class _MenuLateralState extends State<MenuLateral> {
  @override
  initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          alignment: Alignment.center,
          child:
          MediaQuery.of(context).size.width  > 770 && menuAtivo == false ?
            Image.asset(
                "assets/icon_logo.png",
                color: Colors.white,
                width: sizeWidthMenu
            )
                :
            Text(
              "ORC Carajás",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
        ),
        backgroundColor: widget.menuColors[1],
      ),
      backgroundColor: widget.menuColors[2],
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Column(
              children: montaItensMenu(),
            )
          ],
        ),
      ),
    );
  }

  fechaSubmenus(){
    for(int i = 0; i < widget.menuItens.length; i++){
      if(widget.menuItens[i]['submenuAtivo'] == true){
        widget.menuItens[i]['submenuAtivo'] = false;
      }
    }
  }

  List<Widget> montaItensMenu(){
    List<Widget> conteudo = [];

    List itensMenu = widget.menuItens;


    for(int i = 0; i < itensMenu.length; i++){
      if(itensMenu[i]["visivel"]){
        conteudo.add(
            _addItem(
                i,
                itensMenu[i]["icone"],
                itensMenu[i]["titulo"],
                Colors.white,
                Colors.white,
                txtSubtitle: itensMenu[i]["subtitulo"],
                submenu: itensMenu[i]["submenu"] != null ? itensMenu[i]["submenu"].toList() : []
            )
        );
      }

    }

    return conteudo;
  }

  _addItem(i, myIcon, txt, Color corIcone, Color corTxt, {txtSubtitle, submenu}) {


        if (childKeys.length <= i){
          childKeys.insert(i, GlobalKey());
        }else{
          childKeys[i] = GlobalKey();
        }


        if(menuAtivo){
          if(txtSubtitle == null){
            if(submenu.length > 0){
              return ExpansionTile(
                initiallyExpanded: widget.menuItens[i]["submenuAtivo"],
                leading: Icon(
                  myIcon,
                  color: corIcone,
                ),
                title: Text(
                  txt,
                  style: TextStyle(
                      color: corTxt,
                      fontWeight: FontWeight.bold
                  ),
                ),
                trailing: Icon(
                  Icons.keyboard_arrow_down,
                  color: corIcone,
                ),
                children: submenu
                    .map<ListTile>(
                        (item) => ListTile(
                      contentPadding: EdgeInsets.only(
                          left: sizeWidthMenu * 0.2
                      ),
                      title: Row(
                        children: <Widget>[
                          Icon(
                            item["icone"],
                            color: corIcone,
                          ),
                          Text(
                            " " + item["titulo"],
                            style: TextStyle(
                                color: corTxt,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ],
                      ),
                      onTap: (){
                        setState(() {
                          right = 0;
                          idTela = i;
                          menuAtivo = false;
                          idSubMenu = item["id"];

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => route),
                          );
                        });
                      },
                    )
                ).toList(),
              );
            }else{
              return ListTile(
                leading: Icon(
                  myIcon,
                  color: corIcone,
                ),
                title: Text(
                  txt,
                  style: TextStyle(
                      color: corTxt,
                      fontWeight: FontWeight.bold
                  ),
                ),
                onTap: (){
                  setState(() {
                    right = 0;
                    idTela = i;
                    idSubMenu = null;
                    menuAtivo = false;

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => route),
                    );
                  });
                },
              );
            }

          }else{
            return ListTile(
              leading: Icon(
                myIcon,
                color: corIcone,
              ),
              title: Text(
                txt,
                style: TextStyle(
                    color: corTxt,
                    fontWeight: FontWeight.bold
                ),
              ),
              subtitle: Text(
                txtSubtitle,
                style: TextStyle(
                    color: corTxt
                ),
              ),
              onTap: (){
                setState(() {
                  right = 0;
                  idTela = i;
                  idSubMenu = null;

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => route),
                  );
                });

              },
            );
          }
        }else{
            if(submenu.length > 0){
              return Tooltip(
                message: txt,
                child: Container(
                  width: 65,
                  height: 60,
                  color: idTela == i ? Colors.blue[900]: corMenuConteudo,
                  //color: corAppBarMenu,
                  alignment: Alignment.centerRight,
                  child: Container(
                    width: 60,
                    height: 60,
                    color: corMenuConteudo,
                    child: ListTile(
                        leading: Icon(
                          myIcon,
                          color: corIcone,
                        ),
                        onTap: (){
                          setState(() {
                            menuAtivo = !menuAtivo;

                            fechaSubmenus();

                            widget.menuItens[i]["submenuAtivo"] = true;

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => route),
                            );
                          });
                        },
                    ),
                  ),
                ),
              );
            }else{
              return Tooltip(
                message: txt,
                child:
                    Container(
                      width: 65,
                      height: 60,
                      color: idTela == i ? Colors.blue[900]: corMenuConteudo,
                      //color: corAppBarMenu,
                      alignment: Alignment.centerRight,
                      child: Container(
                        width: 60,
                        height: 60,
                        color: corMenuConteudo,
                        child: ListTile(

                          leading: Icon(
                            myIcon,
                            color: corIcone,
                          ),
                          onTap: (){
                            setState(() {
                              right = 0;
                              idTela = i;
                              idSubMenu = null;
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => route),
                              );
                            });
                          },
                        ),
                      ),
                    ),
              );
            }
        }
  }
}

