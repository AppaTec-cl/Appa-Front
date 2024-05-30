import 'package:flutter/material.dart';
import 'package:appatec_prototipo/presentation/screen/generar_contrato.dart';
import 'package:appatec_prototipo/presentation/screen/revisar_contrato.dart';
import 'package:appatec_prototipo/presentation/screen/firmar_gerente.dart';
import 'package:appatec_prototipo/presentation/screen/historial_trabajador.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final TextEditingController loginController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: 2,
            child: Center(
              child: SizedBox(
                width: 250,
                height: 250,
                child: Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/img/logo.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '¡Bienvenido!',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Inicia Sesión',
                    style: TextStyle(fontSize: 24, color: Colors.grey),
                  ),
                  const SizedBox(height: 32),
                  TextField(
                    controller: loginController,
                    decoration: const InputDecoration(
                      labelText: 'Ingresa tu RUT (Sin puntos y con guión)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Ingresa tu Contraseña',
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {},
                    child: const Text('Recuperar Contraseña'),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () {
                      String loginId = loginController.text;
                      String password = passwordController.text;
                      if (loginId == '1111' && password.isNotEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const GenerateContractScreen(),
                          ),
                        );
                      } else if (loginId == '2222' && password.isNotEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ContractReviewPage(),
                          ),
                        );
                      } else if (loginId == '3333' && password.isNotEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const GerentPage(),
                          ),
                        );
                      } else if (loginId.isNotEmpty && password.isEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ContractWorkerPage(),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Usuario o contraseña incorrectos'),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text('Iniciar Sesión'),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('¿No tienes una cuenta?'),
                      TextButton(
                        onPressed: () {},
                        child: const Text('Contactar al Administrador'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}