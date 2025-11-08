import 'package:loja_pecas_app/database_helper.dart';
import 'package:loja_pecas_app/models/produto.dart';
import 'package:sqflite/sqflite.dart';

class ProdutoRepository {
  // Pega a instância singleton do DatabaseHelper
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  /// Insere um novo produto no banco de dados.
  Future<void> salvarProduto(Produto produto) async {
    // Obtém a referência do banco de dados
    final db = await _dbHelper.database;

    // Insere o Map do Produto na tabela correta
    await db.insert(
      DatabaseHelper.tableProduto,
      produto.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Lista todos os produtos do banco de dados.
  Future<List<Produto>> listarTodosProdutos() async {
    // Obtém a referência do banco de dados
    final db = await _dbHelper.database;

    // Consulta a tabela de produtos
    final List<Map<String, dynamic>> maps = await db.query(DatabaseHelper.tableProduto);

    // Converte o List<Map> em um List<Produto>
    return List.generate(maps.length, (i) {
      return Produto.fromMap(maps[i]);
    });
  }

  /// Atualiza um produto existente no banco de dados.
  Future<void> atualizarProduto(Produto produto) async {
    final db = await _dbHelper.database;
    await db.update(
      DatabaseHelper.tableProduto,
      produto.toMap(),
      where: '${DatabaseHelper.colProdId} = ?', // Filtra pelo ID
      whereArgs: [produto.id],
    );
  }

  /// Exclui um produto do banco de dados pelo seu ID.
  Future<void> excluirProduto(int id) async {
    final db = await _dbHelper.database;
    await db.delete(
      DatabaseHelper.tableProduto,
      where: '${DatabaseHelper.colProdId} = ?', // Filtra pelo ID
      whereArgs: [id],
    );
  }
}