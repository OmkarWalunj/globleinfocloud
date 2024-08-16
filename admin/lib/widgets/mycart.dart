import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:globleinfocloud/screens/Home/ProductModel.dart';
import 'package:globleinfocloud/widgets/razorpay_payment_rent.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';


class CartScreen extends StatelessWidget {
  

  CartScreen({super.key});
  

  
  @override
  Widget build(BuildContext context) {
    // Get the current user ID
    String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
    List<String> Buyproduct=[];
  double amount=0;

    if (currentUserId == null) {
      // Handle the case where the user is not signed in
      return Scaffold(
        appBar: AppBar(
          title: const Text('My Cart'),
        ),
        body: const Center(
          child: Text('Please sign in to view your cart.'),
        ),
      );
    }

    return Scaffold(
        
        appBar: AppBar( 
          centerTitle: true,
          title:Text(
                    "My Rent Cart",
                    style: GoogleFonts.ubuntu(
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                    ),
                  )
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: GestureDetector(onTap: (){
          if(amount>0){
            Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RazorpayPaymentRent(
                          amount: amount,
                          bookName : Buyproduct
                        ),
                      ),
                    );
          }
        },child: Container(
          height: 40,
          width: 100,
          alignment: Alignment.center,
          decoration: const BoxDecoration( 
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: Color.fromARGB(255, 192, 30, 233)
          ),
          child: const Text("Buy All",style: const TextStyle(fontSize: 20, color: Colors.white),)),),
        body: Stack(children: [
          
          
          Positioned.fill(
            top: 10,
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('cart_Rent')
                  .where('userId', isEqualTo: currentUserId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }

                List<QueryDocumentSnapshot> cartDocs = snapshot.data!.docs;

                if (cartDocs.isEmpty) {
                  amount=0;
                Buyproduct.clear();
                  return const Center(
                    child: Text('Your cart is empty.'),
                  );
                }
                amount=0;
                Buyproduct.clear();
                return ListView.builder(
                  itemCount: cartDocs.length,
                  itemBuilder: (context, index) {
                    // Get data from each document in the cart collection
                    Map<String, dynamic> data =
                        cartDocs[index].data() as Map<String, dynamic>;
                        Buyproduct.add(data['name']);
                        amount += data['price'] as double;

                    return Dismissible(
                      key: UniqueKey(),
                      onDismissed: (direction) async {
                        // Remove the item from the cart when dismissed
                        await FirebaseFirestore.instance
                            .collection('cart_Rent')
                            .doc(cartDocs[index].id)
                            .delete();
                      },
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        child: const Icon(
                          Icons.delete,
                          color: Colors.white,
                          size: 36,
                        ),
                      ),
                      direction: DismissDirection.endToStart,
                      child: GestureDetector(
                        onTap: () async {
                          try {
                            // Get the productId of the selected item in the cart
                            String productId = cartDocs[index]['id'];

                            // Query the products collection in Firestore to find the product with the matching productId
                            DocumentSnapshot productSnapshot =
                                await FirebaseFirestore.instance
                                    .collection('products')
                                    .doc(productId)
                                    .get();

                            // Check if the product exists
                            if (productSnapshot.exists) {
                              // Construct the Product object using data from Firestore
                              Product product =
                                  Product.fromFirestore(productSnapshot);

                              // Navigate to ProductDetailScreen
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CartDetailScreen(
                                    product: product,
                                  ),
                                ),
                              );
                            } else {
                              print('Product not found');
                              // Handle the case where the product document does not exist
                            }
                          } catch (e) {
                            print('Error fetching product details: $e');
                            // Handle any errors that occur during the process
                          }
                        },
                        child: Card(
                          elevation: 8,
                          margin: const EdgeInsets.only(
                              left: 20, right: 20, bottom: 20),
                          child: ListTile(
                            leading: CircleAvatar(
                                backgroundImage:
                                    NetworkImage(data['imageUrl'])),
                            title: Text(data['name']),
                            subtitle: Text('\u{20B9} ${data['price']}'),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () async {
                                // Save a reference to the document before deleting it
                                DocumentSnapshot removedProduct =
                                    cartDocs[index];

                                // Remove the item from the cart when the remove icon is pressed
                                await FirebaseFirestore.instance
                                    .collection('cart_Rent')
                                    .doc(cartDocs[index].id)
                                    .delete();

                                // Show a popup (SnackBar) to notify the user that the product has been removed
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        '${data['name']} removed from the cart.'),
                                    action: SnackBarAction(
                                      label: 'Undo',
                                      onPressed: () async {
                                        // Undo action: Re-add the product to the cart
                                        await FirebaseFirestore.instance
                                            .collection('cart_Rent')
                                            .add(
                                              removedProduct.data() as Map<
                                                  String,
                                                  dynamic>, // Cast to Map<String, dynamic>
                                            );
                                        
                                        // You may want to handle any additional logic related to undoing the action
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                            // Add more fields as needed
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ]));
  }
}
class CartDetailScreen extends StatefulWidget {
  final Product product;

  const CartDetailScreen({Key? key, required this.product})
      : super(key: key);

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<CartDetailScreen> {
  late String productUserName = '';
  late String profilePic = '';
  final String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
  Future<void> fetchUserName(String userId) async {
    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userSnapshot.exists) {
        setState(() {
          productUserName = userSnapshot['name'];
          profilePic = userSnapshot['profilePic'];
        });
      }
    } catch (e) {
      print('Error fetching user name: $e');
    }
  }

  void addToCart(BuildContext context, Product product) async {
    try {
      // Check if the product is already in the cart
      log(currentUserId as num);
      QuerySnapshot cartSnapshot = await FirebaseFirestore.instance
          .collection('cart_Rent')
          .where('userId', isEqualTo: currentUserId)
          .where('id', isEqualTo: product.id)
          .get();

      if (cartSnapshot.docs.isNotEmpty) {
        // If the product is already in the cart, show a tooltip
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${product.name} is already in your cart.'),
          ),
        );
      } else {
        // If the product is not in the cart, add it to Firestore
        await FirebaseFirestore.instance.collection('cart_Rent').add({
          'id': product.id,
          'name': product.name,
          'price': product.price,
          'imageUrl': product.imageUrl,
          'ProductId': product.userId,
          'Description': product.description,
          'userId': currentUserId,
          // Add other fields as needed
        });
        print('Added ${product.name} to cart');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${product.name} added to your cart.'),
          ),
        );
      }
    } catch (e) {
      print('Error adding product to cart: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    // Call fetchUserName method in initState to fetch user name
    fetchUserName(widget.product.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        centerTitle: true,
       title: Text(
                "Book Details",
                style: GoogleFonts.ubuntu(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            
            Container(
              margin: const EdgeInsets.only(left: 30, right: 30, bottom: 20),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height *
                  0.3, // Set a fixed height for the container
              decoration: ShapeDecoration(
                image: DecorationImage(
                  image: NetworkImage(widget.product.imageUrl),
                  fit: BoxFit.fill,
                ),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16)),
                ),
              ),
            ),
            Text(
              widget.product.name,
              style: GoogleFonts.ubuntu(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            Text(
              '\u{20B9} ${widget.product.price.toStringAsFixed(2)}',
              style: GoogleFonts.ubuntu(
                fontWeight: FontWeight.w400,
                fontSize: 15,
              ),
            ),
            const Divider(
              color: Colors.black26,
              thickness: 2,
              height: 20,
              indent: 90,
              endIndent: 90,
            ),
            Text(
              'Description',
              textAlign: TextAlign.center,
              style: GoogleFonts.ubuntu(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            Center(
              child: SizedBox(
                  width: 300,
                  child: Text(
                    widget.product.description,
                    textAlign: TextAlign.center,
                  )),
            ),
             const Divider(
              color: Colors.black26,
              thickness: 2,
              height: 20,
              indent: 80,
              endIndent: 80,
            ),
           Text(
              'Book Type : ${widget.product.type}',
              textAlign: TextAlign.center,
              style: GoogleFonts.ubuntu(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
                 const Divider(
              color: Colors.black26,
              thickness: 2,
              height: 20,
              indent: 80,
              endIndent: 80,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "University : ",
                style: GoogleFonts.lato(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Text(
                widget.product.univercity,
                style: GoogleFonts.lato(
                   fontWeight: FontWeight.w600,
                fontSize: 16,
                ),
              ),
            ],
          ),
          const Divider(
              color: Colors.black26,
              thickness: 2,
              height: 20,
              indent: 80,
              endIndent: 80,
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Branch : ",
                style: GoogleFonts.lato(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Text(
                widget.product.branch,
                style: GoogleFonts.lato(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ],
          ),
         const Divider(
              color: Colors.black26,
              thickness: 2,
              height: 20,
              indent: 80,
              endIndent: 80,
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Semester : ",
                style: GoogleFonts.lato(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Text(
                widget.product.sem,
                style: GoogleFonts.lato(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const Divider(
              color: Colors.black26,
              thickness: 2,
              height: 20,
              indent: 80,
              endIndent: 80,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.yellow),
                    height: 45,
                    width: 170,
                    child:  Center(child: Text("Buy",style: GoogleFonts.ubuntu(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),)),
                  ),
                  onTap: () {
                     Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RazorpayPaymentRent(
                          amount: widget.product.price,
                          bookName : [widget.product.name]
                        ),
                      ),
                    );
                  },
                )
              ],
            ),
            const SizedBox( 
              height: 20,
            )
     
          ],
        ),
      ),
    );
  }
}