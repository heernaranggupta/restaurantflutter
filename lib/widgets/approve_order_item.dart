// import 'package:flutter/material.dart';
// import 'package:orderingsystem/Components/CContainer.dart';
// import 'package:orderingsystem/Components/CText.dart';
// import 'package:orderingsystem/Models/Orders.dart';
//
// import '../constants.dart';
//
// class ApproveOrderItem extends StatefulWidget {
//   @override
//   _ApproveOrderItemState createState() => _ApproveOrderItemState();
// }
//
// class _ApproveOrderItemState extends State<ApproveOrderItem> {
//   @override
//   Widget build(BuildContext context) {
//
//     final mediaQuery = MediaQuery.of(context).size;
//     return Column(
//       children: [
//         Stack(
//           children: [
//             Offstage(
//               offstage: isExpanded,
//               child: buildGridContainer(
//                 child: CGridView(
//                     itemCount: _choosentiming.length,
//                     padding: EdgeInsets.only(
//                         left: 15,
//                         right: 15,
//                         top: 65,
//                         bottom: 10),
//                     itemBuilder: (context, index) {
//                       return GestureDetector(
//                         onTap: () {
//                           setState(() {
//                             _choosentiming.update(
//                                 _choosentiming.keys
//                                     .elementAt(index),
//                                     (value) {
//                                   return value = !value;
//                                 });
//                             _timingToDisplay.clear();
//                             _choosentiming
//                                 .forEach((key, value) {
//                               if (value == true) {
//                                 _timingToDisplay
//                                     .putIfAbsent(
//                                     key, () => value);
//                               }
//                             });
//                           });
//                         },
//                         child: CContainer(
//                           borderRadius:
//                           BorderRadius.circular(30),
//                           isBoxShadow: false,
//                           backgroundColor: _choosentiming
//                               .values
//                               .elementAt(index)
//                               ? fontColor
//                               : appColor,
//                           child: CText(
//                             fontSize: 13,
//                             text: _choosentiming.keys
//                                 .elementAt(index),
//                             textColor: _choosentiming
//                                 .values
//                                 .elementAt(index)
//                                 ? Colors.white
//                                 : fontColor,
//                           ),
//                         ),
//                       );
//                     }),
//               ),
//             ),
//             buildCContainer(
//               child: CDropdownRow(
//                 title: 'Timing',
//                 codePoint: 0xe901,
//                 isExpanded: isTimingExpanded,
//                 fontFamily: 'timingFilterIcon',
//                 onTap: () {
//                   setState(() {
//                     isTimingExpanded = !isTimingExpanded;
//                   });
//                 },
//               ),
//             )
//           ],
//         ),
//         CContainer(
//           margin: EdgeInsets.only(bottom: 20),
//           height: 100,
//           borderRadius: BorderRadius.circular(10),
//           child: Row(
//             children: [
//               CContainer(
//                 height: null,
//                 borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(10),
//                     bottomLeft: Radius.circular(10)),
//                 child: CText(
//                     text: groupedYetToApproveOrders.keys
//                         .toList()[index]),
//                 width: mediaQuery.width * 0.1,
//               ),
//               Expanded(
//                 child: CContainer(
//                   padding: EdgeInsets.all(8),
//                   alignment: Alignment.centerLeft,
//                   height: 100,
//                   borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(10),
//                       bottomLeft: Radius.circular(10)),
//                   child: Column(
//                     mainAxisAlignment:
//                     MainAxisAlignment.center,
//                     crossAxisAlignment:
//                     CrossAxisAlignment.start,
//                     children: [
//                       CText(
//                         text: '#4300043',
//                         // groupedYetToApproveOrders.values.toList()[index]
//                         //     .order['foodName'],
//                         fontWeight: FontWeight.bold,
//                       ),
//                       SizedBox(height: 5),
//                       CText(
//                         text:
//                         // groupedYetToApproveOrders.values.toList()[index]
//                         //         .order['moreInfo'] ??
//                         '-',
//                         maxLines: 2,
//                         fontWeight: FontWeight.normal,
//                       ),
//                       SizedBox(height: 5),
//                       CText(
//                         text: '$total Rs',
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               CContainer(
//                   borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(10),
//                       bottomLeft: Radius.circular(10)),
//                   height: null,
//                   width: mediaQuery.width * 0.1,
//                   child: CText(
//                     text: quantity.toString(),
//                   )),
//               CContainer(
//                 height: null,
//                 backgroundColor: fontColor,
//                 borderRadius: BorderRadius.circular(10),
//                 width: mediaQuery.width * 0.22,
//                 alignment: Alignment.center,
//                 child: GestureDetector(
//                   child: CText(
//                     text: 'Approve',
//                     textColor: Colors.white,
//                   ),
//                   onTap: () async {
//                     setState(() {
//                       _isLoading = true;
//                     });
//                     await Orders().updateOrder(
//                         _yetToApproveOrders[index].docId,
//                         true);
//                     getData();
//                   },
//                 ),
//               )
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
