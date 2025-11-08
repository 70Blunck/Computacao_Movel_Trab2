import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  // 1. Constantes do Banco de Dados
  static const String _dbName = 'loja_pecas.db';
  static const int _dbVersion = 1;

  // 2. Constantes das Tabelas
  // Tabela Categoria
  static const String tableCategoria = 'categorias';
  static const String colCatId = 'id';
  static const String colCatNome = 'nome';
  static const String colCatDescricao = 'descricao';
  static const String colCatDataCadastro = 'dataCadastro';
  static const String colCatAtiva = 'ativa';

  // Tabela Produto
  static const String tableProduto = 'produtos';
  static const String colProdId = 'id';
  static const String colProdCategoriaId = 'categoriaId'; // Chave Estrangeira
  static const String colProdNome = 'nome';
  static const String colProdFabricante = 'fabricante';
  static const String colProdPreco = 'preco';
  static const String colProdEstoque = 'estoque';

  // 3. Padrão Singleton
  // Construtor privado
  DatabaseHelper._privateConstructor();
  // Instância estática
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // 4. Referência do Banco de Dados
  // Somente uma instância do banco será mantida
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    
    // Se _database é null, inicializa o banco
    _database = await _initDatabase();
    return _database!;
  }

  // 5. Método de Inicialização do Banco
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _dbName);
    
    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate, // Método chamado na primeira criação
    );
  }

  // 6. Método _onCreate (Executa os CREATE TABLE)
  Future<void> _onCreate(Database db, int version) async {
    // Comando SQL para criar a tabela Categoria
    await db.execute('''
      CREATE TABLE $tableCategoria (
        $colCatId INTEGER PRIMARY KEY AUTOINCREMENT,
        $colCatNome TEXT NOT NULL,
        $colCatDescricao TEXT,
        $colCatDataCadastro TEXT NOT NULL,
        $colCatAtiva INTEGER NOT NULL 
      )
    ''');

    // Comando SQL para criar a tabela Produto
    await db.execute('''
      CREATE TABLE $tableProduto (
        $colProdId INTEGER PRIMARY KEY AUTOINCREMENT,
        $colProdNome TEXT NOT NULL,
        $colProdFabricante TEXT,
        $colProdPreco REAL NOT NULL,
        $colProdEstoque INTEGER NOT NULL,
        $colProdCategoriaId INTEGER NOT NULL,
        FOREIGN KEY ($colProdCategoriaId) REFERENCES $tableCategoria ($colCatId)
      )
    ''');
  }

  // 7. (Opcional, mas recomendado) Habilitar chaves estrangeiras
  // O SQFLite para Android não habilita por padrão.
  // Você pode adicionar isso em `openDatabase` se precisar de
  // deleção/atualização em cascata.
  // onConfigure: (db) async {
  //   await db.execute('PRAGMA foreign_keys = ON');
  // }
}