import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:productivity_app/models/github_repo_model.dart';

class GithubRepository {
  final String baseUrl = "https://api.github.com";

  Future<List<GithubRepoModel>> getRepositories(String username) async {
    final response = await http.get(Uri.parse("$baseUrl/users/$username/repos"));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<GithubRepoModel> repositories = body
          .map(
            (dynamic item) => GithubRepoModel.fromJson(item),
          )
          .toList();
      return repositories;
    } else {
      throw Exception("Failed to load repositories");
    }
  }
}
