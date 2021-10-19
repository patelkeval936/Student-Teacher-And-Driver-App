import 'package:attendance_app/readNotice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class NoticesForBottomAppBar extends StatefulWidget {
  static final id = 'Notices';

  @override
  _NoticesForBottomAppBarState createState() => _NoticesForBottomAppBarState();
}

class _NoticesForBottomAppBarState extends State<NoticesForBottomAppBar> {

  List<Widget> noticesList = List<Widget>();

  getNotices(snapshot) {

    noticesList = [];

    List notices = [];

    notices = snapshot.data['notices'];

    Widget message;

    for (int i = notices.length - 1; i >= 0; i--){
      //  var timeOfMessage = DateTime.fromMillisecondsSinceEpoch(data[i]['date']);
      DateTime time = notices[i]['time'].toDate();
      String timeOfMessage = '${time.day}/${time.month}/${time.year}';

      message = Card(
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
        elevation: 5.0,
        child: ListTile(
          isThreeLine: false,
          onTap: () {
            Navigator.push(context,
              MaterialPageRoute(builder: (context) => ReadNotification(
                sub: notices[i]['title'],writer:notices[i]['by'],
                time: notices[i]['time'].toDate(),desc: notices[i]['desc'],
              ),
              ),
            );
          },
          contentPadding: EdgeInsets.only(left: 18,right: 10,top: 10,bottom: 10),
          leading: Container(width: 50,
              child: Image.asset('assets/images/message.png'),),
          title: Padding(
            padding: const EdgeInsets.only(left: 4,right: 4,bottom: 4,top: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  //'${data[i]['by']}',
                  'Admin',
                  style: TextStyle(fontWeight: FontWeight.w700,color: Colors.grey.shade800),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: Text(
                    //  '${timeOfMessage.day}/${timeOfMessage.month}/${timeOfMessage.year}  ',
                    '$timeOfMessage',
                    style: TextStyle(fontSize: 13.0),
                  ),
                )
              ],
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text('${notices[i]['title']}'),
          ),
        ),
      );
      noticesList.add(message);
    }
  }

  String roleOfUser;

  void roleAndIdGetter()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();

    String role;

    try{
       role = preferences.getString('role').toLowerCase();
    }catch(e){
      print(e);
    }

    setState(() {
      roleOfUser = role;
    });

  }

  @override
  void initState() {
    roleAndIdGetter();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    print('build is running');


    double height = MediaQuery.of(context).size.height;
   double width = MediaQuery.of(context).size.width;

   return Container(
     height: height,
     width: width,
     child: Column(
       children: <Widget>[
         StreamBuilder(
           stream: FirebaseFirestore.instance
               .doc('notice/$roleOfUser')
               .snapshots(),

           builder: (context, snapshot){

             if(snapshot.connectionState == ConnectionState.waiting){
               return Container(
                   height: height * 0.7,
                   width: width,
                   child: Center(child: CircularProgressIndicator()));
             }

             if(snapshot.hasData){
               getNotices(snapshot);
             }

             return Expanded(
               child: Padding(
                 padding: EdgeInsets.symmetric(vertical: 15.0),
                 child: ListView(
                   children: noticesList,
                 ),
               ),
             );
           },
         )
       ],

       ///TODO:here add notice is currently forbidden for teacher
       ///add if feature needed
       ///commented area navigates to notice writer
     ),
   );

  }

}
