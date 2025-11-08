# Computacao_Movel_Trab2

## Parte 1: Camada de Dados e Persistência
O objetivo desta primeira parte foi migrar a aplicação de dados em memória para uma solução com persistência local, aplicando o padrão Repository para isolar o acesso ao banco de dados.

### 1. Descrição da Camada de Dados
Para atender ao tema "Loja de Peças", foram modelados os dois conceitos principais: Categoria e Produto.

Categoria: Modela os tipos de produtos (Ex: "Placa de Vídeo", "SSD", "Placa-Mãe").

Produto: Modela o item específico (Ex: "NVIDIA RTX 4070") e se associa a uma Categoria através de uma chave estrangeira (categoriaId).

Ambas as classes possuem no mínimo 5 atributos, conforme exigido , e incluem os métodos toMap() e fromMap() para conversão de e para o banco de dados.


### 2. Biblioteca de Persistência (SQFLite)
A biblioteca de persistência escolhida foi o sqflite.

Justificativa: O sqflite é um wrapper robusto para o SQLite, um banco de dados SQL relacional. Esta escolha foi ideal para o nosso tema, pois permite o uso de chaves estrangeiras (FOREIGN KEY) para criar um relacionamento claro e seguro entre a tabela produtos e a tabela categorias, garantindo a integridade dos dados.

### 3. Lógica do Repositório (Fluxo de Dados)
O acesso aos dados foi encapsulado em classes Repository (CategoriaRepository e ProdutoRepository). O fluxo de dados funciona da seguinte maneira:



Escrita (Salvar):

A UI (ou, neste caso, o teste de console) envia um objeto Dart (ex: Produto) para o repositório.

O repositório chama o método toMap() do objeto para convertê-lo em um Map<String, dynamic>.

Este Map é passado para o método db.insert() do sqflite, que o salva na tabela SQL correspondente.

Leitura (Listar):

O repositório chama db.query() no sqflite.

O banco retorna uma List<Map<String, dynamic>>.

O repositório itera sobre essa lista e usa o método estático fromMap() do modelo para converter cada Map de volta em um objeto Dart (ex: List<Produto>).

Todo esse processo é assíncrono, utilizando Future, async e await para não bloquear a interface do usuário.


###4. Execução e Teste de Console
Para executar o projeto:

Clone este repositório.

Garanta que um Emulador Android esteja configurado e em execução.

No terminal, execute flutter pub get para instalar as dependências.

Execute flutter run para rodar o aplicativo.

Resultado do Teste de Lógica (Console):

Conforme solicitado, foi executado um teste na função main() para validar a inserção e leitura no banco. O resultado abaixo confirma que a Categoria ("Placa-Mãe") foi salva (recebendo ID: 1) e que o Produto ("Asus ROG Strix...") foi salvo e associado corretamente a ela (CatID: 1)
<img width="635" height="597" alt="image" src="https://github.com/user-attachments/assets/c452ce05-37b8-4978-8d51-d64375223063" />
