# Computação Móvel Trabalho 2

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


### 4. Execução e Teste de Console
Para executar o projeto:

Clone este repositório.

Garanta que um Emulador Android esteja configurado e em execução.

No terminal, execute flutter pub get para instalar as dependências.

Execute flutter run para rodar o aplicativo.

Resultado do Teste de Lógica (Console):

Conforme solicitado, foi executado um teste na função main() para validar a inserção e leitura no banco. O resultado abaixo confirma que a Categoria ("Placa-Mãe") foi salva (recebendo ID: 1) e que o Produto ("Asus ROG Strix...") foi salvo e associado corretamente a ela (CatID: 1)
<img width="635" height="597" alt="image" src="https://github.com/user-attachments/assets/c452ce05-37b8-4978-8d51-d64375223063" />

## Parte 2: Primeira Interface do Usuário
Nesta etapa, o projeto de console foi transformado em uma aplicação Flutter visual. O objetivo foi conectar a camada de dados (Parte 1) a uma interface gráfica, exibindo os dados persistidos na tela do emulador.

### 1. Integração dos Dados e UI
Para exibir os dados do banco de dados na tela, a integração foi feita da seguinte forma:

Foi criado um StatelessWidget (ListaProdutosScreen) para a tela principal. 


Dentro do build da tela, foi utilizado um FutureBuilder.

O future do FutureBuilder foi conectado ao método produtoRepo.listarTodosProdutos(), que busca os dados assincronamente no banco.

Enquanto os dados são carregados, um CircularProgressIndicator é exibido.

Quando os dados são recebidos (snapshot.hasData), eles são passados para um ListView, que renderiza cada produto da lista usando um Card e um ListTile, exibindo seus atributos (nome, fabricante, preço e estoque).



A estrutura da tela utiliza os widgets Scaffold e AppBar como base, conforme solicitado. 


### 2. Resultado no Emulador
A captura de tela abaixo demonstra o aplicativo em execução no emulador (Android Virtual Device - AVD), exibindo os dados que foram persistidos no banco de dados na etapa anterior:
<img width="397" height="862" alt="image" src="https://github.com/user-attachments/assets/2db57204-cdf3-4f00-85e6-2445aafead3a" />

## Parte 3: Qualidade de Software e Testes
Nesta última etapa, o foco foi garantir a robustez e a qualidade do código-fonte através de testes automatizados e refatoração, seguindo os princípios de "Clean Code". 

### 1. Refatoração e Boas Práticas (Clean Code)
Antes da implementação dos testes, o código-fonte foi revisado e refatorado, aplicando as seguintes melhorias:


Formatação Consistente: O comando flutter format . foi executado em todo o projeto para garantir um padrão de formatação. 


Modificador const: Adicionamos o modificador const em todos os widgets estáticos (como Text, Padding, Scaffold, etc.) para melhorar a performance de renderização. 

Injeção de Dependência: A ListaProdutosScreen foi refatorada para receber o ProdutoRepository via construtor. Isso desacoplou a tela da camada de dados e foi essencial para permitir o "mock" do repositório durante os testes de widget.


Remoção de Código Morto: Todo código comentado ou que não estava sendo utilizado foi removido. 

### 2. Testes de Unidade (Unit Tests)
Foram implementados 4 testes de unidade (Unit Tests) para validar a lógica de negócios e as operações CRUD nos Repositórios, utilizando um banco de dados em memória (sqflite_common_ffi) para isolar os testes.


Descrição do Teste Mais Complexo (Teste 3: Atualizar):

O teste de atualização (Deve atualizar um produto) é crucial. Ele garante que a lógica de UPDATE está funcionando corretamente. O teste primeiro salva um produto, depois o recupera, modifica seus valores (preço e estoque) e chama o atualizarProduto(). Por fim, ele busca o produto novamente e verifica se os novos valores foram persistidos no banco. Isso garante que os dados não estão apenas sendo modificados em memória, mas sim no banco. 

### 3. Testes de Widget (Widget Tests)
Foram implementados 2 testes de widget (Widget Tests) para validar a renderização da interface e sua interatividade. 


Descrição do Teste Mais Relevante (Teste 1: Lista Vazia):

O teste (Tela de Listagem deve exibir mensagem quando vazia) valida um cenário de UI fundamental. Usando um "Mock Repository" (um repositório falso), nós simulamos uma resposta de banco de dados retornando uma lista vazia. O teste então verifica se a tela, ao invés de quebrar, renderiza corretamente a mensagem "Nenhum produto cadastrado." para o usuário. Isso garante que a UI reage de forma controlada a diferentes estados de dados. 

### 4. Resultados da Execução dos Testes
O comando flutter test foi executado e todos os testes de unidade e widget passaram com sucesso, confirmando a estabilidade da aplicação. 

<img width="922" height="62" alt="image" src="https://github.com/user-attachments/assets/b966f011-a969-45ab-922e-eb296d292361" />
