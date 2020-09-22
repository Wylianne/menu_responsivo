import 'dart:async';

import 'package:flutter/material.dart';


//******************  MENU  ********************
double right = 0;
double rightMenu = 45;
double sizeWidthMenu = 0;
double sizeWidthConteudo = 0;
double marginConteudo = 0;
double posicaoDireitaMenu = 0;
double sizeWidthSubmenu = 0;

int duracaoMilliseconds = 200;
int idTela = 0;
int idSubMenu = null;
Widget telaAtual;

Widget route;
Widget lastRoute;

bool menuAtivo = false;


List<Key> keysMenu = [];


//final streamMenuController = StreamController.broadcast();

List childKeys = [];

//************************************************************
//Skins

Color iconColor = Colors.white;
Color textColor = Colors.orange;
Color corAppBarConteudo = Color(0xFF3c8dbc);
Color corAppBarMenu = Color(0xFF367fa9);
Color corMenuConteudo = Color(0xFF222d32);

