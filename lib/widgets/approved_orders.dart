import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:orderingsystem/Components/CContainer.dart';
import 'package:orderingsystem/Components/CText.dart';
import 'package:orderingsystem/Models/Orders.dart';

import '../constants.dart';

class ApprovedOrders extends StatefulWidget {

  final AsyncSnapshot<QuerySnapshot> snapshot;
  final Function update;

  ApprovedOrders(this.snapshot, this.update);

  @override
  _ApprovedOrdersState createState() => _ApprovedOrdersState();
}

class _ApprovedOrdersState extends State<ApprovedOrders> {

  List<Orders> _ordersList = [];
  List<Orders> _approvedOrders = [];
  List<bool> isApprovedExpanded = [];

  @override
  void initState() {
    super.initState();
    widget.snapshot.data.docs.forEach((element) {
      _ordersList.add(Orders.fromJson(element.data()));
    });

    _ordersList.forEach(
          (element) {
            if(element.isApprove){
              _approvedOrders.add(element);
            }
          },
    );

    isApprovedExpanded =
        List.filled(
            _approvedOrders
            .toList().length,
            true);
  }


  @override
  Widget build(BuildContext context) {

    final mediaQuery = MediaQuery.of(context).size;

    return DraggableScrollableSheet(
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
                                itemCount: _approvedOrders.length,
                                itemBuilder: (context, index) {
                                  var quantity = 0;
                                  _approvedOrders.forEach((element) =>
                                          quantity += (element.order[0]['qty']));
                                  return Stack(
                                    children: [
                                      Offstage(
                                        offstage: isApprovedExpanded[index],
                                        child: ConstrainedBox(
                                          constraints: BoxConstraints(
                                              maxHeight: _approvedOrders[index].order.length * 180.0 + 50),
                                          child: ListView.builder(
                                              padding: EdgeInsets.only(top: 130),
                                              itemCount: _approvedOrders[index].order.length,
                                              itemBuilder: (context, i) {
                                                final order = _approvedOrders[index].order[i];

                                                return Container(
                                                  padding: EdgeInsets.only(bottom: 10),
                                                  child: Row(
                                                    children: [
                                                      CContainer(
                                                        height: 100,
                                                        borderRadius: BorderRadius.only(
                                                            topLeft: Radius.circular(10),
                                                            bottomLeft: Radius.circular(10)),
                                                        child: CText(text: (i + 1).toString()),
                                                        width: mediaQuery.width * 0.1,
                                                      ),
                                                      Expanded(
                                                        child: CContainer(
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
                                                                text: order['foodName'],
                                                                fontWeight: FontWeight.bold,
                                                              ),
                                                              // SizedBox(height: 5),
                                                              // CText(
                                                              //   text:
                                                              //   // order[i].time ??
                                                              //       '-',
                                                              //   maxLines: 2,
                                                              //   fontWeight: FontWeight.normal,
                                                              // ),
                                                              // SizedBox(height: 5),
                                                              // CText(
                                                              //   text:
                                                              //   // order[i].order[0]['total']
                                                              //   //         .toString() +
                                                              //       'Rs',
                                                              //   fontWeight: FontWeight.bold,
                                                              // ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      CContainer(
                                                          borderRadius: BorderRadius.only(
                                                              topLeft: Radius.circular(10),
                                                              bottomLeft:
                                                              Radius.circular(10)),
                                                          height: 100,
                                                          width: mediaQuery.width * 0.1,
                                                          child: CText(
                                                            text: order['qty'].toString(),
                                                          )),
                                                      GestureDetector(
                                                        onTap: () async {
                                                          widget.update();
                                                          // await Orders().updateOrder(
                                                          //     groupedYetToApproveOrders.values.toList()[index][0].docId, true);
                                                          // groupedYetToApproveOrders.values
                                                          //     .forEach((element) {
                                                          //   element.forEach((ele) async {
                                                          //     print(ele.docId);
                                                          //     await Orders()
                                                          //         .updateOrder(ele.orderId(), true);
                                                          //   });
                                                          // });
                                                          widget.update();
                                                        },
                                                        child: CContainer(
                                                          height: 100,
                                                          backgroundColor: fontColor,
                                                          borderRadius: BorderRadius.circular(10),
                                                          width: mediaQuery.width * 0.22,
                                                          alignment: Alignment.center,
                                                          child: CText(
                                                            text: 'Approve',
                                                            textColor: Colors.white,
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                );
                                              }),
                                        ),
                                      ),
                                      _approvedOrders.isNotEmpty
                                          ? GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  isApprovedExpanded[index] =
                                                      !isApprovedExpanded[index];
                                                });
                                              },
                                              child: CContainer(
                                                margin:
                                                    EdgeInsets.only(bottom: 20),
                                                height: 100,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: Row(
                                                  children: [
                                                    CContainer(
                                                      height: null,
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              topLeft: Radius
                                                                  .circular(10),
                                                              bottomLeft:
                                                                  Radius.circular(
                                                                      10)),
                                                      child: CText(
                                                          text:
                                                          _approvedOrders[index]
                                                              .table),
                                                      width:
                                                          mediaQuery.width * 0.1,
                                                    ),
                                                    Expanded(
                                                      child: CContainer(
                                                        padding:
                                                            EdgeInsets.all(8),
                                                        alignment:
                                                            Alignment.centerLeft,
                                                        height: 100,
                                                        borderRadius:
                                                            BorderRadius.only(
                                                                topLeft: Radius
                                                                    .circular(10),
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
                                                              text: _approvedOrders[index].orderId.toString(),
                                                              fontWeight:
                                                                  FontWeight.bold,
                                                            ),
                                                            SizedBox(height: 5),
                                                            CText(
                                                              text:
                                                                  _approvedOrders[index].time,
                                                              maxLines: 2,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                            ),
                                                            SizedBox(height: 5),
                                                            CText(
                                                              text: '${_approvedOrders[index].total} Rs',
                                                              fontWeight:
                                                                  FontWeight.bold,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    CContainer(
                                                        borderRadius:
                                                            BorderRadius.only(
                                                                topLeft: Radius
                                                                    .circular(10),
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        10)),
                                                        height: null,
                                                        width: mediaQuery.width *
                                                            0.1,
                                                        child: CText(
                                                          text:
                                                              quantity.toString(),
                                                        )),
                                                    GestureDetector(
                                                      onTap: () async {
                                                        widget.update();
                                                        await Orders()
                                                            .updateOrder(
                                                            _approvedOrders[index].docId,
                                                            false);
                                                        widget.update();
                                                      },
                                                      child: Container(
                                                        height: null,
                                                        decoration: BoxDecoration(
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors.white,
                                                              offset:
                                                                  Offset(-3, -3),
                                                              blurRadius: 4,
                                                            ),
                                                          ],
                                                          gradient:
                                                              LinearGradient(
                                                            begin: Alignment
                                                                .bottomLeft,
                                                            end: Alignment
                                                                .topRight,
                                                            colors: <Color>[
                                                              Color(0xFFFF7D55),
                                                              Color(0xFFF4197E),
                                                            ],
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                        width: mediaQuery.width *
                                                            0.22,
                                                        alignment:
                                                            Alignment.center,
                                                        child: CText(
                                                          text: 'Remove',
                                                          textColor: Colors.white,
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            )
                                          : Padding(
                                              padding: const EdgeInsets.symmetric(
                                                  vertical: 25),
                                              child: CText(
                                                text: 'No new approved orders',
                                              ),
                                            ),
                                    ],
                                  );
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
              );
  }
}
