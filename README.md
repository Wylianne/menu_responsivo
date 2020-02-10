# Flutter Responsive Menu

Generate a responsive menu.

## Getting Started

git clone https://github.com/Wylianne/menu_responsivo.git

## Example

```dart
class MenuPrincipal extends StatefulWidget {
  @override
  _MenuPrincipalState createState() => _MenuPrincipalState();
}

class _MenuPrincipalState extends State<MenuPrincipal> {
  @override
  initState() {
    super.initState();
    getColors();
  }

  @override
  Widget build(BuildContext context) {
    // Set portrait orientation
    SystemChrome.setPreferredOrientations ([
      DeviceOrientation.portraitUp
    ]);

    SystemChrome.setEnabledSystemUIOverlays([]);

    return ResponsiveMenu(
      itensMenu,
      [
        Color(0xFF3c8dbc),
        Color(0xFF367fa9),
        Color(0xFF222d32),
      ],
      Indicadores()
    );
  }

}

List<dynamic> itensMenu = [
  {
    "icone": Icons.home,
    "widget": Indicadores(),
    "titulo": "Home"
  },
  {
    "icone": Icons.add,
    "widget": Indicadores(),
    "titulo": "Incluir Orçamento",
    "submenuAtivo": false,
    "submenu": [
      {
        "id": 0,
        "icone": MdiIcons.circleMedium,
        "widget": Teste(),
        "titulo": "Sub 1",
      },
      {
        "id": 1,
        "icone": MdiIcons.circleMedium,
        "widget": Indicadores(),
        "titulo": "Sub 2",
      },
    ]
  },
  {
    "icone": Icons.show_chart,
    "widget": Indicadores(),
    "titulo": "Indicadores",
    "subtitulo": "teste",
  },
  {
    "icone": Icons.search,
    "widget": Indicadores(),
    "titulo": "Consulta Produto",
    "submenuAtivo": false,
    "submenu": [
      {
        "id": 0,
        "icone": MdiIcons.circleMedium,
        "widget": Teste(),
        "titulo": "Sub 1",
      },
      {
        "id": 1,
        "icone": MdiIcons.circleMedium,
        "widget": Indicadores(),
        "titulo": "Sub 2",
      },
    ]
  },
  {
    "icone": Icons.lock_outline,
    "widget": Indicadores(),
    "titulo": "Termos de uso"
  },
  {
    "icone": Icons.info_outline,
    "widget": Indicadores(),
    "titulo": "Sobre o Aplicativo"
  },
];
```
