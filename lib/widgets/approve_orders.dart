import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:orderingsystem/Components/CContainer.dart';
import 'package:orderingsystem/Components/CText.dart';
import 'package:orderingsystem/Models/Orders.dart';

import '../constants.dart';
import 'approved_orders.dart';

class ApproveOrders extends StatefulWidget {
  AsyncSnapshot<QuerySnapshot> snapshot;
  Function update;

  ApproveOrders(this.snapshot, this.update);

  @override
  _ApproveOrdersState createState() => _ApproveOrdersState();
}

class _ApproveOrdersState extends State<ApproveOrders> {
  List<Orders> _ordersList = [];
  List<Orders> _yetToApproveOrders = [];
  List<bool> isYetToApproveExpanded = [];

  @override
  void initState() {
    super.initState();
    widget.snapshot.data.docs.forEach((element) {
      _ordersList.add(Orders.fromJson(element.data()));
    });

    _ordersList.forEach((element) {
      if (!element.isApprove) {
        _yetToApproveOrders.add(element);
      }
    });

    isYetToApproveExpanded = List.filled(_yetToApproveOrders.length, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CText(
                        text:
                            DateFormat('LLLL D, yyyy').format(DateTime.now())),
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
                  itemCount: _yetToApproveOrders.length,
                  itemBuilder: (context, index) {
                    var quantity = 0;
                    _yetToApproveOrders.forEach(
                        (element) => quantity += (element.order[0]['qty']));

                    final mediaQuery = MediaQuery.of(context).size;

                    return Stack(
                      children: [
                        Offstage(
                          offstage: isYetToApproveExpanded[index],
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                                maxHeight:
                                    _yetToApproveOrders[index].order.length *
                                            180.0 +
                                        50),
                            child: ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                padding: EdgeInsets.only(top: 120),
                                itemCount:
                                    _yetToApproveOrders[index].order.length,
                                itemBuilder: (context, i) {
                                  final order =
                                      _yetToApproveOrders[index].order[i];

                                  return Stack(
                                    children: [

                                      Container(
                                        padding: EdgeInsets.only(
                                            bottom: 10, left: 5, right: 5),
                                        child: Row(
                                          children: [
                                            CContainer(
                                              height: 100,
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(10),
                                                  bottomLeft: Radius.circular(10)),
                                              child:
                                              CText(text: (i + 1).toString()),
                                              width: mediaQuery.width * 0.1,
                                            ),
                                            Expanded(
                                              child: CContainer(
                                                alignment: Alignment.centerLeft,
                                                height: 100,
                                                borderRadius: BorderRadius.only(
                                                    topLeft: Radius.circular(10),
                                                    bottomLeft:
                                                    Radius.circular(10)),
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
                                                await Orders()
                                                    .deleteParticularOrder(
                                                  _yetToApproveOrders[index].docId,
                                                  _yetToApproveOrders[index].orderId.toString(),
                                                  _yetToApproveOrders[index].order,
                                                  i
                                                );
                                                widget.update();
                                              },
                                              child: Container(
                                                height: 100,
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
                                                child: CText(
                                                  text: 'Remove',
                                                  textColor: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  );
                                }),
                          ),
                        ),
                        _yetToApproveOrders.isNotEmpty
                            ? GestureDetector(
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
                                            text: _yetToApproveOrders[index]
                                                .table),
                                        width: mediaQuery.width * 0.1,
                                      ),
                                      Expanded(
                                        child: Slidable(
                                          child: Row(
                                            children: [
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
                                                        text: _yetToApproveOrders[
                                                                index]
                                                            .orderId
                                                            .toString(),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                      SizedBox(height: 5),
                                                      CText(
                                                        text: _yetToApproveOrders[
                                                                index]
                                                            .time,
                                                        maxLines: 2,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                      ),
                                                      SizedBox(height: 5),
                                                      CText(
                                                        text:
                                                            '${_yetToApproveOrders[index].total} Rs',
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
                                                    text:
                                                        _yetToApproveOrders[index]
                                                            .order
                                                            .length
                                                            .toString(),
                                                  )),
                                              CContainer(
                                                height: null,
                                                backgroundColor: fontColor,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                width: mediaQuery.width * 0.22,
                                                alignment: Alignment.center,
                                                child: CText(
                                                  text: 'Ordered',
                                                  textColor: Colors.white,
                                                ),
                                              )
                                            ],
                                          ),
                                          actionPane: SlidableDrawerActionPane(),
                                          secondaryActions: <Widget>[
                                            GestureDetector(
                                              onTap: () async {
                                                widget.update();
                                                await Orders()
                                                    .updateOrder(
                                                    _yetToApproveOrders[index].docId,
                                                    true);
                                                widget.update();
                                              },
                                              child: CContainer(
                                                height: null,
                                                backgroundColor: fontColor,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                width: mediaQuery.width * 0.22,
                                                alignment: Alignment.center,
                                                child: CText(
                                                  text: 'Approve',
                                                  textColor: Colors.white,
                                                ),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () async {
                                                widget.update();
                                                await Orders()
                                                    .deleteOrder(
                                                    _yetToApproveOrders[index].docId,);
                                                widget.update();
                                              },
                                              child: Container(
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
                                                child: CText(
                                                  text: 'Remove',
                                                  textColor: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 25),
                                child: CText(
                                  text: 'No new orders',
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
        bottomNavigationBar: ApprovedOrders(widget.snapshot, widget.update));
  }
}
