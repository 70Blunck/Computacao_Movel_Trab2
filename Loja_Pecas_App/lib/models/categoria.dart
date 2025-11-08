// Importa o helper para usarmos os nomes das colunas
import 'package:loja_pecas_app/database_helper.dart'; 

class Categoria {
  int? id;
  String nome;
  String descricao;
  DateTime dataCadastro;
  bool ativa;

  Categoria({
    this.id,
    required this.nome,
    required this.descricao,
    required this.dataCadastro,
    required this.ativa,
  });

  // Método toMap: Converte o objeto Categoria para um Map
  Map<String, dynamic> toMap() {
    return {
      DatabaseHelper.colCatId: id,
      DatabaseHelper.colCatNome: nome,
      DatabaseHelper.colCatDescricao: descricao,
      // Converte DateTime para String (formato ISO 8601)
      DatabaseHelper.colCatDataCadastro: dataCadastro.toIso8601String(), 
      // Converte bool para int (1 = true, 0 = false)
      DatabaseHelper.colCatAtiva: ativa ? 1 : 0, 
    };
  }

  // Método fromMap: Converte um Map vindo do banco para um objeto Categoria
  static Categoria fromMap(Map<String, dynamic> map) {
    return Categoria(
      id: map[DatabaseHelper.colCatId],
      nome: map[DatabaseHelper.colCatNome],
      descricao: map[DatabaseHelper.colCatDescricao],
      // Converte a String do banco de volta para DateTime
      dataCadastro: DateTime.parse(map[DatabaseHelper.colCatDataCadastro]),
      // Converte o int do banco de volta para bool
      ativa: map[DatabaseHelper.colCatAtiva] == 1,
    );
  }
}