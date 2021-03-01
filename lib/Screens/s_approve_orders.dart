import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:orderingsystem/Components/CLoadingIndicator.dart';
import 'package:orderingsystem/Components/CText.dart';
import 'package:orderingsystem/Models/Orders.dart';
import 'package:orderingsystem/widgets/approve_orders.dart';
import 'package:orderingsystem/widgets/approved_orders.dart';

import '../constants.dart';

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
    CollectionReference orders =
        FirebaseFirestore.instance.collection('Orders');
    final mediaQuery = MediaQuery.of(context).size;

    return StreamBuilder<QuerySnapshot>(
        stream: orders.snapshots(includeMetadataChanges: true),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting ||
              _isLoading) {
            return CLoadingIndicator();
          } else {
            List<Orders> _ordersList = [];
            List<Orders> _yetToApproveOrders = [];
            List<Orders> _approvedOrders = [];

            _ordersList.clear();
            snapshot.data.docs.forEach((element) {
              _ordersList.add(Orders.fromJson(element.data()));
            });

            snapshot.data.docs.forEach((element) {
              if (!element.data()['isApprove']) {
                _yetToApproveOrders.add(Orders.fromJson(element.data()));
              } else {
                _approvedOrders.add(Orders.fromJson(element.data()));
              }
            });

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
                        child: Column(children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CText(
                                  text: DateFormat('LLLL dd, yyyy')
                                      .format(DateTime.now())),
                              StreamBuilder(
                                stream:
                                    Stream.periodic(const Duration(minutes: 1)),
                                builder: (BuildContext context,
                                    AsyncSnapshot<dynamic> snapshot) {
                                  return CText(
                                      text: DateFormat('hh:mm a')
                                          .format(DateTime.now()));
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: 15),
                          ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: snapshot.data.docs
                                  .where(
                                      (element) => !element.data()['isApprove'])
                                  .toList()
                                  .length,
                              itemBuilder: (context, index) {
                                // var quantity = 0;
                                // _ordersList
                                //     .where((element) => !element.isApprove)
                                //     .forEach((element) =>
                                //         quantity += (element.order[0]['qty']));
                                return ApproveOrders(
                                    _yetToApproveOrders, update, index);
                              })
                        ]))),
                bottomNavigationBar: DraggableScrollableSheet(
                    expand: false,
                    minChildSize: 0.07,
                    maxChildSize: 0.85,
                    initialChildSize: 0.07,
                    builder: (context, controller) {
                      return SingleChildScrollView(
                          controller: controller,
                          child: Column(children: [
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

                                      return ApprovedOrders(
                                          _approvedOrders, update, index);
                                    })
                                : Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 25),
                                    child: CText(
                                      text: 'No new approved orders',
                                    ),
                                  ),
                          ]));
                    }));
          }
        });
  }
}
