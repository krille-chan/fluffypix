class Chunk<T> {
  final String? next;
  final String? prev;
  final List<T> chunk;

  Chunk(this.next, this.prev, this.chunk);

  factory Chunk.fromJson(
          Map<String, dynamic> json, T Function(Map<String, dynamic>) parser) =>
      Chunk(
        json['next']?.toString(),
        json['prev']?.toString(),
        (json['chunk'] as List).map((j) => parser(j)).toList(),
      );
}
