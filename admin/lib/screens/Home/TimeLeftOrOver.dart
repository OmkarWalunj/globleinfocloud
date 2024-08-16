import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:globleinfocloud/screens/Home/HomeScreen.dart';
import 'package:intl/intl.dart';


final Stream stream1 = FirebaseFirestore.instance.collection('StudentDetails').snapshots();// to accessing products collections

//final Stream stream2 = FirebaseFirestore.instance.collection('BiddingData').snapshots(); // to accessing the Bidding data collection

class TimeLeftOrOver extends StatefulWidget {
  //static const routeName = "/place-bid-screen";
  final String productId;
  final int index;
  const TimeLeftOrOver({super.key, required this.productId, required this.index});

  @override
  State<TimeLeftOrOver> createState() => _TimeLeftOrOverState();
}

class _TimeLeftOrOverState extends State<TimeLeftOrOver> {


final startDateTime = DateTime.now();
  DateTime endDateTime = DateTime(2023, 4, 10, 10, 0, 0);
  late Timer _timer;
  Duration _duration = Duration();
  late StreamSubscription<DocumentSnapshot> _subscription;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), _updateCountdown);
    DateFormat inputFormat = DateFormat('dd-MM-yyyy hh:mm a');
    _subscription = FirebaseFirestore.instance
        .collection('StudentDetails')
        .doc(widget.productId)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists) {
        endDateTime = inputFormat.parse(
          "${snapshot['return_date']} ${snapshot['End_Time']}",
        );

        _updateCountdown(_timer);

        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _subscription.cancel();
    super.dispose();
  }

  void _updateCountdown(Timer timer) {
    setState(() {
      final now = DateTime.now();
      if (now.isAfter(endDateTime)) {
        _duration = const Duration();
        _timer.cancel();
        _createDocumentInTimeOverCollection(widget.productId);
      } else {
        _duration = endDateTime.difference(now);
      }
    });
  }

  void _createDocumentInTimeOverCollection(String studentAddDetailsId) {
    FirebaseFirestore.instance
        .collection('StudentDetails')
        .doc(studentAddDetailsId)
        .get()
        .then((snapshot) {
      if (snapshot.exists) {
        var firebaseFirestore = FirebaseFirestore.instance;
        Map<String, dynamic> toMap() {
          return {
            'Student_DealTime': snapshot['Deal_Time'],
            'Student_EndTime': snapshot['End_Time'],
            'Student_BookNames': snapshot['booksnames'],
            'Student_Branch': snapshot['branch'],
            'Student_ImagesOfProofs': snapshot['images_of_proofs'],
            'Student_Name': snapshot['name'],
            'Student_RentBookPublication': snapshot['publication'],
            'Student_BookPurcahseDate': snapshot['purchase_date'],
            'Student_BookReturnDate': snapshot['return_date'],
            'Student_BookPurchasedSemester': snapshot['semester'],
            'Student_University': snapshot['university'],
            'Student_Id': snapshot['userId'],
          };
        }

        // Use set with specified document ID
        firebaseFirestore.collection("Time_Over").doc(studentAddDetailsId).set(toMap());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    DateFormat inputFormat = DateFormat('dd-MM-yyyy hh:mm a');
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('StudentDetails').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            endDateTime = inputFormat.parse(
                "${snapshot.data?.docs[widget.index]['return_date']} ${snapshot.data?.docs[widget.index]['End_Time']}");


           
            print("sjhfsf");
            print("end bidding time;" + endDateTime.toString());
            print("start bidding time;" + startDateTime.toString());
            print(endDateTime.difference(startDateTime));

            return Scaffold(
              body: endDateTime.difference(startDateTime) <= Duration.zero
                  ? Scaffold(
                body: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: double.infinity,
                        // color: Colors.black,
                        child: Center(
                            child: Text("Subscription Ended ! ",
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500))),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const SizedBox(
                        width: double.infinity,
                        // color: Colors.black,
                        child: Center(
                            child: Text("Click below for new request",
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500))),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      ElevatedButton(
                        onPressed: () {
                         // Navigator.pop(context);//add path for Add Stud Info
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: Color.fromRGBO(255, 114, 58, 1)),
                        child: const Text('New Request'),
                      )
                    ],
                  ),
                ),
              )
                  : SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Center(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 50,
                        ),
                        const Text('Time Remaining for Rent'),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(9),
                                color: const Color.fromRGBO(255, 110, 64, 1),
                              ),
                              child: Center(
                                  child: Text(
                                    "${_duration.inDays}d",
                                    style:
                                    const TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 17),
                                  )),
                            ),
                            // const SizedBox(
                            //   width: ,
                            // ),
                            const Text(
                              " : ",
                              style: TextStyle(fontSize: 30),
                            ),
                            Container(
                              padding: const EdgeInsets.all(10),
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(9),
                                color: const Color.fromRGBO(255, 110, 64, 1),
                              ),
                              child: Center(
                                  child: Text(
                                    "${_duration.inHours.remainder(24)}h",
                                    style:
                                    const TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 17),
                                  )),
                            ),
                            const Text(
                              " : ",
                              style: TextStyle(fontSize: 30),
                            ),
                            Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(9),
                                color: const Color.fromRGBO(255, 110, 64, 1),
                              ),
                              child: Center(
                                  child: Text(
                                    "${_duration.inMinutes.remainder(60)}m",
                                    style:
                                    const TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 17),
                                  )),
                            ),
                            const Text(
                              " : ",
                              style: TextStyle(fontSize: 30),
                            ),
                            Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(9),
                                color: const Color.fromRGBO(255, 110, 64, 1),
                              ),
                              child: Center(
                                child: Text(
                                  "${_duration.inSeconds.remainder(60)}s",
                                  style:
                                  const TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 17),
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        
                      ],
                    )),
              ),
            );
          } else {
            return Skeleton(
              height: 20,
              width: 30,
            );
          }
        });
  }
}

