class ServicoModel {
  String id;
  String name;
  String servico;
  String descricao;
  String avaliacao;

  String? urlImage;

  ServicoModel({
    required this.id,
    required this.name,
    required this.servico,
    required this.descricao,
    required this.avaliacao,
    this.urlImage,
  });

  ServicoModel.fromMap(Map<String, dynamic> map)
    : id = map['id'],
      name = map['name'],
      servico = map['servico'],
      descricao = map['descricao'],
      avaliacao = map['avaliacao'],
      urlImage = map['urlImage'];

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "servico": servico,
      "descricao": descricao,
      "avaliacao": avaliacao,
      "urlImage": urlImage,
    };
  }
}
