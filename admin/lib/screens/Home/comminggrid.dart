
import 'package:flutter/material.dart';


class CommingList extends StatefulWidget {
  @override
  State createState() => _CommingListState();
}


class _CommingListState extends State{
  final List<String> name = ["New Products", "New Products", "New Products", "New Products"];

  @override
  Widget build(BuildContext context) {
    // Get screen width and height
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Determine the crossAxisCount and childAspectRatio based on screen width
    int crossAxisCount;
    double childAspectRatio;
    double containerHeight;
    double containerWidth;

    if (screenWidth <600) {
      // For small screens
      crossAxisCount = 2;
      childAspectRatio = 1.2;
      containerHeight = screenHeight * 0.1;
      containerWidth = screenWidth * 0.4;
    } else {
      // For larger screens
      crossAxisCount = 4;
      childAspectRatio = 1.5;
      containerHeight = screenHeight * 0.15;
      containerWidth = screenWidth * 0.2;
    }

    return Scaffold(
     
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: GridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount, // Number of columns
            childAspectRatio: childAspectRatio,
            crossAxisSpacing: 10, // Spacing between columns
            mainAxisSpacing: 10, // Spacing between rows
          ),
          itemCount: 4,
          itemBuilder: (context, index) {
            return Column(
              children: [
                Container(
                  height: containerHeight,
                  width: containerWidth,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey, width: 2),
                    boxShadow:const [ 
                      BoxShadow(color: Colors.black12,offset: Offset(-4, 4),blurRadius: 5),
                     // BoxShadow(color: Colors.black,offset: Offset(4, 4),blurRadius: 0.5),
                      BoxShadow(color: Colors.black12,offset: Offset(4, -4),blurRadius: 5),
                     // BoxShadow(color: Colors.black,offset: Offset(-4, -4),blurRadius: 0.5),
                      
                    ]
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                    child: Image.asset(
                      "assets/images/26690.jpg",
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  name[index],
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}