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

  final int currentOrdersPage;
  final bool hasMoreCurrentOrders;
  final bool isFetchingMoreCurrentOrders;

  final int recentOrdersPage;
  final bool hasMoreRecentOrders;
  final bool isFetchingMoreRecentOrders;

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
    this.currentOrdersPage = 1,
    this.hasMoreCurrentOrders = true,
    this.isFetchingMoreCurrentOrders = false,
    this.recentOrdersPage = 1,
    this.hasMoreRecentOrders = true,
    this.isFetchingMoreRecentOrders = false,
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
    int? currentOrdersPage,
    bool? hasMoreCurrentOrders,
    bool? isFetchingMoreCurrentOrders,
    int? recentOrdersPage,
    bool? hasMoreRecentOrders,
    bool? isFetchingMoreRecentOrders,
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
      currentOrdersPage: currentOrdersPage ?? this.currentOrdersPage,
      hasMoreCurrentOrders: hasMoreCurrentOrders ?? this.hasMoreCurrentOrders,
      isFetchingMoreCurrentOrders: isFetchingMoreCurrentOrders ?? this.isFetchingMoreCurrentOrders,
      recentOrdersPage: recentOrdersPage ?? this.recentOrdersPage,
      hasMoreRecentOrders: hasMoreRecentOrders ?? this.hasMoreRecentOrders,
      isFetchingMoreRecentOrders: isFetchingMoreRecentOrders ?? this.isFetchingMoreRecentOrders,
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
    currentOrdersPage,
    hasMoreCurrentOrders,
    isFetchingMoreCurrentOrders,
    recentOrdersPage,
    hasMoreRecentOrders,
    isFetchingMoreRecentOrders,
  ];
}