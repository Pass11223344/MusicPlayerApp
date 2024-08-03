import 'package:flutter/material.dart';
import 'package:flutter_misic_module/main.dart';
import 'package:flutter_misic_module/util/Utils.dart';

import '../bean/RankingListBean.dart';
import 'myPage.dart';



class rankingListPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => rankingListPageSatate();

}
class rankingListPageSatate extends State<rankingListPage>{
 List<RankingListBean>? rankingList;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   getData();

  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
   return Scaffold(
     backgroundColor: Color(0xF5FFFFFF),
     appBar: AppBar(
       backgroundColor: Color(0xF5FFFFFF),
       title: Text("排行榜"),
     ),
     body: rankingList!=null? Padding(padding: EdgeInsets.only(left: 10,right: 10,bottom: 10),
         child: CustomScrollView(
           slivers: [
             const SliverToBoxAdapter(child: Text("官方榜"),),
             const SliverToBoxAdapter(child: SizedBox(height: 20,),),
             SliverFixedExtentList(delegate: SliverChildBuilderDelegate(
                 childCount: 4,
                     (context,index){
                   return
                     InkWell(
                       onTap: (){
                         Navigator.pushNamed(context, "main/songListPage",arguments: {
                           "id":"${rankingList![index].id}",
                           "title":rankingList![index].name,
                           "IsTheSame":false,
                           "type":"to_ranking"});
                       },
                       child:Container(
                         padding: EdgeInsets.symmetric(horizontal: 10),
                         margin: EdgeInsets.only(bottom: 10),
                         decoration: BoxDecoration(
                             color: Colors.white,
                             borderRadius: BorderRadius.circular(15)
                         ),
                         child: Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                           children: [
                             Row(
                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                 children: [
                                   Text(rankingList![index].name,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                                   Text(rankingList![index].updateFrequency),
                                 ]),
                             Row(
                               children: [

                                 getSquareImg(Url: rankingList![index].coverImgUrl,width:  60,height:  60),
                                 Container(
                                   width: 300,
                                   alignment: Alignment.centerLeft,
                                   padding: EdgeInsets.only(left: 10),
                                   child: Column(
                                       mainAxisAlignment: MainAxisAlignment.center,
                                       crossAxisAlignment: CrossAxisAlignment.start,
                                       children:rankingList![index].tracks.asMap().entries.map((entry){
                                         int index = entry.key;
                                         return Text("${index+1} ${entry.value.first} - ${entry.value.second}",style:
                                         const TextStyle(fontWeight: FontWeight.bold,),maxLines: 1,overflow: TextOverflow.ellipsis,);
                                       }).toList() ),
                                 )

                               ],
                             ),
                           ],
                         ),
                       ) ,
                     );
                 }
             ), itemExtent: 140),
             const SliverToBoxAdapter(child: SizedBox(height: 20,),),
             const SliverToBoxAdapter(child: Text("其他榜单"),),
             const SliverToBoxAdapter(child: SizedBox(height: 20,),),
             SliverGrid.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                 crossAxisSpacing: 10.0, // 设置列间距
                 mainAxisSpacing: 10.0, // 设置行间距
                 childAspectRatio: 1.0,
                 crossAxisCount: 3),
                 itemCount: rankingList!.length-4,
                 itemBuilder: (context,index){
                    var sublist = rankingList!.sublist(4);
                    return
                    GestureDetector(
                      onTap: (){
                        Navigator.pushNamed(context, "main/songListPage",arguments: {
                          "id":"${sublist[index].id}",
                          "title":sublist[index].name,
                          "IsTheSame":false,
                          "type":"to_ranking"});
                      },
                      child:Container(
                        decoration:   BoxDecoration(
                            color: Colors.blue[100 * (index % 8)],
                            borderRadius: BorderRadius.circular(15),
                            image: DecorationImage(image: NetworkImage(
                                headers: { 'User-Agent':'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36 SLBrowser/9.0.3.5211 SLBChan/103',
                                },
                                sublist[index].coverImgUrl))
                        ),
                      ) ,
                    );
             })


           ],
         )
     ):Utils.loadingView(Alignment.topCenter)

    ,
   );
  }

  void getData() {
    dioRequest.executeGet(url: "/toplist/detail").then((value){
     rankingList =  (value['list'] as List<dynamic>).map((json)=>RankingListBean.fromJson(json)).toList();
     setState(() {

     });
    });
  }

}