class GithubRepoModel {
  final String name;
  final String description;
  final String htmlUrl;
  final int stargazersCount;
  final String language;

  GithubRepoModel({
    required this.name,
    required this.description,
    required this.htmlUrl,
    required this.stargazersCount,
    required this.language,
  });

  factory GithubRepoModel.fromJson(Map<String, dynamic> json) {
    return GithubRepoModel(
      name: json['name'] ?? 'No Name',
      description: json['description'] ?? 'No Description',
      htmlUrl: json['html_url'] ?? '',
      stargazersCount: json['stargazers_count'] ?? 0,
      language: json['language'] ?? 'Unknown',
    );
  }
}
