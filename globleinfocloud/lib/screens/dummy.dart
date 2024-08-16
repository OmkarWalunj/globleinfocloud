// import 'dart:html';
// import 'dart:js';

// import 'package:flutter/material.dart';
// import 'package:movison/utils/data.dart';

// class CategorySection extends StatefulWidget {
//   @override
//   _CategorySectionState createState() => _CategorySectionState();
// }

// class _CategorySectionState extends State<CategorySection> {
//   // final List<Map<String, dynamic>> categories = [
//   //   {"name": "Rent"},
//   //   {"name": "Add Info"},
//   //   {"name": "TimeLeft"},
//   //   // Add other categories as needed
//   // ];

//   @override
//   Widget build(BuildContext context) {
//     return _buildCategories();
//   }

//   Widget _buildCategories() {
//     return TextButton(
//         style: TextButton.styleFrom(
//           primary: Colors.black26,
//           padding: EdgeInsets.all(20),
//           shape:
//               RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//           backgroundColor: Color(0xFFF5F6F9),
//         ),
//         onPressed: () {},
//         child: SingleChildScrollView(
//           padding: EdgeInsets.fromLTRB(15, 10, 0, 10),
//           scrollDirection: Axis.horizontal,
//           child: Row(
//             children: List.generate(
//               categories.length,
//               (index) => Padding(
//                 padding: const EdgeInsets.only(right: 15),
//                 child: CategoryBox(
//                   selectedColor: Colors.white,
//                   data: categories[index],
//                   onTap: () {
//                     _onCategoryTap(categories[index]);
//                   },
//                 ),
//               ),
//             ),
//           ),
//         ));
//   }
// }
