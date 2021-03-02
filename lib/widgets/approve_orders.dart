import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:orderingsystem/Components/CContainer.dart';
import 'package:orderingsystem/Components/CText.dart';
import 'package:orderingsystem/Models/Orders.dart';
import 'package:orderingsystem/Screens/s_approve_orders.dart';

import '../constants.dart';
import 'approved_orders.dart';

class ApproveOrders extends StatefulWidget {
  List<Orders> _yetToApproveOrders;
  Function update;
  int index;

  ApproveOrders(this._yetToApproveOrders, this.update, this.index);

  @override
  _ApproveOrdersState createState() => _ApproveOrdersState();
}

class _ApproveOrdersState extends State<ApproveOrders> {
  List<bool> isYetToApproveExpanded = [];

  @override
  void initState() {
    super.initState();
    isYetToApproveExpanded =
        List.filled(widget._yetToApproveOrders.length, true);
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;

    return Stack(
      children: [
        Offstage(
          offstage: isYetToApproveExpanded[widget.index],
          child: ConstrainedBox(
            constraints: BoxConstraints(
                maxHeight:
                    widget._yetToApproveOrders[widget.index].order.length *
                            180.0 +
                        50),
            child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsets.only(top: 120),
                itemCount:
                    widget._yetToApproveOrders[widget.index].order.length,
                itemBuilder: (context, i) {
                  final order =
                      widget._yetToApproveOrders[widget.index].order[i];

                  return Stack(
                    children: [
                      Container(
                        padding: EdgeInsets.only(bottom: 10, left: 5, right: 5),
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
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CText(
                                      text: order['foodName'],
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
                                height: 100,
                                width: mediaQuery.width * 0.1,
                                child: CText(
                                  text: order['qty'].toString(),
                                )),
                            GestureDetector(
                              onTap: () async {
                                await Orders()
                                    .deleteParticularOrder(
                                        widget._yetToApproveOrders[widget.index]
                                            .docId,
                                        widget._yetToApproveOrders[widget.index]
                                            .orderId
                                            .toString(),
                                        widget._yetToApproveOrders[widget.index]
                                            .order,
                                        i)
                                    .then((_) => Scaffold.of(context)
                                      ..removeCurrentSnackBar()
                                      ..showSnackBar(SnackBar(
                                          content: Text(
                                              '${widget._yetToApproveOrders[widget.index].order[i]['foodName']} from Order ${widget._yetToApproveOrders[widget.index].orderId} is deleted.'))));
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
                                  borderRadius: BorderRadius.circular(10),
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
        widget._yetToApproveOrders.isNotEmpty
            ? GestureDetector(
                onTap: () {
                  setState(() {
                    isYetToApproveExpanded[widget.index] =
                        !isYetToApproveExpanded[widget.index];
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
                            text: widget._yetToApproveOrders[widget.index].table
                                .toString()),
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
                                      topLeft: Radius.circular(10),
                                      bottomLeft: Radius.circular(10)),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CText(
                                        text: widget
                                            ._yetToApproveOrders[widget.index]
                                            .orderId
                                            .toString(),
                                        fontWeight: FontWeight.bold,
                                      ),
                                      SizedBox(height: 5),
                                      CText(
                                        text: widget
                                            ._yetToApproveOrders[widget.index]
                                            .time,
                                        maxLines: 2,
                                        fontWeight: FontWeight.normal,
                                      ),
                                      SizedBox(height: 5),
                                      CText(
                                        text:
                                            '${widget._yetToApproveOrders[widget.index].total} Rs',
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
                                    text: widget
                                        ._yetToApproveOrders[widget.index]
                                        .order
                                        .length
                                        .toString(),
                                  )),
                              Padding(
                                padding: const EdgeInsets.only(right: 5),
                                child: CContainer(
                                  height: null,
                                  backgroundColor: fontColor,
                                  borderRadius: BorderRadius.circular(10),
                                  width: mediaQuery.width * 0.22,
                                  alignment: Alignment.center,
                                  child: CText(
                                    text: 'Ordered',
                                    textColor: Colors.white,
                                  ),
                                ),
                              )
                            ],
                          ),
                          actionPane: SlidableDrawerActionPane(),
                          secondaryActions: <Widget>[
                            GestureDetector(
                              onTap: () async {
                                // widget.update();
                                await Orders()
                                    .updateOrder(
                                        widget._yetToApproveOrders[widget.index]
                                            .docId,
                                        true)
                                    .then((_) => Scaffold.of(context)
                                      ..removeCurrentSnackBar()
                                      ..showSnackBar(SnackBar(
                                          content: Text(
                                              'Order ${widget._yetToApproveOrders[widget.index].orderId} is approved.'))));
                                Navigator.of(context)
                                    .popAndPushNamed(SApproveOrders.routeName);
                                // widget.update();
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(right: 5),
                                child: CContainer(
                                  isBoxShadow: false,
                                  height: null,
                                  backgroundColor: fontColor,
                                  borderRadius: BorderRadius.circular(10),
                                  width: mediaQuery.width * 0.22,
                                  alignment: Alignment.center,
                                  child: CText(
                                    text: 'Approve',
                                    textColor: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                // widget.update();
                                await Orders()
                                    .deleteOrder(
                                      widget._yetToApproveOrders[widget.index]
                                          .docId,
                                    )
                                    .then((_) => Scaffold.of(context)
                                      ..removeCurrentSnackBar()
                                      ..showSnackBar(SnackBar(
                                          content: Text(
                                              'Order ${widget._yetToApproveOrders[widget.index].orderId} is deleted.'))));
                                // widget.update();
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(right: 5),
                                child: Container(
                                  height: null,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.bottomLeft,
                                      end: Alignment.topRight,
                                      colors: <Color>[
                                        Color(0xFFFF7D55),
                                        Color(0xFFF4197E),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  width: mediaQuery.width * 0.22,
                                  alignment: Alignment.center,
                                  child: CText(
                                    text: 'Remove',
                                    textColor: Colors.white,
                                  ),
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
                padding: const EdgeInsets.symmetric(vertical: 25),
                child: CText(
                  text: 'No new orders',
                ),
              ),
      ],
    );
  }
}
