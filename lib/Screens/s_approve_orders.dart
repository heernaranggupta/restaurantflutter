import 'package:flutter/material.dart';
import 'package:orderingsystem/Components/CContainer.dart';
import 'package:orderingsystem/Components/CLoadingIndicator.dart';
import 'package:orderingsystem/Components/CText.dart';
import 'package:intl/intl.dart';
import 'package:orderingsystem/Models/Orders.dart';
import 'package:orderingsystem/constants.dart';
import 'package:collection/collection.dart';

class SApproveOrders extends StatefulWidget {
  static const routeName = 'approve-orders';

  @override
  _SApproveOrdersState createState() => _SApproveOrdersState();
}

class _SApproveOrdersState extends State<SApproveOrders> {
  bool _isLoading = false;
  List<Orders> _ordersList = [];
  List<Orders> _approvedOrders = [];
  List<Orders> _yetToApproveOrders = [];
  Map groupedApprovedOrders;
  Map groupedYetToApproveOrders;
  List<bool> isYetToApproveExpanded = [];
  List<bool> isApprovedExpanded = [];

  @override
  void initState() {
    getData();
    super.initState();
  }

  Future<dynamic> getData() async {
    setState(() {
      _isLoading = true;
    });
    _ordersList.clear();
    _approvedOrders.clear();
    _yetToApproveOrders.clear();

    _ordersList = await Orders().getOrders().catchError((error) {
      print(error);
    });

    _ordersList.forEach(
      (element) => (element.isApprove)
          ? _approvedOrders.add(element)
          : _yetToApproveOrders.add(element),
    );

    groupedApprovedOrders = groupBy(_approvedOrders, (Orders order) {
      return order.table;
    });

    groupedYetToApproveOrders = groupBy(_yetToApproveOrders, (Orders order) {
      return order.table;
    });

    isYetToApproveExpanded =
        List.filled(groupedYetToApproveOrders.keys.toList().length, true);

    isApprovedExpanded =
        List.filled(groupedApprovedOrders.keys.toList().length, true);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;

    return _isLoading
        ? CLoadingIndicator()
        : Scaffold(
            appBar: AppBar(
              elevation: 0,
              centerTitle: true,
              title: CText(text: 'Approve Orders'),
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            body: RefreshIndicator(
              color: fontColor,
              displacement: 60,
              onRefresh: getData,
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CText(
                              text: DateFormat('LLLL D, yyyy')
                                  .format(DateTime.now())),
                          StreamBuilder(
                            stream: Stream.periodic(const Duration(seconds: 1)),
                            builder: (BuildContext context,
                                AsyncSnapshot<dynamic> snapshot) {
                              return CText(
                                  text: DateFormat('hh:mm:ss a')
                                      .format(DateTime.now()));
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: groupedYetToApproveOrders.length,
                        itemBuilder: (context, index) {
                          var total = 0;
                          groupedYetToApproveOrders.values
                              .toList()[index]
                              .forEach((element) =>
                                  total += (element.order[0]['total']));

                          var quantity = 0;
                          groupedYetToApproveOrders.values
                              .toList()[index]
                              .forEach((element) =>
                                  quantity += (element.order[0]['qty']));

                          return Stack(
                            children: [
                              Offstage(
                                offstage: isYetToApproveExpanded[index],
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(maxHeight: 600),
                                  child: ListView.builder(
                                      padding: EdgeInsets.only(top: 130),
                                      itemCount: _yetToApproveOrders
                                          .where((element) =>
                                              element.table ==
                                              groupedYetToApproveOrders.keys
                                                  .toList()[index])
                                          .toList()
                                          .length,
                                      itemBuilder: (context, i) {
                                        return Container(
                                          child: Row(
                                            // mainAxisAlignment:
                                            //     MainAxisAlignment
                                            //         .spaceAround,
                                            children: [
                                              CContainer(
                                                height: 100,
                                                borderRadius: BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(10),
                                                    bottomLeft:
                                                        Radius.circular(10)),
                                                child: CText(
                                                    text: (i + 1).toString()),
                                                width: mediaQuery.width * 0.1,
                                              ),
                                              Expanded(
                                                child: CContainer(
                                                  // margin:
                                                  //     EdgeInsets.only(right:85),
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  height: 100,
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  10),
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  10)),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      CText(
                                                        text: _yetToApproveOrders
                                                            .where((element) =>
                                                                element.table ==
                                                                groupedYetToApproveOrders
                                                                        .keys
                                                                        .toList()[
                                                                    index])
                                                            .toList()[i]
                                                            .order[0]['foodName'],
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                      SizedBox(height: 5),
                                                      CText(
                                                        text: _yetToApproveOrders
                                                                .where((element) =>
                                                                    element
                                                                        .table ==
                                                                    groupedYetToApproveOrders
                                                                            .keys
                                                                            .toList()[
                                                                        index])
                                                                .toList()[i]
                                                                .time ??
                                                            '-',
                                                        maxLines: 2,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                      ),
                                                      SizedBox(height: 5),
                                                      CText(
                                                        text: _yetToApproveOrders
                                                                .where((element) =>
                                                                    element
                                                                        .table ==
                                                                    groupedYetToApproveOrders
                                                                            .keys
                                                                            .toList()[
                                                                        index])
                                                                .toList()[i]
                                                                .order[0]
                                                                    ['total']
                                                                .toString() +
                                                            'Rs',
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Align(
                                                child: CContainer(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            topLeft: Radius
                                                                .circular(10),
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    10)),
                                                    height: 100,
                                                    width:
                                                        mediaQuery.width * 0.1,
                                                    child: CText(
                                                      text: _yetToApproveOrders
                                                          .where((element) =>
                                                              element.table ==
                                                              groupedYetToApproveOrders
                                                                      .keys
                                                                      .toList()[
                                                                  index])
                                                          .toList()[i]
                                                          .order[0]['qty']
                                                          .toString(),
                                                    )),
                                              ),
                                            ],
                                          ),
                                        );
                                      }),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isYetToApproveExpanded[index] =
                                        !isYetToApproveExpanded[index];
                                  });
                                },
                                child: CContainer(
                                  margin: EdgeInsets.only(bottom: 20),
                                  height: 100,
                                  borderRadius: BorderRadius.circular(10),
                                  child: Row(
                                    children: [
                                      CContainer(
                                        height: null,
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            bottomLeft: Radius.circular(10)),
                                        child: CText(
                                            text: groupedYetToApproveOrders.keys
                                                .toList()[index]),
                                        width: mediaQuery.width * 0.1,
                                      ),
                                      Expanded(
                                        child: CContainer(
                                          padding: EdgeInsets.all(8),
                                          alignment: Alignment.centerLeft,
                                          height: 100,
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              bottomLeft: Radius.circular(10)),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              CText(
                                                text: '#4300043',
                                                // groupedYetToApproveOrders.values.toList()[index]
                                                //     .order['foodName'],
                                                fontWeight: FontWeight.bold,
                                              ),
                                              SizedBox(height: 5),
                                              CText(
                                                text:
                                                    // groupedYetToApproveOrders.values.toList()[index]
                                                    //         .order['moreInfo'] ??
                                                    '-',
                                                maxLines: 2,
                                                fontWeight: FontWeight.normal,
                                              ),
                                              SizedBox(height: 5),
                                              CText(
                                                text: '$total Rs',
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      CContainer(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              bottomLeft: Radius.circular(10)),
                                          height: null,
                                          width: mediaQuery.width * 0.1,
                                          child: CText(
                                            text: quantity.toString(),
                                          )),
                                      CContainer(
                                        height: null,
                                        backgroundColor: fontColor,
                                        borderRadius: BorderRadius.circular(10),
                                        width: mediaQuery.width * 0.22,
                                        alignment: Alignment.center,
                                        child: GestureDetector(
                                          child: CText(
                                            text: 'Approve',
                                            textColor: Colors.white,
                                          ),
                                          onTap: () async {
                                            setState(() {
                                              _isLoading = true;
                                            });
                                            await Orders().updateOrder(
                                                _yetToApproveOrders[index]
                                                    .docId,
                                                true);
                                            getData();
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
            bottomNavigationBar: DraggableScrollableSheet(
              expand: false,
              minChildSize: 0.07,
              maxChildSize: 0.85,
              initialChildSize: 0.07,
              builder: (context, controller) {
                return SingleChildScrollView(
                  controller: controller,
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            height: mediaQuery.height * 0.07,
                            decoration: BoxDecoration(
                                color: fontColor,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10))),
                          ),
                          Container(
                            height: mediaQuery.height * 0.006,
                            width: mediaQuery.width * 0.25,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                        ],
                      ),
                      _approvedOrders.length != 0
                          ? ListView.builder(
                              padding: const EdgeInsets.all(15),
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: groupedApprovedOrders.length,
                              itemBuilder: (context, index) {
                                var total = 0;
                                groupedApprovedOrders.values
                                    .toList()[index]
                                    .forEach((element) =>
                                        total += (element.order[0]['total']));

                                var quantity = 0;
                                groupedApprovedOrders.values
                                    .toList()[index]
                                    .forEach((element) =>
                                        quantity += (element.order[0]['qty']));
                                return Stack(
                                  children: [
                                    Offstage(
                                      offstage: isYetToApproveExpanded[index],
                                      child: ConstrainedBox(
                                        constraints:
                                            BoxConstraints(maxHeight: 600),
                                        child: ListView.builder(
                                            padding: EdgeInsets.only(top: 130),
                                            itemCount: _yetToApproveOrders
                                                .where((element) =>
                                                    element.table ==
                                                    groupedYetToApproveOrders
                                                        .keys
                                                        .toList()[index])
                                                .toList()
                                                .length,
                                            itemBuilder: (context, i) {
                                              print(_yetToApproveOrders
                                                  .where((element) =>
                                                      element.table ==
                                                      groupedYetToApproveOrders
                                                          .keys
                                                          .toList()[index])
                                                  .toList()[i]
                                                  .order);
                                              return Container(
                                                child: Row(
                                                  // mainAxisAlignment:
                                                  //     MainAxisAlignment
                                                  //         .spaceAround,
                                                  children: [
                                                    CContainer(
                                                      height: 100,
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              topLeft: Radius
                                                                  .circular(10),
                                                              bottomLeft: Radius
                                                                  .circular(
                                                                      10)),
                                                      child: CText(
                                                          text: (i + 1)
                                                              .toString()),
                                                      width: mediaQuery.width *
                                                          0.1,
                                                    ),
                                                    Expanded(
                                                      child: CContainer(
                                                        // margin:
                                                        //     EdgeInsets.only(right:85),
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        height: 100,
                                                        borderRadius:
                                                            BorderRadius.only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        10),
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        10)),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            CText(
                                                              text: _yetToApproveOrders
                                                                  .where((element) =>
                                                                      element
                                                                          .table ==
                                                                      groupedYetToApproveOrders
                                                                          .keys
                                                                          .toList()[index])
                                                                  .toList()[i]
                                                                  .order[0]['foodName'],
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                            SizedBox(height: 5),
                                                            CText(
                                                              text: _yetToApproveOrders
                                                                      .where((element) =>
                                                                          element
                                                                              .table ==
                                                                          groupedYetToApproveOrders
                                                                              .keys
                                                                              .toList()[index])
                                                                      .toList()[i]
                                                                      .time ??
                                                                  '-',
                                                              maxLines: 2,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                            ),
                                                            SizedBox(height: 5),
                                                            CText(
                                                              text: _yetToApproveOrders
                                                                      .where((element) =>
                                                                          element
                                                                              .table ==
                                                                          groupedYetToApproveOrders.keys.toList()[
                                                                              index])
                                                                      .toList()[
                                                                          i]
                                                                      .order[0][
                                                                          'total']
                                                                      .toString() +
                                                                  'Rs',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Align(
                                                      child: CContainer(
                                                          borderRadius:
                                                              BorderRadius.only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          10),
                                                                  bottomLeft:
                                                                      Radius.circular(
                                                                          10)),
                                                          height: 100,
                                                          width:
                                                              mediaQuery.width *
                                                                  0.1,
                                                          child: CText(
                                                            text: _yetToApproveOrders
                                                                .where((element) =>
                                                                    element
                                                                        .table ==
                                                                    groupedYetToApproveOrders
                                                                            .keys
                                                                            .toList()[
                                                                        index])
                                                                .toList()[i]
                                                                .order[0]['qty']
                                                                .toString(),
                                                          )),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          isYetToApproveExpanded[index] =
                                              !isYetToApproveExpanded[index];
                                        });
                                      },
                                      child: CContainer(
                                        margin: EdgeInsets.only(bottom: 20),
                                        height: 100,
                                        borderRadius: BorderRadius.circular(10),
                                        child: Row(
                                          children: [
                                            CContainer(
                                              height: null,
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(10),
                                                  bottomLeft:
                                                      Radius.circular(10)),
                                              child: CText(
                                                  text:
                                                      groupedYetToApproveOrders
                                                          .keys
                                                          .toList()[index]),
                                              width: mediaQuery.width * 0.1,
                                            ),
                                            Expanded(
                                              child: CContainer(
                                                padding: EdgeInsets.all(8),
                                                alignment: Alignment.centerLeft,
                                                height: 100,
                                                borderRadius: BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(10),
                                                    bottomLeft:
                                                        Radius.circular(10)),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    CText(
                                                      text: '#4300043',
                                                      // groupedYetToApproveOrders.values.toList()[index]
                                                      //     .order['foodName'],
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                    SizedBox(height: 5),
                                                    CText(
                                                      text:
                                                          // groupedYetToApproveOrders.values.toList()[index]
                                                          //         .order['moreInfo'] ??
                                                          '-',
                                                      maxLines: 2,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                    ),
                                                    SizedBox(height: 5),
                                                    CText(
                                                      text: '$total Rs',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            CContainer(
                                                borderRadius: BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(10),
                                                    bottomLeft:
                                                        Radius.circular(10)),
                                                height: null,
                                                width: mediaQuery.width * 0.1,
                                                child: CText(
                                                  text: quantity.toString(),
                                                )),
                                            Container(
                                              height: null,
                                              decoration: BoxDecoration(
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.white,
                                                    offset: Offset(-3, -3),
                                                    blurRadius: 4,
                                                  ),
                                                ],
                                                gradient: LinearGradient(
                                                  begin: Alignment.bottomLeft,
                                                  end: Alignment.topRight,
                                                  colors: <Color>[
                                                    Color(0xFFFF7D55),
                                                    Color(0xFFF4197E),
                                                  ],
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              width: mediaQuery.width * 0.22,
                                              alignment: Alignment.center,
                                              child: GestureDetector(
                                                child: CText(
                                                  text: 'Remove',
                                                  textColor: Colors.white,
                                                ),
                                                onTap: () async {
                                                  setState(() {
                                                    _isLoading = true;
                                                  });
                                                  await Orders().updateOrder(
                                                      _approvedOrders[index]
                                                          .docId,
                                                      false);
                                                  getData();
                                                },
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                                // ListView.builder(
                                //   physics: NeverScrollableScrollPhysics(),
                                //   shrinkWrap: true,
                                //   itemCount:
                                //       _approvedOrders[index].order.length,
                                //   itemBuilder: (ctx, i) {
                                //     return CContainer(
                                //       margin: EdgeInsets.only(bottom: 20),
                                //       height: 100,
                                //       borderRadius: BorderRadius.circular(10),
                                //       child: Row(
                                //         children: [
                                //           CContainer(
                                //             height: null,
                                //             borderRadius: BorderRadius.only(
                                //                 topLeft: Radius.circular(10),
                                //                 bottomLeft:
                                //                     Radius.circular(10)),
                                //             child: CText(
                                //                 text: _approvedOrders[index]
                                //                     .table),
                                //             width: mediaQuery.width * 0.1,
                                //           ),
                                //           Expanded(
                                //             child: CContainer(
                                //               padding: EdgeInsets.all(8),
                                //               alignment: Alignment.centerLeft,
                                //               height: 100,
                                //               borderRadius: BorderRadius.only(
                                //                   topLeft: Radius.circular(10),
                                //                   bottomLeft:
                                //                       Radius.circular(10)),
                                //               child: Column(
                                //                 mainAxisAlignment:
                                //                     MainAxisAlignment.center,
                                //                 crossAxisAlignment:
                                //                     CrossAxisAlignment.start,
                                //                 children: [
                                //                   CText(
                                //                     text: _approvedOrders[index]
                                //                         .order[i]['foodName'],
                                //                     fontWeight: FontWeight.bold,
                                //                   ),
                                //                   SizedBox(height: 5),
                                //                   CText(
                                //                     text: _approvedOrders[index]
                                //                                 .order[i]
                                //                             ['moreInfo'] ??
                                //                         '-',
                                //                     maxLines: 2,
                                //                     fontWeight:
                                //                         FontWeight.normal,
                                //                   ),
                                //                   SizedBox(height: 5),
                                //                   CText(
                                //                     text: _approvedOrders[index]
                                //                             .order[i]['total']
                                //                             .toString() +
                                //                         ' Rs',
                                //                     fontWeight: FontWeight.bold,
                                //                   ),
                                //                 ],
                                //               ),
                                //             ),
                                //           ),
                                //           CContainer(
                                //             borderRadius: BorderRadius.only(
                                //                 topLeft: Radius.circular(10),
                                //                 bottomLeft:
                                //                     Radius.circular(10)),
                                //             height: null,
                                //             width: mediaQuery.width * 0.1,
                                //             child: CText(
                                //                 text: _approvedOrders[index]
                                //                     .order[i]['qty']
                                //                     .toString()),
                                //           ),
                                //           Container(
                                //             height: null,
                                //             decoration: BoxDecoration(
                                //               boxShadow: [
                                //                 BoxShadow(
                                //                   color: Colors.white,
                                //                   offset: Offset(-3, -3),
                                //                   blurRadius: 4,
                                //                 ),
                                //               ],
                                //               gradient: LinearGradient(
                                //                 begin: Alignment.bottomLeft,
                                //                 end: Alignment.topRight,
                                //                 colors: <Color>[
                                //                   Color(0xFFFF7D55),
                                //                   Color(0xFFF4197E),
                                //                 ],
                                //               ),
                                //               borderRadius:
                                //                   BorderRadius.circular(10),
                                //             ),
                                //             width: mediaQuery.width * 0.22,
                                //             alignment: Alignment.center,
                                //             child: GestureDetector(
                                //               child: CText(
                                //                 text: 'Remove',
                                //                 textColor: Colors.white,
                                //               ),
                                //               onTap: () async {
                                //                 setState(() {
                                //                   _isLoading = true;
                                //                 });
                                //                 await Orders().updateOrder(
                                //                     _approvedOrders[index]
                                //                         .docId,
                                //                     false);
                                //                 getData();
                                //               },
                                //             ),
                                //           )
                                //         ],
                                //       ),
                                //     );
                                //   },
                                // );
                              },
                            )
                          : Padding(
                              padding: const EdgeInsets.symmetric(vertical: 25),
                              child: CText(
                                text: 'No new approved orders',
                              ),
                            ),
                    ],
                  ),
                );
              },
            ),
          );
  }
}
