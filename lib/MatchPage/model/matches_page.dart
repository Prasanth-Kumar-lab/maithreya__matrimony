class MatchResponse {
  final bool success;
  final List<dynamic> data;
  final String? message;

  MatchResponse({
    required this.success,
    required this.data,
    this.message,
  });

  factory MatchResponse.fromJson(Map<String, dynamic> json) {
    return MatchResponse(
      success: json['status'] == 'success',
      data: json['data'] ?? [],
      message: json['message'] as String?,
    );
  }
}