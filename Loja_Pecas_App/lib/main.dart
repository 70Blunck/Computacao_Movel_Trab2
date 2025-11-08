import 'package:flutter/material.dart';
// 1. Importa a nova tela que você criou
import 'package:loja_pecas_app/screens/lista_produtos_screens.dart';

void main() {
  // Garante que o Flutter e o binding do SQFLite estejam inicializados
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Loja de Peças',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212),
      ),
      
      // 2. O 'home' agora aponta para a sua tela de listagem
      home: ListaProdutosScreen(),
    );
  }
}