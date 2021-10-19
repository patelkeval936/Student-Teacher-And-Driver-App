import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StudentFeesPage extends StatefulWidget {
  final studentId;
  final studentClass;

  const StudentFeesPage({Key key, this.studentId, this.studentClass}) : super(key: key);

  @override
  _StudentFeesPageState createState() => _StudentFeesPageState();
}

double height;
double width;

List<Widget> cardList = [];

class _StudentFeesPageState extends State<StudentFeesPage> {

  int totalFees = 0;
  int paidFees = 0;
  int dueFees = 0;

  getPaymentCards() {

    totalFees = 0;
    paidFees = 0;
    dueFees = 0;

    String std = '${widget.studentClass.toString().split(' ').first}';
    String div = '${widget.studentClass.toString().split(' ').last}';
    String id = '${widget.studentId.toString()}';

    FirebaseFirestore.instance.doc('classData/studentFees').get().then((value){
      List feesList = [];
      feesList = value.data()[std];
      
      int index = feesList.indexWhere((element) => element['section'] == div);

      setState(() {
        totalFees = feesList[index]['fees'];
      });

    }).whenComplete((){


      FirebaseFirestore.instance.doc('year/$currentAcademicYear/Student/'
          '$std$div'
          '/generalData/$id').get().then((snapshot){

            setState(() {
              cardList = [];
            });

        List paymentParts = [];

        try{

          paymentParts = snapshot.data()['feesData'];

        }catch(e){
          print(e);
        }

        for (int i = paymentParts.length-1; i >=0; i--) {

          setState(() {
            paidFees = paidFees +  paymentParts[i]['amount'];
            dueFees = totalFees - paidFees;
          });

          DateTime dateOfPayment = paymentParts[i]['date'].toDate();

          var card = Card(
              shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
              margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
              elevation:4.0,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
                height: height * 0.14,
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: height * 0.14,
                      width: width * 0.55,
                      child: Center(child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text('Payer : ${paymentParts[i]['payerName']}',style: TextStyle(fontSize: 12,color: Colors.grey.shade700),textAlign: TextAlign.center,),
                          Text('Mobile No : ${paymentParts[i]['mobileNum']}',style: TextStyle(fontSize: 12,color: Colors.grey.shade700),textAlign: TextAlign.center,),
                          Text('Ref. No : ${paymentParts[i]['referenceNum']}',style: TextStyle(fontSize: 12,color: Colors.grey.shade700),textAlign: TextAlign.center,),
                        ],
                      ),),),
                    Container(
                      height: height * 0.14,
                      width: width * 0.35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.orangeAccent,
                      ),
                      child:
                      Center(
                          child:
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text('Rs. ${paymentParts[i]['amount']}',style: TextStyle(fontSize: 17,color: Colors.white)),
                              Text('${dateOfPayment.day}/${dateOfPayment.month}/${dateOfPayment.year}',style: TextStyle(color: Colors.white),),
                            ],
                          )
                      ),
                    )
                  ],
                ),
              )
          );

          setState(() {
            cardList.add(card);
          });

        }

      });

    });

  }

  String currentAcademicYear;

  void currentYearGetter() {
    FirebaseFirestore.instance.doc('school/academic years').get().then((value) {
      var data = value.data();
      setState(() {
        currentAcademicYear = data['currentAcademicYears']['name'];
      });
    }).whenComplete((){
      getPaymentCards();
    });
  }

  @override
  void initState() {
    totalFees = 0;
    paidFees = 0;
    dueFees = 0;
    currentYearGetter();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    print('build is running');


    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xff101e3d),
        title: Text(
          'Fees Payments',
          style: TextStyle(fontSize: 16.0),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 30,),
          Container(
            height: height * 0.12,
            width: width * 0.6,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey.shade200,
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('Total Fees  :  Rs. $totalFees',style: TextStyle(fontSize: 17,color: Colors.grey.shade700)),
                  Text('Paid Fees :  Rs. $paidFees',style: TextStyle(fontSize: 17,color: Colors.grey.shade700)),
                  Text('Due Fees :  Rs. $dueFees',style: TextStyle(fontSize: 17,color: Colors.grey.shade700)),
                ],
              ),
            ),
          ),
          SizedBox(height: 30,),
          Expanded(
            child: Container(
              child: ListView(
                children: cardList,
              ),
            ),
          )
        ],
      ),
    );
  }
}
