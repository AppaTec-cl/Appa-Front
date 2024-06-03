import 'package:flutter/material.dart';

class ContractWorkerPage extends StatefulWidget {
  const ContractWorkerPage({super.key});

  @override
  _ContractWorkerPageState createState() => _ContractWorkerPageState();
}

class _ContractWorkerPageState extends State<ContractWorkerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Anexos de Contrato'),
      ),
      body: Row(
        children: <Widget>[
          // Expanded left sidebar with contract names as buttons
          Expanded(
            flex: 3, // Larger left sidebar
            child: Container(
              child: ListView(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10), // Increase vertical padding
                    child: TextButton(
                      onPressed: () {}, // Add functionality here
                      child: const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Anexo de Contrato - Ajustes salariales 2024',
                            style: TextStyle(),
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10), // Increase vertical padding
                    child: TextButton(
                      onPressed: () {}, // Add functionality here
                      child: const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Anexo de Contrato - Extensión de servicios 2023',
                          style: TextStyle(),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10), // Increase vertical padding
                    child: TextButton(
                      onPressed: () {}, // Add functionality here
                      child: const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Anexo de Contrato - Cambio de horarios 2022',
                          style: TextStyle(),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10), // Increase vertical padding
                    child: TextButton(
                      onPressed: () {}, // Add functionality here
                      child: const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Anexo de Contrato - Expansión de infraestructura 2021',
                          style: TextStyle(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Vertical divider
          const VerticalDivider(color: Colors.grey, width: 1),
          // Contract image section
          Expanded(
            flex: 8,
            child: Image.asset(
              'assets/img/contract_image.png',
              fit: BoxFit.contain,
            ),
          ),
          // Vertical divider
          const VerticalDivider(color: Colors.grey, width: 1),
          // Much smaller right sidebar with buttons
          Expanded(
            flex: 1, // Smaller right sidebar
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Center vertically
              children: <Widget>[
                Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle, // Circular shape
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.download, size: 30),
                    onPressed: () {},
                  ),
                ),
                const SizedBox(height: 20), // Space between buttons
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle, // Circular shape
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.settings, size: 30),
                    onPressed: () {},
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
