part of 'github_bloc.dart';

abstract class GithubEvent extends Equatable {
  const GithubEvent();

  @override
  List<Object> get props => [];
}

class GithubFetchRepos extends GithubEvent {
  final String username;

  const GithubFetchRepos(this.username);

  @override
  List<Object> get props => [username];
}
