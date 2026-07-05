class ApiQueryParams {
  static Map<String, dynamic> pagination({int? page, int? pageSize}) {
    return {
      'page': page,
      'page_size': pageSize,
    };
  }
}
