class SearchHotListBean {
  String searchWord;
  String iconUrl;

  SearchHotListBean(this.searchWord, this.iconUrl);

  factory SearchHotListBean.fromJson(Map<String, dynamic> json) =>
      SearchHotListBean(json['searchWord'] as String,
          json['iconUrl'] == null ? "" : json['iconUrl'] as String);

  Map<String, dynamic> toJson(SearchHotListBean bean) =>
      {"searchWord": bean.searchWord, "iconUrl": bean.iconUrl};
}
