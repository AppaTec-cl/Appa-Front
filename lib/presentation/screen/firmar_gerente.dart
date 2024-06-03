import 'package:flutter/material.dart';

class GerentPage extends StatefulWidget {
  const GerentPage({super.key});

  @override
  _GerentPageState createState() => _GerentPageState();
}

class _GerentPageState extends State<GerentPage>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Revisar Contrato - Gerente General'),
      ),
      body: Row(
        children: <Widget>[
          // Sidebar with tabs and a very light gray background
          Expanded(
            flex: 2,
            child: Column(
              children: [
                TabBar(
                  controller: _tabController,
                  tabs: const [
                    Tab(text: 'Pendientes'),
                    Tab(text: 'Revisados'),
                  ],
                ),
                Expanded(
                    child: TabBarView(
                  controller: _tabController,
                  children: [
                    ListView(
                      children: <Widget>[
                        ListTile(
                          title: Text('Contrato de Juan'),
                          onTap: () {},
                        ),
                        ListTile(
                          title: Text('Contrato de Nicolás'),
                          onTap: () {},
                        ),
                        ListTile(
                          title: Text('Contrato de Miguel'),
                          onTap: () {},
                        ),
                      ],
                    ),
                    ListView(
                      children: <Widget>[
                        ListTile(
                          title: Text('Contrato de Ana'),
                          onTap: () {},
                        ),
                        ListTile(
                          title: Text('Contrato de Pedro'),
                          onTap: () {},
                        ),
                        ListTile(
                          title: Text('Contrato de María'),
                          onTap: () {},
                        ),
                      ],
                    ),
                  ],
                ))
              ],
            ),
          ),
          // Contract details section
          Expanded(
            flex: 8,
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: Center(
                    child: SizedBox(
                      width: 1000,
                      height: 1250,
                      child: Container(
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/img/contract_image.png'),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // Input, download button, and action buttons with padding and a specific background color
                Container(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: IconButton(
                          icon: const Icon(Icons.download),
                          onPressed: () {},
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration(
                            labelText: 'Correcciones',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: ElevatedButton(
                          onPressed: () {},
                          child: const Text('Rechazar'),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          shape: CircleBorder(),
                        ),
                        child: Ink(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/img/clave_unica.jpg'),
                                fit: BoxFit.cover),
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                          child: Container(
                            width: 120,
                            height: 40,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
