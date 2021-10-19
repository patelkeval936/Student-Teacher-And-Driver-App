// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
//
// class LineChartSample2 extends StatefulWidget {
//   @override
//   _LineChartSample2State createState() => _LineChartSample2State();
// }
//
// class _LineChartSample2State extends State<LineChartSample2> {
//
//   List<Color> gradientColors = [
//     // Color(0xff727cf5),
//     // Color(0xff727cf5)
//   // Color(0xffff0000),
// Color(0xff727cf5),
//     Color(0xff727cf5)
//    //  Colors.blue,
//    //  Colors.red,
//    //
//    // // Color(0xff727cf5),
//    //  Color(0xff304ffe),
//    //  Color(0xff304ffe),
//
//   //  Color(0xffff0000),
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return AspectRatio(
//       aspectRatio: 1.70,
//       child: Container(
//         decoration: const BoxDecoration(
//             borderRadius: BorderRadius.all(
//               Radius.circular(18),
//             ),
//             color: Colors.white),
//         child: Padding(
//           padding: const EdgeInsets.only(right: 18.0, left: 12.0, top: 24, bottom: 12),
//           child: LineChart(
//               LineChartData(
//                 titlesData: FlTitlesData(
//                   show: true,
//                   bottomTitles: SideTitles(
//                     showTitles: true,
//                     textStyle:
//                     const TextStyle(color: Colors.black,fontSize: 15),
//                     getTitles: (value) {
//                       switch (value.toInt()) {
//                         case 2:
//                           return 'Mar';
//                         case 5:
//                           return 'Jun';
//                         case 8:
//                           return 'Sep';
//                       }
//                       return '';
//                     },
//
//                     margin: 8,
//                   ),
//                   leftTitles: SideTitles(
//                     showTitles: true,
//                     textStyle: const TextStyle(
//                       color: Colors.black,
//                       //  fontWeight: FontWeight.bold,
//                       fontSize: 15,
//                     ),
//                     getTitles: (value){
//                       switch (value.toInt()) {
//                         case 1:
//                           return '10k';
//                         case 3:
//                           return '30k';
//                         case 5:
//                           return '50k';
//                       }
//                       return '';
//                     },
//                     reservedSize: 28,
//                     margin: 12,
//                   ),
//                 ),
//                 borderData:
//                 FlBorderData(show: false, border: Border.all(color:Colors.white, width: 0)),
//                 minX: 0,
//                 maxX: 11,
//                 minY: 0,
//                 maxY: 6,
//                 lineBarsData: [
//                   LineChartBarData(
//                     show: true,
//                   spots: [
//                     FlSpot(0, 3),
//                     FlSpot(2.6, 2),
//                     FlSpot(4.9, 5),
//                     FlSpot(6.8, 3.1),
//                     FlSpot(8, 4),
//                     FlSpot(9.5, 3),
//                     FlSpot(11, 4),
//                   ],
//                   isCurved: true,
//                   // colors: [Color(0xff417dfc),Color(0xff417dfc)],
//                   // colors: [Colors.yellow,Colors.yellow],
//                    // colors: [Colors.purpleAccent,Colors.purpleAccent],
//                     colors: [Color(0xff845bef),Color(0xff845bef)],
//                   barWidth: 0,
//                   isStrokeCapRound: true,
//                   dotData: FlDotData(
//                     show: false,
//                   ),
//                   belowBarData: BarAreaData(
//                     show: true,
//                     colors: gradientColors.map((color) => color.withOpacity(1)).toList(),
//                   ),
//                 ),
//                 ],
//               )
//           ),
//         ),
//       ),
//     );
//   }
// }