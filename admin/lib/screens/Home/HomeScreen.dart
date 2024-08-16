import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:globleinfocloud/screens/Home/addbooks.dart';
import 'package:globleinfocloud/screens/Home/comminggrid.dart';
import 'package:globleinfocloud/screens/Home/feedBack.dart';
import 'package:globleinfocloud/screens/Home/order.dart';
import 'package:globleinfocloud/size_config.dart';
import 'package:globleinfocloud/theme/color.dart';
import 'package:globleinfocloud/utils/data.dart';
import 'package:globleinfocloud/widgets/category_box.dart';
import 'package:globleinfocloud/widgets/constants.dart';
import 'package:globleinfocloud/widgets/custom_navigation_bar.dart';
import 'package:globleinfocloud/widgets/enums.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State createState() => _HomePageState();
}

class _HomePageState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      //backgroundColor: Colors.black87,
      body: Body(),
      bottomNavigationBar:
          CustomBottomNavBar(selectedMenu: MenuState.home),
    );
  }


}

class CategorySection extends StatefulWidget {
  const CategorySection({super.key});

  @override
  State createState() => _CategorySectionState();
}

class _CategorySectionState extends State<CategorySection> {
  @override
  Widget build(BuildContext context) {
    return _buildCategories(context);
  }

  Widget _buildCategories(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(20),
        width: getProportionateScreenWidth(310),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: Color.fromRGBO(23, 54, 110, 55),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(
            categories.length,
            growable: false,
            (index) => Padding(
              padding: const EdgeInsets.only(right: 20),
              child: CategoryBox(
                selectedColor: Colors.white,
                data: categories[index],
                onTap: () {
                  _onCategoryTap(categories[index],context);
                },
              ),
            ),
          ),
        ));
  }
}

void _onCategoryTap(Map<String, dynamic> categoryData,BuildContext context) {
  // Navigate to the corresponding category page based on the category name
 
  switch (categoryData["name"]) {
    case "Rent Products":
      // Navigate to the "All" category page
      Navigator.pushNamed(context, '/all_rent');
      break;
    case "Buy Products":
      //Navigate to the "All" category page
      Navigator.pushNamed(context, '/all_buy');
      break;
    default:
      print(categoryData["name"]);
      // Navigate to a default page or handle accordingly
      break;
  }
}

//

class SpecialOfferCard extends StatelessWidget {
  const SpecialOfferCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: getProportionateScreenWidth(20)),
      child: GestureDetector(
        //onTap: press,
        child: SizedBox(
          width: getProportionateScreenWidth(242),
          height: getProportionateScreenWidth(100),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        const Color(0xFFFFFFFF).withOpacity(0.1),
                        const Color(0xFFFFFFFF).withOpacity(0.1),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(15.0),
                    vertical: getProportionateScreenWidth(10),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

const Color primaryColor = Color(0xFF2967FF);
const Color grayColor = Color(0xFF8D8D8E);

const double defaultPadding = 16.0;

class Skeleton extends StatelessWidget {
  const Skeleton({Key? key, this.height, this.width}) : super(key: key);

  final double? height, width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: const EdgeInsets.all(defaultPadding / 2),
      decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.04),
          borderRadius:
              const BorderRadius.all(Radius.circular(defaultPadding))),
    );
  }
}

class CircleSkeleton extends StatelessWidget {
  const CircleSkeleton({Key? key, this.size = 24}) : super(key: key);

  final double? size;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.04),
        shape: BoxShape.circle,
      ),
    );
  }
}

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: getProportionateScreenWidth(10)),
            //HomeHeader(),
            const CustomAppBar(),
            SizedBox(height: getProportionateScreenWidth(20)),
            Padding(
              padding: const EdgeInsets.only(left: 30.0, right: 30),
              child: SizedBox(
                height: 160,
                // width: 500,
                child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: banner.length,
                    itemBuilder: (context, index) {
                      return ClipRRect(
                        borderRadius: const BorderRadius.all(Radius.circular(5)),
                        child: Image.asset(
                          banner[index],
                          //width: 300,
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const SizedBox(
                        width: 40,
                      );
                    }),
              ),
            ),
            SizedBox(height: getProportionateScreenWidth(20)),
            const CategorySection(),
            SizedBox(height: getProportionateScreenHeight(20),),

            
            SizedBox(
                        height: MediaQuery.of(context).size.height ,
                       width: MediaQuery.of(context).size.width,
                        child: OrderListScreen(),
                      ),
          ],
        ),
      ),
    );
  }
}

class CustomAppBar extends StatefulWidget {
  const CustomAppBar({super.key});

  @override
  State createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  final String? currentUserIdphone = FirebaseAuth.instance.currentUser?.phoneNumber;
  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
       const SizedBox( width: 20,),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "GlobleInfoCloud",
                style: TextStyle(
                  color: AppColor.textColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                "New Business World",
                style: TextStyle(
                  color: AppColor.labelColor,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
class BoxForCategories extends StatelessWidget {
  const BoxForCategories({
    Key? key,
    required this.text,
    required this.icon,
    this.press,
  }) : super(key: key);

  final String text, icon;
  final VoidCallback? press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: kPrimaryColor,
          padding: const EdgeInsets.all(20),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          backgroundColor: const Color(0xFFF5F6F9),
        ),
        onPressed: press,
        child: Row(
          children: [
            SvgPicture.asset(
              icon,
              color: kPrimaryColor,
              width: 22,
            ),
            const SizedBox(width: 20),
            Expanded(child: Text(text)),
            const Icon(Icons.arrow_forward_ios),
          ],
        ),
      ),
    );
  }
}
