class searchHotListBean {
  String searchWord;
  String iconUrl;

  searchHotListBean(this.searchWord, this.iconUrl);
  factory searchHotListBean.fromJson(Map<String ,dynamic> json) => searchHotListBean(
      json['searchWord']as String, json['iconUrl']==null?"":json['iconUrl'] as String);
  Map<String,dynamic> toJson(searchHotListBean bean) =>{
    "searchWord": bean.searchWord,
    "iconUrl":bean.iconUrl
  };
}