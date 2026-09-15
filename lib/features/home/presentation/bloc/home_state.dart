part of 'home_bloc.dart';

enum HomeStatus { initial, loading, success, error }

class HomeState extends Equatable {
  final HomeStatus? currentOrdersStatus;
  final HomeStatus? recentCollectionRequestsStatus;
  final HomeStatus? profileStatus;
  final String? errorMessage;
  final CustomerCollectionRequestResponseModel? recentCollectionRequests;
  final CustomerCollectionRequestResponseModel? currentCollectionRequest;
  final ProfileResponseModel? profile;
  final HeaderDataModel? headerData;
  final int? points;
  final int? levelProgress;
  final int? nextLevelProgress;

  const HomeState({
    this.currentOrdersStatus,
    this.recentCollectionRequestsStatus,
    this.profileStatus,
    this.errorMessage,
    this.recentCollectionRequests,
    this.currentCollectionRequest,
    this.profile,
    this.headerData,
    this.points,
    this.levelProgress,
    this.nextLevelProgress,
  });

  HomeState copyWith({
    HomeStatus? currentOrdersStatus,
    HomeStatus? recentCollectionRequestsStatus,
    HomeStatus? profileStatus,
    String? errorMessage,
    CustomerCollectionRequestResponseModel? recentCollectionRequest,
    CustomerCollectionRequestResponseModel? currentCollectionRequest,
    HeaderDataModel? headerData,
    ProfileResponseModel? profile,
    int? points,
    int? levelProgress,
    int? nextLevelProgress,
  }) {
    return HomeState(
      currentOrdersStatus: currentOrdersStatus ?? this.currentOrdersStatus,
      recentCollectionRequestsStatus: recentCollectionRequestsStatus ?? this.recentCollectionRequestsStatus,
      profileStatus: profileStatus ?? this.profileStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      recentCollectionRequests: recentCollectionRequest ?? recentCollectionRequests,
      currentCollectionRequest: currentCollectionRequest ?? this.currentCollectionRequest,
      headerData: headerData ?? this.headerData,
      profile: profile ?? this.profile,
      points: points ?? this.points,
      levelProgress: levelProgress ?? this.levelProgress,
      nextLevelProgress: nextLevelProgress ?? this.nextLevelProgress,
    );
  }

  @override
  List<Object?> get props => [
    currentOrdersStatus,
    recentCollectionRequestsStatus,
    profileStatus,
    recentCollectionRequests,
    currentCollectionRequest,
    headerData,
    profile,
    points,
    levelProgress,
    nextLevelProgress,
  ];
}