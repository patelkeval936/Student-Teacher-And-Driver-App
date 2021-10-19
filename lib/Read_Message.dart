import 'package:flutter/material.dart';

class ReadMessage extends StatelessWidget {

  final int time;
  final String sub;
  final String writer;
  final String desc;
  static final id = 'ReadMessage';

  const ReadMessage({Key key, this.desc, this.time, this.sub, this.writer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var timeData = DateTime.fromMillisecondsSinceEpoch(time);
   // var timeData = time;
    print('build is running');

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xff101e3d),
        title: Text(
          'MESSAGE',
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
                Text('$writer\n',textAlign: TextAlign.center,style: TextStyle(fontSize: 18),),
                Text('Date:',textAlign: TextAlign.center,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                // Text('${timeData.day}/${timeData.month}/${timeData.year} \n',textAlign: TextAlign.center,style: TextStyle(fontSize: 18),),
                Text('$timeData\n',textAlign: TextAlign.center,style: TextStyle(fontSize: 18),),
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

