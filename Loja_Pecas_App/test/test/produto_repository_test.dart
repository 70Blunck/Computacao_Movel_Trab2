import 'package:flutter_test/flutter_test.dart';
import 'package:loja_pecas_app/database_helper.dart';
import 'package:loja_pecas_app/models/categoria.dart';
import 'package:loja_pecas_app/models/produto.dart';
import 'package:loja_pecas_app/repositories/categoria_repository.dart';
import 'package:loja_pecas_app/repositories/produto_repository.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart'; // Importa o banco em memória

void main() {
  // Inicializa o banco de dados FFI (em memória) para testes
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  // Declara os repositórios que vamos testar
  late CategoriaRepository categoriaRepo;
  late ProdutoRepository produtoRepo;

  // 'setUp' roda antes de CADA teste, garantindo um banco limpo
  setUp(() async {
    // Pega a instância do DatabaseHelper
    final dbHelper = DatabaseHelper.instance;
    
    // Limpa o banco de dados ANTES de cada teste
    // Isso é essencial para que um teste não interfira no outro
    final db = await dbHelper.database;
    await db.delete(DatabaseHelper.tableProduto);
    await db.delete(DatabaseHelper.tableCategoria);

    // Inicializa os repositórios
    categoriaRepo = CategoriaRepository();
    produtoRepo = ProdutoRepository();
  });

  // --- Nossos 4 Testes Obrigatórios ---

  // Teste 1: Salvar e Listar (Criação e Leitura) [cite: 205]
  test('Teste 1: Deve salvar e listar um produto', () async {
    // 1. ARRANGE (Organizar)
    final catId = await categoriaRepo.salvarCategoria(
      Categoria(nome: 'SSD', descricao: '', dataCadastro: DateTime.now(), ativa: true),
    );
    final produto = Produto(
      categoriaId: catId,
      nome: 'Kingston A400',
      fabricante: 'Kingston',
      preco: 200,
      estoque: 10,
    );
    
    // 2. ACT (Agir)
    await produtoRepo.salvarProduto(produto);
    final lista = await produtoRepo.listarTodosProdutos();

    // 3. ASSERT (Verificar)
    expect(lista, isNotEmpty);
    expect(lista.length, 1);
    expect(lista.first.nome, 'Kingston A400');
  });

  // Teste 2: Excluir um produto [cite: 206]
  test('Teste 2: Deve excluir um produto', () async {
    // ARRANGE
    final catId = await categoriaRepo.salvarCategoria(
      Categoria(nome: 'RAM', descricao: '', dataCadastro: DateTime.now(), ativa: true),
    );
    final produto = Produto(
      categoriaId: catId,
      nome: 'Corsair Vengeance',
      fabricante: 'Corsair',
      preco: 300,
      estoque: 20,
    );
    await produtoRepo.salvarProduto(produto);
    
    // Pega o ID do produto recém-criado (o banco nos dá o ID 1, pois está limpo)
    final listaAposSalvar = await produtoRepo.listarTodosProdutos();
    final produtoId = listaAposSalvar.first.id!;

    // ACT
    await produtoRepo.excluirProduto(produtoId);
    final listaAposExcluir = await produtoRepo.listarTodosProdutos();

    // ASSERT
    expect(listaAposExcluir, isEmpty);
  });

  // Teste 3: Atualizar um produto [cite: 208]
  test('Teste 3: Deve atualizar um produto', () async {
    // ARRANGE
    final catId = await categoriaRepo.salvarCategoria(
      Categoria(nome: 'Fonte', descricao: '', dataCadastro: DateTime.now(), ativa: true),
    );
    final produto = Produto(
      categoriaId: catId,
      nome: 'Corsair CV550',
      fabricante: 'Corsair',
      preco: 400,
      estoque: 5,
    );
    await produtoRepo.salvarProduto(produto);
    
    // Pega o produto do banco
    final produtoDoBanco = (await produtoRepo.listarTodosProdutos()).first;
    
    // ACT
    // Modifica o preço e o estoque
    produtoDoBanco.preco = 450;
    produtoDoBanco.estoque = 3;
    await produtoRepo.atualizarProduto(produtoDoBanco);

    // Busca o produto atualizado
    final produtoAtualizado = (await produtoRepo.listarTodosProdutos()).first;

    // ASSERT
    expect(produtoAtualizado.preco, 450);
    expect(produtoAtualizado.estoque, 3);
  });

  // Teste 4: Salvar e Listar Categoria (para completar os 4 testes)
  test('Teste 4: Deve salvar e listar uma categoria', () async {
    // ARRANGE
    final categoria = Categoria(
      nome: 'Placa de Vídeo',
      descricao: 'GPUs',
      dataCadastro: DateTime.now(),
      ativa: true,
    );
    
    // ACT
    await categoriaRepo.salvarCategoria(categoria);
    final lista = await categoriaRepo.listarTodasCategorias();

    // ASSERT
    expect(lista, isNotEmpty);
    expect(lista.first.nome, 'Placa de Vídeo');
  });
}