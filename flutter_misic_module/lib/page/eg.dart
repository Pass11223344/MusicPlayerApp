
import 'package:flutter/material.dart';
//import 'package:flutter_app/pullandpush.dart';
//import "package:pull_to_refresh/pull_to_refresh.dart";



class MyApps extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new MyAppState();
  }
}

class MyAppState extends State<MyApps> with TickerProviderStateMixin {
  final List<ListItem> listData = [];
  ScrollController sc = new ScrollController(initialScrollOffset: 0.0);
  late TabController tc;
  late TabController tc1;
  Duration _kScrollDuration = Duration(milliseconds: 100);
  Curve _kScrollCurve = Curves.fastOutSlowIn;
  @override
  void initState() {
    for (int i = 0; i < 20; i++) {
      listData.add(new ListItem("我是测试标题$i", Icons.cake));
    }

    tc = new TabController(length: 2, vsync: this);
    tc.addListener(() {
      //var offset=sc.offset+1000;

//      sc.animateTo(offset, duration: _kScrollDuration, curve: _kScrollCurve);
//
//      sc.animateTo(offset-2000, duration: _kScrollDuration, curve: _kScrollCurve);
      //sc.animateTo(sc.offset-500, duration: _kScrollDuration, curve: _kScrollCurve);
      setState(() {});
    });
    tc1 = new TabController(length: 3, vsync: this);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return
      //PullAndPush(
      Scaffold(body:
          Container(
            color: Colors.blueAccent,
            margin: EdgeInsets.only(top: 500),
            alignment: Alignment.center,
            constraints:BoxConstraints(maxHeight: 200) ,
            child:  Row(

              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(color: Colors.red,width: 50,height: 50,margin: EdgeInsets.only(right: 10),),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  Text("data11111111111111"),
                  Text("22:46"),
                Container(
                  constraints:BoxConstraints(maxHeight: 80) ,
                  child:   Text(
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      "22:\n"
                      "22:\n"
                      "46aaaaaaaaaaaaa\n"),
                ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    width:MediaQuery.of(context).size.width-80,
                    color: Colors.grey,
                    child: Row(
                      children: [
                        Container(width: 40,height: 40,),
                        Column(children: [
                          Text("data"),
                          Text("data"),
                        ],)
                      ],
                    ),
                  ),
                    Container(
                      width:MediaQuery.of(context).size.width-80,
                      child:    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton.icon(onPressed: (){}, label: Text("aaaa"),icon: Icon(Icons.question_answer),),
                          TextButton.icon(onPressed: (){}, label: Text("bbb"),icon: Icon(Icons.favorite_border_outlined),),
                          Image.asset("images/more.png",width: 15,height: 15)
                        ],),
                    )


                ],)
              ],
            ),
          )
        // );
//      DefaultTabController(
//      length: 2,
//      child:
//        Scaffold(
//      body: getBody(),
      );
    // );
  }

  Widget getBody() {
    return  NestedScrollView(
      controller: sc,
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        var widgets = <Widget>[
           SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: SliverAppBar(
                backgroundColor:Colors.transparent ,
                title: GradientColorAlphaTitle(
                  sc: sc,
                  title: "I'm a title",
                  height: 200.0,
                ),
                // The "forceElevated" property causes the SliverAppBar to show
                // a shadow. The "innerBoxIsScrolled" parameter is true when the
                // inner scroll view is scrolled beyond its "zero" point, i.e.
                // when it appears to be scrolled below the SliverAppBar.
                // Without this, there are cases where the shadow would appear
                // or not appear inappropriately, because the SliverAppBar is
                // not actually aware of the precise position of the inner
                // scroll views.
                forceElevated: innerBoxIsScrolled,
                expandedHeight: 200.0,

                pinned: true,
                floating: false,
                primary: true,
                //titleSpacing:0.0,
                leading: Stack(
                  children: <Widget>[
                    new IconButton(
                        icon: const BackButtonIcon(),
                        padding: const EdgeInsets.all(0.0),
                        alignment: Alignment.centerLeft,
                        tooltip:
                        MaterialLocalizations.of(context).backButtonTooltip,
                        onPressed: () {
                          Navigator.maybePop(context);
                        }),
                  ],
                ),
                flexibleSpace: FlexibleSpaceBar(
                  //centerTitle: true,
                    collapseMode: CollapseMode.pin,
                    background: Container(
                        child: Image.network(
                          "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1531798262708&di=53d278a8427f482c5b836fa0e057f4ea&imgtype=0&src=http%3A%2F%2Fh.hiphotos.baidu.com%2Fimage%2Fpic%2Fitem%2F342ac65c103853434cc02dda9f13b07eca80883a.jpg",
                          // "https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=3669273212,3031370855&fm=27&gp=0.jpg",
                          fit: BoxFit.fill,
                        ))),
//                bottom: new TabBar(
//                  controller: tc,
//                  labelColor: Colors.black87,
//                  isScrollable: false,
//                  unselectedLabelColor: Colors.grey,
//                  tabs: [
//                    Tab(icon: Icon(Icons.add), text: "add"),
//                    Tab(icon: Icon(Icons.refresh), text: "refresh"),
//                  ],
//                ),
              )),
          SliverPersistentHeader(
              pinned: true,
              floating: false,
              delegate: _SliverAppBarDelegate(
                new TabBar(

                  controller: tc,
                  labelColor: Colors.black87,
                  isScrollable: false,
                  unselectedLabelColor: Colors.grey,
                  tabs: [
                    Tab(icon: Icon(Icons.add), text: "add"),
                    Tab(icon: Icon(Icons.refresh), text: "refresh"),
                  ],
                ),
              )),
        ];
        if (tc.index == 0) {
          widgets.add(SliverPersistentHeader(
              pinned: true,
              floating: false,
              delegate: _SliverAppBarDelegate(
                new TabBar(
                  controller: tc1,
                  labelColor: Colors.black87,
                  isScrollable: false,
                  unselectedLabelColor: Colors.grey,
                  tabs: [
                    Tab(icon: Icon(Icons.security), text: "security"),
                    Tab(icon: Icon(Icons.cake), text: "cake"),
                    Tab(icon: Icon(Icons.print), text: "print"),
                  ],
                ),
              )));
        }

        return widgets;
      },
      body: TabBarView(
        controller: tc,
        children: <Widget>[
          NextBar(tc1),
          //ListBuilder(30),
          ListBuilder(50,Icons.refresh),
        ],
      ),
    );
  }
}

class ListItem {
  final String title;
  final IconData iconData;

  ListItem(this.title, this.iconData);
}

class ListItemWidget extends StatelessWidget {
  final ListItem listItem;

  ListItemWidget(this.listItem);

  @override
  Widget build(BuildContext context) {
    return new InkWell(
      child: new ListTile(
        leading: new Icon(listItem.iconData),
        title: new Text(listItem.title),
      ),
      onTap: () {},
    );
  }
}

class GradientColorAlphaTitle extends StatefulWidget {
  final ScrollController sc;
  final String title;
  final double height;
  GradientColorAlphaTitle({required this.sc, required this.title, this.height = 80.0});
  @override
  State<StatefulWidget> createState() =>
      new GradientColorAlphaTitleState(sc, title, height);
}

class GradientColorAlphaTitleState extends State<GradientColorAlphaTitle> {
  final ScrollController sc;
  final String title;
  final double height;
  int _alpha = 0;
  GradientColorAlphaTitleState(this.sc, this.title, this.height);
  @override
  void initState() {
    // TODO: implement initState
    sc.addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    sc.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    var themeColor = Theme.of(context).textTheme.bodySmall?.color;
    themeColor = Colors.white;
    return Text(title,
        style: new TextStyle(
            color: Color.fromARGB(
                _alpha, themeColor.red, themeColor.green, themeColor.blue)));
  }

  void _scrollListener() {
    int temp = _alpha;
    if (sc.offset < height) {
      temp = ((sc.offset / height) * 255).toInt();
    } else {
      temp = 255;
    }
    //print(temp);
    if (temp != _alpha) {
      _alpha = temp;
      setState(() {});
    }
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar) {
    // tc.addListener(ontab);
  }

  final TabBar _tabBar;
  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return  Container(
      color: Colors.transparent,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    //print("shouldRebuild---------------");
    return false;
  }

  void ontab() {
    //test=tc.index==1;
  }
}

class ListBuilder extends StatefulWidget {
  int count = 20;
  IconData name;
  ListBuilder(this.count,this.name);
  @override
  _LoadImgByLocAppPageState createState() =>
      new _LoadImgByLocAppPageState(count,name);
}

class _LoadImgByLocAppPageState extends State
    with AutomaticKeepAliveClientMixin
{
  IconData name;
  _LoadImgByLocAppPageState(this.count,this.name);
  int count = 20;
  final List<ListItem> listData = [];
  @override
  void initState() {
    for (int i = 0; i < count; i++) {
      listData.add(new ListItem("Item$i", name));
    }
    // TODO: implement initState
    super.initState();
    //print('_LoadImgByLocAppPageState initState -------$count');
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
        top: false,
        bottom: false,
        child: new Builder(
          // This Builder is needed to provide a BuildContext that is "inside"
          // the NestedScrollView, so that sliverOverlapAbsorberHandleFor() can
          // find the NestedScrollView.
            builder: (BuildContext context) {
              return new CustomScrollView(
                // The "controller" and "primary" members should be left
                // unset, so that the NestedScrollView can control this
                // inner scroll view.
                // If the "controller" property is set, then this scroll
                // view will not be associated with the NestedScrollView.
                // The PageStorageKey should be unique to this ScrollView;
                // it allows the list to remember its scroll position when
                // the tab view is not on the screen.
                key: new PageStorageKey<String>("KeyName$name"),
                slivers: <Widget>[
                  new SliverOverlapInjector(
                    // This is the flip side of the SliverOverlapAbsorber above.
                    handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                  ),
                  new SliverPadding(
                    padding: const EdgeInsets.all(8.0),
                    // In this example, the inner scroll view has
                    // fixed-height list items, hence the use of
                    // SliverFixedExtentList. However, one could use any
                    // sliver widget here, e.g. SliverList or SliverGrid.
                    sliver: new SliverFixedExtentList(
                      // The items in this example are fixed to 48 pixels
                      // high. This matches the Material Design spec for
                      // ListTile widgets.
                      itemExtent: 48.0,
                      delegate: new SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                          // This builder is called for each child.
                          // In this example, we just number each list item.
                          return new ListItemWidget(listData[index]);
                        },
                        // The childCount of the SliverChildBuilderDelegate
                        // specifies how many children this inner list
                        // has. In this example, each tab has a list of
                        // exactly 30 items, but this is arbitrary.
                        childCount: listData.length,
                      ),
                    ),
                  ),
                ],
              );
            }));

//    return new ListView.builder(
//      key: new PageStorageKey<String>("_LoadImgByLocAppPageState$count"),
//      itemBuilder: (BuildContext context, int index) {
//        return new ListItemWidget(listData[index]);
//      },
//      itemCount: listData.length,
//    );
  }

  // TODO: implement wantKeepAlive
  @override
  bool get wantKeepAlive => true;
}

class NextBar extends StatefulWidget {
  TabController tc;
  NextBar(this.tc);
  @override
  _NextBarState createState() => new _NextBarState(tc);
}

class _NextBarState extends State with AutomaticKeepAliveClientMixin {
  TabController tc;
  _NextBarState(this.tc);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return new TabBarView(controller: tc, children: <Widget>[
      ListBuilder(10,Icons.security),
      ListBuilder(20,Icons.cake),
      ListBuilder(30,Icons.print),
    ]);
  }

  // TODO: implement wantKeepAlive
  @override
  bool get wantKeepAlive => true;
}
