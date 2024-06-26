import 'package:flutter/material.dart';

class dd extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
       final List<String> _tabs = <String>['Tab 1', 'Tab 2'];
       return DefaultTabController(
        length: _tabs.length, // This is the number of tabs.
         child: Scaffold(
           body: NestedScrollView(
             headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
               // These are the slivers that show up in the "outer" scroll view.
               return <Widget>[
                 SliverOverlapAbsorber(

                   handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                   sliver: SliverAppBar(
                     title: const Text('Books'), // This is the title in the app bar.
                     pinned: true,
                     expandedHeight: 150.0,

                     forceElevated: innerBoxIsScrolled,
                     bottom: TabBar(
                       // These are the widgets to put in each tab in the tab bar.
                       tabs: _tabs.map((String name) => Tab(text: name)).toList(),
                     ),
                  ),
                ),
               ];
             },
             body: TabBarView(
               // These are the contents of the tab views, below the tabs.
               children: _tabs.map((String name) {
                 return SafeArea(
                   top: false,
                   bottom: false,
                   child: Builder(

                     builder: (BuildContext context) {
                       return CustomScrollView(

                         key: PageStorageKey<String>(name),
                         slivers: <Widget>[
                           SliverOverlapInjector(

                             handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                           ),
                           SliverPadding(
                             padding: const EdgeInsets.all(8.0),

                             sliver:SliverToBoxAdapter(
                               child: Container(
                                 height: 200,
                                 color: Colors.orangeAccent,child: Text("sdhbjfkhsDK"),),
                             )
                           ),
                         ],
                       );
                     },
                   ),
                 );
               }).toList(),
             ),
           ),
         ),
       );
     }
  
}
