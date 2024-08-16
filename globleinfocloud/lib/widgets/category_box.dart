import 'package:flutter/material.dart';
import 'package:globleinfocloud/theme/color.dart';

class CategoryBox extends StatelessWidget {
  CategoryBox({
    Key? key,
    required this.data,
    this.isSelected = false,
    this.onTap,
    this.selectedColor = AppColor.actionColor,
  }) : super(key: key);

  final data;
  final Color selectedColor;
  final bool isSelected;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _onTap(context);
      },
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            curve: Curves.fastOutSlowIn,
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: isSelected ? AppColor.red : Colors.white,
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(221, 19, 4, 4),
                  spreadRadius: 1,
                  blurRadius: 1,
                  offset: Offset(1, 1), // changes position of shadow
                ),
              ],
              shape: BoxShape.circle,
            ),
            child: Image.asset(
              data["icon"],
              color: Colors.black,
              width: 30,
              height: 30,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            data["name"],
            maxLines: 1,
            overflow: TextOverflow.fade,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          )
        ],
      ),
    );
  }

  void _onTap(BuildContext context) {
    // Navigate to the corresponding category page based on the category name
    switch (data["name"]) {
      case "Rent Products":
        Navigator.pushNamed(context, '/all_rent');
        break;
      case "Buy Products":
      //Navigate to the "All" category page
      Navigator.pushNamed(context, '/all_buy');
      break;
      case "Add Info":
        Navigator.pushNamed(context, '/add_student_details');
        break;
      case "TimeLeft":
        Navigator.pushNamed(context, '/book_purchase_details');
        break;
      // Add cases for other categories as needed
      default:
        // Navigate to a default page or handle accordingly
        break;
    }
  }
}
