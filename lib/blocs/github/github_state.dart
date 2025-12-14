part of 'github_bloc.dart';

abstract class GithubState extends Equatable {
  const GithubState();
  
  @override
  List<Object> get props => [];
}

class GithubInitial extends GithubState {}

class GithubLoading extends GithubState {}

class GithubLoaded extends GithubState {
  final List<GithubRepoModel> repos;

  const GithubLoaded(this.repos);

  @override
  List<Object> get props => [repos];
}

class GithubError extends GithubState {
  final String message;

  const GithubError(this.message);

  @override
  List<Object> get props => [message];
}
