// import 'dart:io';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:dotted_border/dotted_border.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:intl/intl.dart';
// import 'package:movison/screens/Home/HomeScreen.dart';
// import 'package:movison/size_config.dart';
// import 'package:movison/widgets/custom_surfix_icon.dart';
// import 'package:fluttertoast/fluttertoast.dart';  // Import Fluttertoast


// class AddStudentdetails extends StatefulWidget {
//   const AddStudentdetails({super.key});

//   @override
//   State<AddStudentdetails> createState() => _AddStudentdetailsState();
// }

// class _AddStudentdetailsState extends State<AddStudentdetails> {
//   final controllerName = TextEditingController();
//   final controllerBooksnames = TextEditingController();
//     String? publicationselected;
//     String? universityselected;
//     String? branchselected;
//     String ? semesterselected;
//     String ? dealdateselected="";
//     String ? dealreturndateselected="";
//     //DateTime date = new DateTime.now();
//     TimeOfDay startTime = TimeOfDay.now();
//     TimeOfDay endTime = TimeOfDay.now();
//     var myDateFormat = DateFormat('d-MM-yyyy');
//   final List<String> _publications = [
//     "Technical",
//     "Techknowledge",
//   ];
//   final List<String> _universities = [
//     "SPPU",
//   ];
//   final List<String> _branch=[
//         "Computer Science",
//         "Information Technology",
//         "Electronics and Telecommunication",
//         "Civil",
//         "Mechanical",
//         "Electrical",
//         "Instrumentation"

//   ];
//   final List<String> _semester = [
//                 "I",
//                 "II",
//                 "III",
//                 "IV",
//                 "V",
//                 "VI",
//                 "VII",
//                 "VIII",
//     ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Add Details'),
//       ),
//       body: Scaffold(
//         backgroundColor: Colors.grey.shade100,
//         body: SafeArea(
//           child: Stack(
//             alignment: AlignmentDirectional.center,
//             children: [
//               Positioned(
//                 child: SingleChildScrollView(child: mainContainer()),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Container mainContainer() {
//     return Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(20),
//         color: Colors.white,
//       ),
//       width: getProportionateScreenWidth(double.infinity),
//       child: Column(
//         children: [
//           const SizedBox(height: 30),
//           nameTextField(),
//           const SizedBox(height: 30),
//           University(),
//           const SizedBox(height: 30),
//           Publication(),
//           const SizedBox(height: 30),
//           Branch(),
//           const SizedBox(height: 30),
//           Semester(),
//           const SizedBox(height: 30),
//           BooksNames(),
//           const SizedBox(height: 30),
//            Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 imagePick(0,"adhar front"),
//                 const SizedBox(width: 10),
//                 imagePick(1,"adhar back"),
//                 const SizedBox(width: 10),
//                 imagePick(2,"college id front"),
//                 const SizedBox(width: 10),
//                 imagePick(3,"college id back"),
//                 const SizedBox(width: 10),

//               ],
//             ),
//             )
//           ),
//           const SizedBox(height: 30),
//           start_date(),
//           const SizedBox(height: 30),
//           end_date(),
//           const SizedBox(height: 30),
//           saveButton(),
//           const SizedBox(height: 30),
//         ],
//       ),
//     );
//   }
//  // for taking input for name 
//   Padding nameTextField() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20),
//       child: TextField(
//         controller: controllerName,
//         decoration: InputDecoration(
//           contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
//           labelText: 'Enter Student name',
//           labelStyle: TextStyle(fontSize: 17, color: Colors.grey.shade500),
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(10),
//             borderSide: const BorderSide(width: 2, color: Color(0xffC5C5C5)),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(10),
//             borderSide: const BorderSide(width: 2, color: Colors.black),
//           ),
//           suffixIcon: const CustomSurffixIcon(svgIcon: "assets/icons/profile1.svg"),
//         ),
//       ),
//     );
//   }

//   // select a book
//   Padding Publication() {
//     _publications.sort();
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20),
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 15),
//         width: double.infinity,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(10),
//           border: Border.all(
//             width: 2,
//             color: const Color(0xffC5C5C5),
//           ),
//         ),
//         child: DropdownButton<String>(
//           value: publicationselected,
//           onChanged: ((value) {
//             setState(() {
//               publicationselected = value!;
//             });
//           }),
//           items: _publications
//               .map((e) => DropdownMenuItem(
//                     value: e,
//                     child: Container(
//                       alignment: Alignment.center,
//                       child: Row(
//                         children: [
//                           Text(
//                             e,
//                             style: const TextStyle(fontSize: 18),
//                           )
//                         ],
//                       ),
//                     ),
//                   ))
//               .toList(),
//           selectedItemBuilder: (BuildContext context) => _publications
//               .map((e) => Row(
//                     children: [
//                       Text(e)
//                     ],
//                   ))
//               .toList(),
//           hint: const Padding(
//             padding: EdgeInsets.only(top: 12),
//             child: Text(
//               'Select Publication',
//               style: TextStyle(color: Colors.grey),
//             ),
//           ),
//           dropdownColor: Colors.white,
//           isExpanded: true,
//           underline: Container(),
//         ),
//       ),
//     );
//   }

//   // select a university 
//   Padding University() {
//     _universities.sort();
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20),
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 15),
//         width: double.infinity,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(10),
//           border: Border.all(
//             width: 2,
//             color: const Color(0xffC5C5C5),
//           ),
//         ),
//         child: DropdownButton<String>(
//           value: universityselected,
//           onChanged: ((value) {
//             setState(() {
//               universityselected = value!;
//             });
//           }),
//           items: _universities
//               .map((e) => DropdownMenuItem(
//                     value: e,
//                     child: Container(
//                       alignment: Alignment.center,
//                       child: Row(
//                         children: [
//                           Text(
//                             e,
//                             style: const TextStyle(fontSize: 18),
//                           )
//                         ],
//                       ),
//                     ),
//                   ))
//               .toList(),
//           selectedItemBuilder: (BuildContext context) => _universities
//               .map((e) => Row(
//                     children: [
//                       Text(e)
//                     ],
//                   ))
//               .toList(),
//           hint: const Padding(
//             padding: EdgeInsets.only(top: 12),
//             child: Text(
//               'Select University',
//               style: TextStyle(color: Colors.grey),
//             ),
//           ),
//           dropdownColor: Colors.white,
//           isExpanded: true,
//           underline: Container(),
//         ),
//       ),
//     );
//   }

//   // select a branch 
//   Padding Branch() {
//     _branch.sort();
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20),
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 15),
//         width: double.infinity,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(10),
//           border: Border.all(
//             width: 2,
//             color: const Color(0xffC5C5C5),
//           ),
//         ),
//         child: DropdownButton<String>(
//           value: branchselected,
//           onChanged: ((value) {
//             setState(() {
//              branchselected = value!;
//             });
//           }),
//           items: _branch
//               .map((e) => DropdownMenuItem(
//                     value: e,
//                     child: Container(
//                       alignment: Alignment.center,
//                       child: Row(
//                         children: [
//                           Text(
//                             e,
//                             style: const TextStyle(fontSize: 18),
//                           )
//                         ],
//                       ),
//                     ),
//                   ))
//               .toList(),
//           selectedItemBuilder: (BuildContext context) => _branch
//               .map((e) => Row(
//                     children: [
//                       Text(e)
//                     ],
//                   ))
//               .toList(),
//           hint: const Padding(
//             padding: EdgeInsets.only(top: 12),
//             child: Text(
//               'Select Branch',
//               style: TextStyle(color: Colors.grey),
//             ),
//           ),
//           dropdownColor: Colors.white,
//           isExpanded: true,
//           underline: Container(),
//         ),
//       ),
//     );
//   }

//   // select a semester
//     Padding Semester() {
//     _semester.sort();
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20),
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 15),
//         width: double.infinity,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(10),
//           border: Border.all(
//             width: 2,
//             color: const Color(0xffC5C5C5),
//           ),
//         ),
//         child: DropdownButton<String>(
//           value: semesterselected,
//           onChanged: ((value) {
//             setState(() {
//              semesterselected= value!;
//             });
//           }),
//           items: _semester
//               .map((e) => DropdownMenuItem(
//                     value: e,
//                     child: Container(
//                       alignment: Alignment.center,
//                       child: Row(
//                         children: [
//                           Text(
//                             e,
//                             style: const TextStyle(fontSize: 18),
//                           )
//                         ],
//                       ),
//                     ),
//                   ))
//               .toList(),
//           selectedItemBuilder: (BuildContext context) => _semester
//               .map((e) => Row(
//                     children: [
//                       Text(e)
//                     ],
//                   ))
//               .toList(),
//           hint: const Padding(
//             padding: EdgeInsets.only(top: 12),
//             child: Text(
//               'Select Semester',
//               style: TextStyle(color: Colors.grey),
//             ),
//           ),
//           dropdownColor: Colors.white,
//           isExpanded: true,
//           underline: Container(),
//         ),
//       ),
//     );
//   }

//   // new method for taking input for book names
//   Padding BooksNames() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20),
//       child: TextField(
//         controller: controllerBooksnames,
//         decoration: InputDecoration(
//           contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
//           labelText: 'Enter Book Names (comma-separated)',
//           labelStyle: TextStyle(fontSize: 17, color: Colors.grey.shade500),
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(10),
//             borderSide: const BorderSide(width: 2, color: Color(0xffC5C5C5)),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(10),
//             borderSide: const BorderSide(width: 2, color: Colors.black),
//           ),
//           suffixIcon: const CustomSurffixIcon(svgIcon: "assets/icons/receipt.svg"),
//         ),
//       ),
//     );
//   }

//   // taking input for adhar card and college id
//   GestureDetector Image1() {
//     return GestureDetector(
//       onTap: () {
//         ImagePicker();
//       },
//       child: Container(
//         alignment: Alignment.center,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(15),
//           color: Colors.deepOrangeAccent,
//         ),
//         width: 120,
//         height: 50,
//         child: const Text(
//           'Pick image 1',
//           style: TextStyle(
//             fontFamily: 'f',
//             fontWeight: FontWeight.w600,
//             color: Colors.white,
//             fontSize: 17,
//           ),
//         ),
//       ),
//     );
//   }

//   GestureDetector Image2() {
//     return GestureDetector(
//       onTap: () {},
//       child: Container(
//         alignment: Alignment.center,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(15),
//           color: Colors.deepOrangeAccent,
//         ),
//         width: 120,
//         height: 50,
//         child: const Text(
//           'Pick image 2',
//           style: TextStyle(
//             fontFamily: 'f',
//             fontWeight: FontWeight.w600,
//             color: Colors.white,
//             fontSize: 17,
//           ),
//         ),
//       ),
//     );
//   }

//   GestureDetector Image3() {
//     return GestureDetector(
//       onTap: () {},
//       child: Container(
//         alignment: Alignment.center,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(15),
//           color: Colors.deepOrangeAccent,
//         ),
//         width: 120,
//         height: 50,
//         child: const Text(
//           'Pick image 3',
//           style: TextStyle(
//             fontFamily: 'f',
//             fontWeight: FontWeight.w600,
//             color: Colors.white,
//             fontSize: 17,
//           ),
//         ),
//       ),
//     );
//   }

//   GestureDetector Image4() {
//     return GestureDetector(
//       onTap: () {},
//       child: Container(
//         alignment: Alignment.center,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(15),
//           color: Colors.deepOrangeAccent,
//         ),
//         width: 120,
//         height: 50,
//         child: const Text(
//           'Pick image 4',
//           style: TextStyle(
//             fontFamily: 'f',
//             fontWeight: FontWeight.w600,
//             color: Colors.white,
//             fontSize: 17,
//           ),
//         ),
//       ),
//     );
//   }

//   List<String> imageUrls = [];

//   void imageFromGallary() async {
//     String imageUrl = '';
//     final ImagePicker _picker = ImagePicker();
//     final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
//     print(image!.path);
//     Reference referenceRoot = FirebaseStorage.instance.ref();
//     Reference referenceDirImage = referenceRoot.child('image');
//     Reference referenceImageToUpload = referenceDirImage.child('${image.name}');
//     try {
//       referenceImageToUpload.putFile(File(image.path));
//       imageUrl = await referenceImageToUpload.getDownloadURL();
//       imageUrls.add(imageUrl);
//     } catch (e) {
//       const CircularProgressIndicator();
//       print(e);
//       print("Zala Bhau");
//     }
//     print("ewkjnfkjnff");
//     print(imageUrls);
//     print(imageUrl);
//     setState(() {});
//   }

//   GestureDetector imagePick(int ind, String options) {
//   bool isLoading = false;

//   return GestureDetector(
//     onTap: () async {
//       if (isLoading) {
//         return; // Prevent multiple taps while the image is still loading
//       }

//       setState(() {
//         isLoading = true;
//       });

//       imageFromGallary();

//       setState(() {
//         isLoading = false;
//       });
//     },
//     child: imageUrls.length < ind + 1
//         ? DottedBorder(
//             color: Colors.black,
//             borderType: BorderType.RRect,
//             radius: const Radius.circular(10),
//             dashPattern: const [10, 4],
//             strokeCap: StrokeCap.round,
//             child: Container(
//               height: 100,
//               width: 100,
//               decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
//               child:  Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         const Icon(
//                           Icons.folder_open,
//                           size: 20,
//                         ),
//                         const SizedBox(
//                           height: 10,
//                         ),
//                         Text(
//                           "$options",
//                           style: TextStyle(fontSize: 13, color: Colors.grey.shade400),
//                         )
//                       ],
//                     ),
//             ),
//           )
//         : Container(
//             height: 100,
//             width: 100,
//             child: Image.network(
//               imageUrls[ind],
//               fit: BoxFit.contain,
//             ),
//           ),
//   );
// }

//   // approximately deal and return date 
//   Widget start_date() {
//     return GestureDetector(
//       onTap: () async {
//         DateTime? newDate = await showDatePicker(
//             context: context, initialDate: DateTime.now(), firstDate: DateTime(2020), lastDate: DateTime(2100));
//         if (newDate == Null) return;
//         setState(() {
//           // print("Sahsdkfdkjbf " + myDateFormat.format(newDate!) as DateTime);
//           // print("kjsfkrskfur : " + newDate.toString());
//           dealdateselected= myDateFormat.format(newDate!);
//         });
//       },
//       child: Container(
//         alignment: Alignment.bottomLeft,
//         decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(10), border: Border.all(width: 2, color: const Color(0xffC5C5C5))),
//         width: getProportionateScreenWidth(320),
//         child: TextButton(
//           onPressed: () {},
//           child: Text(
//             'Deal date :  $dealdateselected',
//             style: const TextStyle(
//               fontSize: 15,
//               color: Colors.black,
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget end_date() {
//     return GestureDetector(
//       onTap: () async {
//         DateTime? newDate = await showDatePicker(
//               context: context, initialDate: DateTime.now(), firstDate: DateTime(2020), lastDate: DateTime(2100));

//           if (newDate == Null) return;
//           print(newDate.toString());
//           setState(() {
//             dealreturndateselected = myDateFormat.format(newDate!);
//             //print(endBidingDate);
//             // endBiddindDate = endBidingDate.
//           });
//           //print("akjddsc" + endBidingDate);
//       },
//       child: Container(
//         alignment: Alignment.bottomLeft,
//         decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(10), border: Border.all(width: 2, color: const Color(0xffC5C5C5))),
//         width: getProportionateScreenWidth(320),
//         child: TextButton(
//           onPressed: () {},
//           child: Text(
//             'Approx Return date :  $dealreturndateselected',
//             style: const TextStyle(
//               fontSize: 15,
//               color: Colors.black,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//   // to calculate time over purpose only 

//   TimeOfDay stringToTimeOfDay(String tod) {
//     final format = DateFormat.jm(); //"6:00 AM"

//     return TimeOfDay.fromDateTime(format.parse(tod));
//   }

//   Widget startDealTime() {
//     return GestureDetector(
//       onTap: () async {
//         TimeOfDay? newTime = await showTimePicker(
//           context: context,
//           initialTime: stringToTimeOfDay(startTime.format(context)),
//         );
//         if (newTime != null) {
//           setState(() {
//             startTime = stringToTimeOfDay(newTime.format(context));
//           });
//         }
//       },
//       child: Container(
//         alignment: Alignment.bottomLeft,
//         decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(10), border: Border.all(width: 2, color: const Color(0xffC5C5C5))),
//         width: 300,
//         child: TextButton(
//           onPressed: () {},
//           child: Text(
//             'Starting Deal Time :  ${startTime.format(context)}',
//             style: const TextStyle(
//               fontSize: 15,
//               color: Colors.black,
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget ReturnTime() {
//     return GestureDetector(
//       onTap: () async {
//         TimeOfDay? newtime = await showTimePicker(
//             context: context,
//             initialTime: stringToTimeOfDay(endTime.format(context)),
//           );
//           if (newtime != null) {
//             endTime = stringToTimeOfDay(newtime.format(context));
            
//           }
//       },
//       child: Container(
//         alignment: Alignment.bottomLeft,
//         decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(10), border: Border.all(width: 2, color: const Color(0xffC5C5C5))),
//         width: 300,
//         child: TextButton(
//           onPressed: () {},
//           child: Text(
//             'Return Time :  ${endTime.format(context)}',
//             style: const TextStyle(
//               fontSize: 15,
//               color: Colors.black,
//             ),
//           ),
//         ),
//       ),
//     );
//   }



//   // adding data to firebase
//   Future<void> addStudentDetails(StudentDetails user) async {
//     final docUser = FirebaseFirestore.instance.collection('StudentDetails').doc();
//     final json = user.toJson();
//     await docUser.set(json);
//     Fluttertoast.showToast(msg: "Details added successfully");
//     Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
//   }


 
//   GestureDetector saveButton() {
//     final FirebaseAuth auth = FirebaseAuth.instance;

//     final User? user = auth.currentUser;
//     final userId = user != null ? user.uid : '';
//     return GestureDetector(
//       onTap: () async {
//         final bookNames = controllerBooksnames.text;
//         final bookList = bookNames.split(',').map((e) => e.trim()).toList();


//         final addDetails = StudentDetails(
//           userId: userId, // Add this line
//           name: controllerName.text,
//           booksnames: bookList,////////////////////////////////////
//           publication: publicationselected!,
//           branch: branchselected!,
//           university: universityselected!,
//           semester: semesterselected!,
//           imageUrls: imageUrls,///////////////
//           deal_date: dealdateselected!,
//           return_date: dealreturndateselected!,
//           startTime: startTime.format(context),
//           endTime: endTime.format(context),
//         );
//         addStudentDetails(addDetails);
//       },
//       child: Container(
//         alignment: Alignment.center,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(15),
//           color: Colors.black,
//         ),
//         width: 120,
//         height: 50,
//         child: const Text(
//           'Save',
//           style: TextStyle(
//             fontFamily: 'f',
//             fontWeight: FontWeight.w600,
//             color: Colors.white,
//             fontSize: 17,
//           ),
//         ),
//       ),
//     );
//   }
// }

// class StudentDetails {
//   final String name;
//   final List<String> booksnames; // Modified to store as a list
//   final String university;
//   final String publication;
//   final String branch;
//   final String semester;
//   final List<String> imageUrls; /// to store the urls of proofs
//   final String deal_date;
//   final String return_date;

//   final String startTime;// only for purpose in order to calculate Time_Over
//   final String endTime;
//   final String userId;


//   StudentDetails({
//     required this.name,
//     required this.booksnames,
//     required this.university,
//     required this.publication,
//     required this.branch,
//     required this.semester,
//     required this.imageUrls,
//     required this.deal_date,
//     required this.return_date,
//     required this.startTime,
//     required this.endTime,
//     required this.userId,

 
    
//   });

//   Map<String, dynamic> toJson() => {
//         'name': name,
//         'publication': publication,
//         'university':university,
//         'branch':branch,
//         'semester': semester,
//         'booksnames':booksnames,
//         'images_of_proofs': imageUrls,
//         'purchase_date':deal_date,
//         'return_date':return_date,
//         'Deal_Time':startTime,
//         'End_Time': endTime,
//         'userId':userId,


//       };
// }
