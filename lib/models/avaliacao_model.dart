class AvaliacaoModel {
  String id;
  String avaliacao;
  String data;

  AvaliacaoModel({required this.id, required this.avaliacao, required this.data});

  AvaliacaoModel.fromMap(Map<String, dynamic> map)
    : id = map['id'],
      avaliacao = map['avaliacao'],
      data = map['data'];

  Map<String, dynamic> toMap() {
    return {
      "id": id, 
      "avaliacao": avaliacao,
      "data": data,
      };
  }
}
