import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:orderingsystem/Components/CContainer.dart';
import 'package:orderingsystem/Components/CText.dart';
import 'package:orderingsystem/Models/Orders.dart';

import '../constants.dart';

class ApprovedOrders extends StatefulWidget {
  final List<Orders> _approvedOrders;
  final Function update;
  int index;

  ApprovedOrders(this._approvedOrders, this.update, this.index);

  @override
  _ApprovedOrdersState createState() => _ApprovedOrdersState();
}

class _ApprovedOrdersState extends State<ApprovedOrders> {
  List<bool> isApprovedExpanded = [];
  @override
  void initState() {
    super.initState();


    isApprovedExpanded =
        List.filled(widget._approvedOrders.toList().length, true);
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;

    return Stack(
      children: [
        Offstage(
          offstage: isApprovedExpanded[widget.index],
          child: ConstrainedBox(
            constraints: BoxConstraints(
                maxHeight:
                    widget._approvedOrders[widget.index].order.length * 180.0 + 50),
            child: ListView.builder(
                padding: EdgeInsets.only(top: 110, bottom: 10),
                itemCount: widget._approvedOrders[widget.index].order.length,
                itemBuilder: (context, i) {
                  final order = widget._approvedOrders[widget.index].order[i];

                  return Container(
                    padding: EdgeInsets.only(bottom: 10, left: 10, right: 10),
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
                                  fontSize: 14,
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
                        // GestureDetector(
                        //   onTap: () async {
                        //     widget.update();
                        //     // await Orders().updateOrder(
                        //     //     groupedYetToApproveOrders.values.toList()[index][0].docId, true);
                        //     // groupedYetToApproveOrders.values
                        //     //     .forEach((element) {
                        //     //   element.forEach((ele) async {
                        //     //     print(ele.docId);
                        //     //     await Orders()
                        //     //         .updateOrder(ele.orderId(), true);
                        //     //   });
                        //     // });
                        //     widget.update();
                        //   },
                        //   child: CContainer(
                        //     height: 100,
                        //     backgroundColor: fontColor,
                        //     borderRadius: BorderRadius.circular(10),
                        //     width: mediaQuery.width * 0.22,
                        //     alignment: Alignment.center,
                        //     child: CText(
                        //       text: 'Approve',
                        //       textColor: Colors.white,
                        //     ),
                        //   ),
                        // )
                      ],
                    ),
                  );
                }),
          ),
        ),
        widget._approvedOrders.isNotEmpty
            ? GestureDetector(
                onTap: () {
                  setState(() {
                    isApprovedExpanded[widget.index] = !isApprovedExpanded[widget.index];
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
                        child: CText(text: widget._approvedOrders[widget.index].table),
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
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CText(
                                text: widget._approvedOrders[widget.index].orderId
                                    .toString(),
                                fontWeight: FontWeight.bold,
                              ),
                              SizedBox(height: 5),
                              CText(
                                text: widget._approvedOrders[widget.index].time,
                                maxLines: 2,
                                fontWeight: FontWeight.normal,
                              ),
                              SizedBox(height: 5),
                              CText(
                                text:
                                    '${widget._approvedOrders[widget.index].total} Rs',
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
                            text: widget._approvedOrders[widget.index].order.length.toString(),
                          )),
                      GestureDetector(
                        onTap: () async {
                          // widget.update();
                          await Orders().updateOrder(
                              widget._approvedOrders[widget.index].docId, false)
                              .then((value) => Scaffold.of(context)
                              ..removeCurrentSnackBar()..showSnackBar(SnackBar(content: Text('Order ${widget._approvedOrders[widget.index].orderId} is removed.'))));
                          // widget.update();
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
                            borderRadius: BorderRadius.circular(10),
                          ),
                          width: mediaQuery.width * 0.22,
                          alignment: Alignment.center,
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
                padding: const EdgeInsets.symmetric(vertical: 25),
                child: CText(
                  text: 'No new approved orders',
                ),
              ),
      ],
    );
  }
}
