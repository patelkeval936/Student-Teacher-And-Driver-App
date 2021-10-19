import 'package:flutter/material.dart';

class ReadNotification extends StatelessWidget {

  final DateTime time;
  final String sub;
  final String writer;
  final String desc;
  static final id = 'ReadNotification';

  const ReadNotification({Key key, this.desc, this.time, this.sub, this.writer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('build is running');

    // var timeData = DateTime.fromMillisecondsSinceEpoch(time);
    var timeData = time;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xff101e3d),
        title: Text(
          'NOTICE',
          style: TextStyle(fontSize: 16.0),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text('From:',textAlign: TextAlign.center,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
               // Text('$writer\n',textAlign: TextAlign.center,style: TextStyle(fontSize: 18),),
                Text('Admin\n',textAlign: TextAlign.center,style: TextStyle(fontSize: 18),),

                Text('Date:',textAlign: TextAlign.center,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                 Text('${timeData.day}/${timeData.month}/${timeData.year}    '
                     '${timeData.hour > 12 ? timeData.hour -12 : timeData.hour}:${timeData.minute}:${timeData.second} ${timeData.hour > 12 ? 'PM' : 'AM'}\n',textAlign: TextAlign.center,style: TextStyle(fontSize: 18),),
                Text('Subject:',textAlign: TextAlign.center,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                Text('$sub\n',textAlign: TextAlign.center,style: TextStyle(fontSize: 18),),
                Text('Description:',textAlign: TextAlign.center,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                Text('$desc\n',textAlign: TextAlign.center,style: TextStyle(fontSize: 18),)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

