import 'package:flutter/material.dart';
import 'package:loja_pecas_app/models/produto.dart';
import 'package:loja_pecas_app/repositories/produto_repository.dart';

// 1. Criamos um StatelessWidget, como pedido no trabalho [cite: 134]
class ListaProdutosScreen extends StatelessWidget {
  ListaProdutosScreen({super.key});

  // 2. Instanciamos o repositório para buscar os dados
  final ProdutoRepository produtoRepo = ProdutoRepository();

  @override
  Widget build(BuildContext context) {
    // 3. Usamos Scaffold e AppBar, como pedido [cite: 142]
    return Scaffold(
      appBar: AppBar(
        title: const Text('Produtos da Loja'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        // 4. FutureBuilder é a melhor forma de carregar dados assíncronos
        //    (como os do banco) em uma tela
        child: FutureBuilder<List<Produto>>(
          // 5. O 'future' é a nossa chamada de listagem do repositório
          future: produtoRepo.listarTodosProdutos(),
          builder: (context, snapshot) {
            // 6. Enquanto está carregando, mostramos um loading
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            
            // 7. Se der erro
            if (snapshot.hasError) {
              return Center(child: Text('Erro ao carregar produtos: ${snapshot.error}'));
            }
            
            // 8. Se os dados chegarem com sucesso (mas a lista pode estar vazia)
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('Nenhum produto cadastrado.'));
            }

            // 9. Se temos dados, pegamos a lista
            final produtos = snapshot.data!;

            // 10. Usamos o ListView para exibir a lista, como pedido [cite: 143]
            return ListView.builder(
              itemCount: produtos.length,
              itemBuilder: (context, index) {
                final produto = produtos[index];
                
                // ListTile é ótimo para listas simples
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  child: ListTile(
                    title: Text(produto.nome),
                    subtitle: Text('Fabricante: ${produto.fabricante} | Estoque: ${produto.estoque}'),
                    trailing: Text(
                      'R\$ ${produto.preco.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}