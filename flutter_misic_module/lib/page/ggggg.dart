
import 'package:flutter/material.dart';

class ss extends StatefulWidget{
  @override
  State<StatefulWidget> createState()  => sState();


}
class sState extends State<ss>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,
      body:  Center(
        child:SafeArea(
          right: false,
          child:  Row(
            children: [

              Container(width: 80,height: 80,),
              "-eeeeeeeepppppppppppppp,kkkkkkkk,,,888,,,,,,88888888888888,".length>24?
              Container(
                width:MediaQuery.of(context).size.width*0.46 ,
                  color: Colors.red,
                  child: Text(
                    "ttttttttttkkkkkkk8",
                    overflow:
                    TextOverflow
                        .ellipsis,
                    maxLines: 1,
                    style: const TextStyle(
                        color: Colors
                            .black,
                        fontSize: 14),
                  ),
                )
                  :Container(
                color: Colors.red,
                child: Text(
                  "-eeeeeeeeppppp,",
                  overflow:
                  TextOverflow
                      .ellipsis,
                  maxLines: 1,
                  style: const TextStyle(
                      color: Colors
                          .black,
                      fontSize: 14),
                ),
              ),
            "-eeeeeeeepppppppppppppp,kkkkkkkk,,,888,,,,,,88888888888888,".length>24?
             SizedBox(
              width:  MediaQuery.of(context).size.width*0.3,
               child:  Text(
                 overflow: TextOverflow.ellipsis,
                 textAlign: TextAlign.left,
                 "-ee8888888888888,",

                 maxLines: 1,
                 style:
                 const TextStyle(
                     color: Colors
                         .grey,
                     fontSize:
                     12),
               ),
             ): Text(
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.left,
              "-eeeeeeeeppppp,",

              maxLines: 1,
              style:
              const TextStyle(
                  color: Colors
                      .grey,
                  fontSize:
                  12),
            ),
            ],
          ),
        ),
      ),
    );
  }

}