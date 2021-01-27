import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:orderingsystem/Components/CLoadingIndicator.dart';
import 'package:orderingsystem/widgets/approve_orders.dart';

class SApproveOrders extends StatefulWidget {
  static const routeName = 'approve-orders';

  @override
  _SApproveOrdersState createState() => _SApproveOrdersState();
}

class _SApproveOrdersState extends State<SApproveOrders> {
  bool _isLoading = false;

  update() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  @override
  Widget build(BuildContext context) {

    CollectionReference orders = FirebaseFirestore.instance
        .collection('Orders');
    
    return StreamBuilder<QuerySnapshot>
      (
        stream: orders.snapshots(includeMetadataChanges: true),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting || _isLoading) {
            return CLoadingIndicator();
          } else {
            return ApproveOrders(snapshot, update);
          }
        });
      // _isLoading
      //   ? CLoadingIndicator()
      //   : Scaffold(
      //       appBar: AppBar(
      //         elevation: 0,
      //         centerTitle: true,
      //         title: CText(text: 'Approve Orders'),
      //         leading: IconButton(
      //           icon: Icon(Icons.arrow_back_ios),
      //           onPressed: () {
      //             Navigator.pop(context);
      //           },
      //         ),
      //       ),
      //       body: RefreshIndicator(
      //         color: fontColor,
      //         displacement: 60,
      //         onRefresh: getData,
      //         child: SingleChildScrollView(
      //           physics: BouncingScrollPhysics(),
      //           child: Padding(
      //             padding: const EdgeInsets.all(15),
      //             child: Column(
      //               children: [
      //                 Row(
      //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                   children: [
      //                     CText(
      //                         text: DateFormat('LLLL D, yyyy')
      //                             .format(DateTime.now())),
      //                     StreamBuilder(
      //                       stream: Stream.periodic(const Duration(seconds: 1)),
      //                       builder: (BuildContext context,
      //                           AsyncSnapshot<dynamic> snapshot) {
      //                         return CText(
      //                             text: DateFormat('hh:mm:ss a')
      //                                 .format(DateTime.now()));
      //                       },
      //                     ),
      //                   ],
      //                 ),
      //                 SizedBox(height: 15),
      //                 ListView.builder(
      //                   physics: NeverScrollableScrollPhysics(),
      //                   shrinkWrap: true,
      //                   itemCount: groupedYetToApproveOrders.length,
      //                   itemBuilder: (context, index) {
      //                     var total = 0;
      //                     groupedYetToApproveOrders.values
      //                         .toList()[index]
      //                         .forEach((element) =>
      //                             total += (element.order[0]['total']));
      //
      //                     var quantity = 0;
      //                     groupedYetToApproveOrders.values
      //                         .toList()[index]
      //                         .forEach((element) =>
      //                             quantity += (element.order[0]['qty']));
      //
      //                     return Stack(
      //                       children: [
      //                         Offstage(
      //                           offstage: isYetToApproveExpanded[index],
      //                           child: ConstrainedBox(
      //                             constraints: BoxConstraints(maxHeight: 600),
      //                             child: ListView.builder(
      //                                 padding: EdgeInsets.only(top: 130),
      //                                 itemCount: _yetToApproveOrders
      //                                     .where((element) =>
      //                                         element.table ==
      //                                         groupedYetToApproveOrders.keys
      //                                             .toList()[index])
      //                                     .toList()
      //                                     .length,
      //                                 itemBuilder: (context, i) {
      //                                   return Container(
      //                                     child: Row(
      //                                       // mainAxisAlignment:
      //                                       //     MainAxisAlignment
      //                                       //         .spaceAround,
      //                                       children: [
      //                                         CContainer(
      //                                           height: 100,
      //                                           borderRadius: BorderRadius.only(
      //                                               topLeft:
      //                                                   Radius.circular(10),
      //                                               bottomLeft:
      //                                                   Radius.circular(10)),
      //                                           child: CText(
      //                                               text: (i + 1).toString()),
      //                                           width: mediaQuery.width * 0.1,
      //                                         ),
      //                                         Expanded(
      //                                           child: CContainer(
      //                                             // margin:
      //                                             //     EdgeInsets.only(right:85),
      //                                             alignment:
      //                                                 Alignment.centerLeft,
      //                                             height: 100,
      //                                             borderRadius:
      //                                                 BorderRadius.only(
      //                                                     topLeft:
      //                                                         Radius.circular(
      //                                                             10),
      //                                                     bottomLeft:
      //                                                         Radius.circular(
      //                                                             10)),
      //                                             child: Column(
      //                                               mainAxisAlignment:
      //                                                   MainAxisAlignment
      //                                                       .center,
      //                                               crossAxisAlignment:
      //                                                   CrossAxisAlignment
      //                                                       .start,
      //                                               children: [
      //                                                 CText(
      //                                                   text: _yetToApproveOrders
      //                                                       .where((element) =>
      //                                                           element.table ==
      //                                                           groupedYetToApproveOrders
      //                                                                   .keys
      //                                                                   .toList()[
      //                                                               index])
      //                                                       .toList()[i]
      //                                                       .order[0]['foodName'],
      //                                                   fontWeight:
      //                                                       FontWeight.bold,
      //                                                 ),
      //                                                 SizedBox(height: 5),
      //                                                 CText(
      //                                                   text: _yetToApproveOrders
      //                                                           .where((element) =>
      //                                                               element
      //                                                                   .table ==
      //                                                               groupedYetToApproveOrders
      //                                                                       .keys
      //                                                                       .toList()[
      //                                                                   index])
      //                                                           .toList()[i]
      //                                                           .time ??
      //                                                       '-',
      //                                                   maxLines: 2,
      //                                                   fontWeight:
      //                                                       FontWeight.normal,
      //                                                 ),
      //                                                 SizedBox(height: 5),
      //                                                 CText(
      //                                                   text: _yetToApproveOrders
      //                                                           .where((element) =>
      //                                                               element
      //                                                                   .table ==
      //                                                               groupedYetToApproveOrders
      //                                                                       .keys
      //                                                                       .toList()[
      //                                                                   index])
      //                                                           .toList()[i]
      //                                                           .order[0]
      //                                                               ['total']
      //                                                           .toString() +
      //                                                       'Rs',
      //                                                   fontWeight:
      //                                                       FontWeight.bold,
      //                                                 ),
      //                                               ],
      //                                             ),
      //                                           ),
      //                                         ),
      //                                         Align(
      //                                           child: CContainer(
      //                                               borderRadius:
      //                                                   BorderRadius.only(
      //                                                       topLeft: Radius
      //                                                           .circular(10),
      //                                                       bottomLeft:
      //                                                           Radius.circular(
      //                                                               10)),
      //                                               height: 100,
      //                                               width:
      //                                                   mediaQuery.width * 0.1,
      //                                               child: CText(
      //                                                 text: _yetToApproveOrders
      //                                                     .where((element) =>
      //                                                         element.table ==
      //                                                         groupedYetToApproveOrders
      //                                                                 .keys
      //                                                                 .toList()[
      //                                                             index])
      //                                                     .toList()[i]
      //                                                     .order[0]['qty']
      //                                                     .toString(),
      //                                               )),
      //                                         ),
      //                                       ],
      //                                     ),
      //                                   );
      //                                 }),
      //                           ),
      //                         ),
      //                         _yetToApproveOrders.isNotEmpty
      //                             ? GestureDetector(
      //                                 onTap: () {
      //                                   setState(() {
      //                                     isYetToApproveExpanded[index] =
      //                                         !isYetToApproveExpanded[index];
      //                                   });
      //                                 },
      //                                 child: CContainer(
      //                                   margin: EdgeInsets.only(bottom: 20),
      //                                   height: 100,
      //                                   borderRadius: BorderRadius.circular(10),
      //                                   child: Row(
      //                                     children: [
      //                                       CContainer(
      //                                         height: null,
      //                                         borderRadius: BorderRadius.only(
      //                                             topLeft: Radius.circular(10),
      //                                             bottomLeft:
      //                                                 Radius.circular(10)),
      //                                         child: CText(
      //                                             text:
      //                                                 groupedYetToApproveOrders
      //                                                     .keys
      //                                                     .toList()[index]),
      //                                         width: mediaQuery.width * 0.1,
      //                                       ),
      //                                       Expanded(
      //                                         child: CContainer(
      //                                           padding: EdgeInsets.all(8),
      //                                           alignment: Alignment.centerLeft,
      //                                           height: 100,
      //                                           borderRadius: BorderRadius.only(
      //                                               topLeft:
      //                                                   Radius.circular(10),
      //                                               bottomLeft:
      //                                                   Radius.circular(10)),
      //                                           child: Column(
      //                                             mainAxisAlignment:
      //                                                 MainAxisAlignment.center,
      //                                             crossAxisAlignment:
      //                                                 CrossAxisAlignment.start,
      //                                             children: [
      //                                               CText(
      //                                                 text:
      //                                                     groupedYetToApproveOrders
      //                                                         .values
      //                                                         .toList()[index]
      //                                                             [0]
      //                                                         .orderId.toString(),
      //                                                 fontWeight:
      //                                                     FontWeight.bold,
      //                                               ),
      //                                               SizedBox(height: 5),
      //                                               CText(
      //                                                 text:
      //                                                     // groupedYetToApproveOrders.values.toList()[index]
      //                                                     //         .order['moreInfo'] ??
      //                                                     '-',
      //                                                 maxLines: 2,
      //                                                 fontWeight:
      //                                                     FontWeight.normal,
      //                                               ),
      //                                               SizedBox(height: 5),
      //                                               CText(
      //                                                 text: '$total Rs',
      //                                                 fontWeight:
      //                                                     FontWeight.bold,
      //                                               ),
      //                                             ],
      //                                           ),
      //                                         ),
      //                                       ),
      //                                       CContainer(
      //                                           borderRadius: BorderRadius.only(
      //                                               topLeft:
      //                                                   Radius.circular(10),
      //                                               bottomLeft:
      //                                                   Radius.circular(10)),
      //                                           height: null,
      //                                           width: mediaQuery.width * 0.1,
      //                                           child: CText(
      //                                             text: quantity.toString(),
      //                                           )),
      //                                       GestureDetector(
      //                                         onTap: () async {
      //                                           setState(() {
      //                                             _isLoading = true;
      //                                           });
      //                                           groupedYetToApproveOrders.values
      //                                               .forEach((element) {
      //                                             element.forEach((ele) async {
      //                                               await Orders().updateOrder(
      //                                                   ele.docId, true);
      //                                             });
      //                                           });
      //                                           getData();
      //                                         },
      //                                         child: CContainer(
      //                                           height: null,
      //                                           backgroundColor: fontColor,
      //                                           borderRadius:
      //                                               BorderRadius.circular(10),
      //                                           width: mediaQuery.width * 0.22,
      //                                           alignment: Alignment.center,
      //                                           child: CText(
      //                                             text: 'Approve',
      //                                             textColor: Colors.white,
      //                                           ),
      //                                         ),
      //                                       )
      //                                     ],
      //                                   ),
      //                                 ),
      //                               )
      //                             : Padding(
      //                                 padding: const EdgeInsets.symmetric(
      //                                     vertical: 25),
      //                                 child: CText(
      //                                   text: 'No new orders',
      //                                 ),
      //                               ),
      //                       ],
      //                     );
      //                   },
      //                 )
      //               ],
      //             ),
      //           ),
      //         ),
      //       ),
      //       bottomNavigationBar: DraggableScrollableSheet(
      //         expand: false,
      //         minChildSize: 0.07,
      //         maxChildSize: 0.85,
      //         initialChildSize: 0.07,
      //         builder: (context, controller) {
      //           return SingleChildScrollView(
      //             controller: controller,
      //             child: Column(
      //               children: [
      //                 Stack(
      //                   alignment: Alignment.center,
      //                   children: [
      //                     Container(
      //                       height: mediaQuery.height * 0.07,
      //                       decoration: BoxDecoration(
      //                           color: fontColor,
      //                           borderRadius: BorderRadius.only(
      //                               topLeft: Radius.circular(10),
      //                               topRight: Radius.circular(10))),
      //                     ),
      //                     Container(
      //                       height: mediaQuery.height * 0.006,
      //                       width: mediaQuery.width * 0.25,
      //                       decoration: BoxDecoration(
      //                         color: Colors.white,
      //                         borderRadius: BorderRadius.circular(50),
      //                       ),
      //                     ),
      //                   ],
      //                 ),
      //                 _approvedOrders.length != 0
      //                     ? ListView.builder(
      //                         padding: const EdgeInsets.all(15),
      //                         physics: NeverScrollableScrollPhysics(),
      //                         shrinkWrap: true,
      //                         itemCount: groupedApprovedOrders.length,
      //                         itemBuilder: (context, index) {
      //                           var total = 0;
      //                           groupedApprovedOrders.values
      //                               .toList()[index]
      //                               .forEach((element) =>
      //                                   total += (element.order[0]['total']));
      //
      //                           var quantity = 0;
      //                           groupedApprovedOrders.values
      //                               .toList()[index]
      //                               .forEach((element) =>
      //                                   quantity += (element.order[0]['qty']));
      //                           return Stack(
      //                             children: [
      //                               Offstage(
      //                                 offstage: isApprovedExpanded[index],
      //                                 child: ConstrainedBox(
      //                                   constraints:
      //                                       BoxConstraints(maxHeight: 600),
      //                                   child: ListView.builder(
      //                                       padding: EdgeInsets.only(top: 130),
      //                                       itemCount: _approvedOrders
      //                                           .where((element) =>
      //                                               element.table ==
      //                                               groupedApprovedOrders
      //                                                   .keys
      //                                                   .toList()[index])
      //                                           .toList()
      //                                           .length,
      //                                       itemBuilder: (context, i) {
      //                                         return Container(
      //                                           child: Row(
      //                                             // mainAxisAlignment:
      //                                             //     MainAxisAlignment
      //                                             //         .spaceAround,
      //                                             children: [
      //                                               CContainer(
      //                                                 height: 100,
      //                                                 borderRadius:
      //                                                     BorderRadius.only(
      //                                                         topLeft: Radius
      //                                                             .circular(10),
      //                                                         bottomLeft: Radius
      //                                                             .circular(
      //                                                                 10)),
      //                                                 child: CText(
      //                                                     text: (i + 1)
      //                                                         .toString()),
      //                                                 width: mediaQuery.width *
      //                                                     0.1,
      //                                               ),
      //                                               Expanded(
      //                                                 child: CContainer(
      //                                                   // margin:
      //                                                   //     EdgeInsets.only(right:85),
      //                                                   alignment: Alignment
      //                                                       .centerLeft,
      //                                                   height: 100,
      //                                                   borderRadius:
      //                                                       BorderRadius.only(
      //                                                           topLeft: Radius
      //                                                               .circular(
      //                                                                   10),
      //                                                           bottomLeft: Radius
      //                                                               .circular(
      //                                                                   10)),
      //                                                   child: Column(
      //                                                     mainAxisAlignment:
      //                                                         MainAxisAlignment
      //                                                             .center,
      //                                                     crossAxisAlignment:
      //                                                         CrossAxisAlignment
      //                                                             .start,
      //                                                     children: [
      //                                                       CText(
      //                                                         text: _approvedOrders
      //                                                             .where((element) =>
      //                                                                 element
      //                                                                     .table ==
      //                                                                 groupedApprovedOrders
      //                                                                     .keys
      //                                                                     .toList()[index])
      //                                                             .toList()[i]
      //                                                             .order[0]['foodName'],
      //                                                         fontWeight:
      //                                                             FontWeight
      //                                                                 .bold,
      //                                                       ),
      //                                                       SizedBox(height: 5),
      //                                                       CText(
      //                                                         text: _approvedOrders
      //                                                                 .where((element) =>
      //                                                                     element
      //                                                                         .table ==
      //                                                                     groupedApprovedOrders
      //                                                                         .keys
      //                                                                         .toList()[index])
      //                                                                 .toList()[i]
      //                                                                 .time ??
      //                                                             '-',
      //                                                         maxLines: 2,
      //                                                         fontWeight:
      //                                                             FontWeight
      //                                                                 .normal,
      //                                                       ),
      //                                                       SizedBox(height: 5),
      //                                                       CText(
      //                                                         text: _approvedOrders
      //                                                                 .where((element) =>
      //                                                                     element
      //                                                                         .table ==
      //                                                                     groupedApprovedOrders.keys.toList()[
      //                                                                         index])
      //                                                                 .toList()[
      //                                                                     i]
      //                                                                 .order[0][
      //                                                                     'total']
      //                                                                 .toString() +
      //                                                             'Rs',
      //                                                         fontWeight:
      //                                                             FontWeight
      //                                                                 .bold,
      //                                                       ),
      //                                                     ],
      //                                                   ),
      //                                                 ),
      //                                               ),
      //                                               Align(
      //                                                 child: CContainer(
      //                                                     borderRadius:
      //                                                         BorderRadius.only(
      //                                                             topLeft: Radius
      //                                                                 .circular(
      //                                                                     10),
      //                                                             bottomLeft:
      //                                                                 Radius.circular(
      //                                                                     10)),
      //                                                     height: 100,
      //                                                     width:
      //                                                         mediaQuery.width *
      //                                                             0.1,
      //                                                     child: CText(
      //                                                       text: _approvedOrders
      //                                                           .where((element) =>
      //                                                               element
      //                                                                   .table ==
      //                                                               groupedApprovedOrders
      //                                                                       .keys
      //                                                                       .toList()[
      //                                                                   index])
      //                                                           .toList()[i]
      //                                                           .order[0]['qty']
      //                                                           .toString(),
      //                                                     )),
      //                                               ),
      //                                             ],
      //                                           ),
      //                                         );
      //                                       }),
      //                                 ),
      //                               ),
      //                               _approvedOrders.isNotEmpty
      //                                   ? GestureDetector(
      //                                       onTap: () {
      //                                         setState(() {
      //                                           isApprovedExpanded[index] =
      //                                               !isApprovedExpanded[index];
      //                                         });
      //                                       },
      //                                       child: CContainer(
      //                                         margin:
      //                                             EdgeInsets.only(bottom: 20),
      //                                         height: 100,
      //                                         borderRadius:
      //                                             BorderRadius.circular(10),
      //                                         child: Row(
      //                                           children: [
      //                                             CContainer(
      //                                               height: null,
      //                                               borderRadius:
      //                                                   BorderRadius.only(
      //                                                       topLeft: Radius
      //                                                           .circular(10),
      //                                                       bottomLeft:
      //                                                           Radius.circular(
      //                                                               10)),
      //                                               child: CText(
      //                                                   text:
      //                                                       groupedApprovedOrders
      //                                                               .keys
      //                                                               .toList()[
      //                                                           index]),
      //                                               width:
      //                                                   mediaQuery.width * 0.1,
      //                                             ),
      //                                             Expanded(
      //                                               child: CContainer(
      //                                                 padding:
      //                                                     EdgeInsets.all(8),
      //                                                 alignment:
      //                                                     Alignment.centerLeft,
      //                                                 height: 100,
      //                                                 borderRadius:
      //                                                     BorderRadius.only(
      //                                                         topLeft: Radius
      //                                                             .circular(10),
      //                                                         bottomLeft: Radius
      //                                                             .circular(
      //                                                                 10)),
      //                                                 child: Column(
      //                                                   mainAxisAlignment:
      //                                                       MainAxisAlignment
      //                                                           .center,
      //                                                   crossAxisAlignment:
      //                                                       CrossAxisAlignment
      //                                                           .start,
      //                                                   children: [
      //                                                     CText(
      //                                                       text: groupedApprovedOrders.values.toList()[index][0].orderId.toString(),
      //                                                       fontWeight:
      //                                                           FontWeight.bold,
      //                                                     ),
      //                                                     SizedBox(height: 5),
      //                                                     CText(
      //                                                       text:
      //                                                           // groupedYetToApproveOrders.values.toList()[index]
      //                                                           //         .order['moreInfo'] ??
      //                                                           '-',
      //                                                       maxLines: 2,
      //                                                       fontWeight:
      //                                                           FontWeight
      //                                                               .normal,
      //                                                     ),
      //                                                     SizedBox(height: 5),
      //                                                     CText(
      //                                                       text: '$total Rs',
      //                                                       fontWeight:
      //                                                           FontWeight.bold,
      //                                                     ),
      //                                                   ],
      //                                                 ),
      //                                               ),
      //                                             ),
      //                                             CContainer(
      //                                                 borderRadius:
      //                                                     BorderRadius.only(
      //                                                         topLeft: Radius
      //                                                             .circular(10),
      //                                                         bottomLeft: Radius
      //                                                             .circular(
      //                                                                 10)),
      //                                                 height: null,
      //                                                 width: mediaQuery.width *
      //                                                     0.1,
      //                                                 child: CText(
      //                                                   text:
      //                                                       quantity.toString(),
      //                                                 )),
      //                                             GestureDetector(
      //                                               onTap: () async {
      //                                                 setState(() {
      //                                                   _isLoading = true;
      //                                                 });
      //                                                 groupedApprovedOrders
      //                                                     .values
      //                                                     .forEach((element) {
      //                                                   element.forEach(
      //                                                       (ele) async {
      //                                                     await Orders()
      //                                                         .updateOrder(
      //                                                             ele.docId,
      //                                                             false);
      //                                                   });
      //                                                 });
      //                                                 getData();
      //                                               },
      //                                               child: Container(
      //                                                 height: null,
      //                                                 decoration: BoxDecoration(
      //                                                   boxShadow: [
      //                                                     BoxShadow(
      //                                                       color: Colors.white,
      //                                                       offset:
      //                                                           Offset(-3, -3),
      //                                                       blurRadius: 4,
      //                                                     ),
      //                                                   ],
      //                                                   gradient:
      //                                                       LinearGradient(
      //                                                     begin: Alignment
      //                                                         .bottomLeft,
      //                                                     end: Alignment
      //                                                         .topRight,
      //                                                     colors: <Color>[
      //                                                       Color(0xFFFF7D55),
      //                                                       Color(0xFFF4197E),
      //                                                     ],
      //                                                   ),
      //                                                   borderRadius:
      //                                                       BorderRadius
      //                                                           .circular(10),
      //                                                 ),
      //                                                 width: mediaQuery.width *
      //                                                     0.22,
      //                                                 alignment:
      //                                                     Alignment.center,
      //                                                 child: CText(
      //                                                   text: 'Remove',
      //                                                   textColor: Colors.white,
      //                                                 ),
      //                                               ),
      //                                             )
      //                                           ],
      //                                         ),
      //                                       ),
      //                                     )
      //                                   : Padding(
      //                                       padding: const EdgeInsets.symmetric(
      //                                           vertical: 25),
      //                                       child: CText(
      //                                         text: 'No new approved orders',
      //                                       ),
      //                                     ),
      //                             ],
      //                           );
      //                         },
      //                       )
      //                     : Padding(
      //                         padding: const EdgeInsets.symmetric(vertical: 25),
      //                         child: CText(
      //                           text: 'No new approved orders',
      //                         ),
      //                       ),
      //               ],
      //             ),
      //           );
      //         },
      //       ),
      //     );
  }
}
