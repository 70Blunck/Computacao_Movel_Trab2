import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loja_pecas_app/models/produto.dart';
import 'package:loja_pecas_app/repositories/produto_repository.dart';
import 'package:loja_pecas_app/screens/lista_produtos_screens.dart';

// 1. CRIE UMA CLASSE "FAKE" (MOCK) DO SEU REPOSITÓRIO
// Esta classe finge ser o seu repositório, mas nos dá controle total
class FakeProdutoRepository implements ProdutoRepository {
  // Vamos controlar o que ela retorna:
  // Se 'retornarVazio' for true, ela retorna []
  // Se 'retornarVazio' for false, ela retorna uma lista com um item
  bool retornarVazio = true;

  // Nós não precisamos implementar os métodos de verdade
  @override
  Future<List<Produto>> listarTodosProdutos() {
    if (retornarVazio) {
      // Retorna uma lista vazia IMEDIATAMENTE
      return Future.value([]); 
    } else {
      // Retorna uma lista com um produto falso IMEDIATAMENTE
      return Future.value([
        Produto(id: 1, categoriaId: 1, nome: 'Produto Mockado', fabricante: 'Mock', preco: 100, estoque: 10)
      ]);
    }
  }

  // Não precisamos dos outros métodos para este teste
  @override
  Future<void> atualizarProduto(Produto produto) async {}

  @override
  Future<void> excluirProduto(int id) async {}

  @override
  Future<void> salvarProduto(Produto produto) async {}
}


void main() {
  testWidgets('Teste 1: Tela de Listagem deve exibir mensagem quando vazia', (WidgetTester tester) async {
    // ARRANGE (Organizar)
    // 2. CRIE A VERSÃO FALSA DO REPOSITÓRIO
    final fakeRepo = FakeProdutoRepository();
    fakeRepo.retornarVazio = true; // Dizemos a ele para retornar uma lista vazia
    
    // 3. INJETE O REPOSITÓRIO FALSO NA TELA
    // (Precisamos modificar a tela para aceitar isso)
    
    // *** PARE! Precisamos alterar a tela primeiro. ***
    // Vamos voltar um passo.
  });
}