// Importa o helper para usarmos os nomes das colunas
import 'package:loja_pecas_app/database_helper.dart';

class Produto {
  int? id;
  int categoriaId; // Chave estrangeira
  String nome;
  String fabricante;
  double preco;
  int estoque;

  Produto({
    this.id,
    required this.categoriaId,
    required this.nome,
    required this.fabricante,
    required this.preco,
    required this.estoque,
  });

  // Método toMap: Converte o objeto Produto para um Map
  Map<String, dynamic> toMap() {
    return {
      DatabaseHelper.colProdId: id,
      DatabaseHelper.colProdCategoriaId: categoriaId,
      DatabaseHelper.colProdNome: nome,
      DatabaseHelper.colProdFabricante: fabricante,
      DatabaseHelper.colProdPreco: preco,
      DatabaseHelper.colProdEstoque: estoque,
    };
  }

  // Método fromMap: Converte um Map vindo do banco para um objeto Produto
  static Produto fromMap(Map<String, dynamic> map) {
    return Produto(
      id: map[DatabaseHelper.colProdId],
      categoriaId: map[DatabaseHelper.colProdCategoriaId],
      nome: map[DatabaseHelper.colProdNome],
      fabricante: map[DatabaseHelper.colProdFabricante],
      preco: map[DatabaseHelper.colProdPreco],
      estoque: map[DatabaseHelper.colProdEstoque],
    );
  }
}