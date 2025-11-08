import 'package:loja_pecas_app/database_helper.dart';
import 'package:loja_pecas_app/models/categoria.dart';
import 'package:sqflite/sqflite.dart';

class CategoriaRepository {
  // Pega a instância singleton do DatabaseHelper
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

 /// Insere uma nova categoria e RETORNA seu novo ID.
  Future<int> salvarCategoria(Categoria categoria) async {
    // Obtém a referência do banco de dados
    final db = await _dbHelper.database;

    // db.insert retorna o ID do último item inserido
    final id = await db.insert(
      DatabaseHelper.tableCategoria,
      categoria.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    
    return id; // <-- A mudança principal é esta
  }

  /// Lista todas as categorias do banco de dados.
  Future<List<Categoria>> listarTodasCategorias() async {
    // Obtém a referência do banco de dados
    final db = await _dbHelper.database;

    // Consulta a tabela de categorias, sem filtros (lista tudo)
    // O resultado é um List<Map<String, dynamic>>
    final List<Map<String, dynamic>> maps = await db.query(DatabaseHelper.tableCategoria);

    // Converte o List<Map> em um List<Categoria>
    return List.generate(maps.length, (i) {
      return Categoria.fromMap(maps[i]);
    });
  }
}