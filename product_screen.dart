import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_assesment/Screens/ProductScreen/productcart.dart';
import 'package:flutterflow_assesment/ordersummary/OrderSummary.dart';
import 'package:google_fonts/google_fonts.dart';

// Make sure ProductCard is in the same file or import it if separated

class ProductScreen extends StatefulWidget {
  final double targetCalories;

  const ProductScreen({required this.targetCalories});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final Map<String, int> selectedItems = {};
  final Map<String, Map<String, dynamic>> itemDetails = {};

  double get totalCalories {
    double sum = 0;
    selectedItems.forEach((name, count) {
      final item = itemDetails[name];
      if (item != null) {
        sum += (item['calories'] ?? 0) * count;
      }
    });
    return sum;
  }

  double get totalPrice {
    double sum = 0;
    selectedItems.forEach((name, count) {
      final item = itemDetails[name];
      if (item != null) {
        sum += (item['price'] ?? 0) * count;
      }
    });
    return sum;
  }

  bool get isWithinTarget {
    final lower = widget.targetCalories * 0.9;
    final upper = widget.targetCalories * 1.1;
    return totalCalories >= lower && totalCalories <= upper;
  }

  Widget buildSection(String title, String collectionName) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.only(left: 24),
          child: Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        SizedBox(height: 8),
        SizedBox(
          height: 210,
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection(collectionName)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(child: Text('No items found'));
              }
              final docs = snapshot.data!.docs;
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  final data = docs[index].data() as Map<String, dynamic>;
                  final name = data['food_name'];

                  return ProductCard(
                    data: data,
                    name: name,
                    initialCount: selectedItems[name] ?? 0,
                    onChanged: (name, count) {
                      setState(() {
                        if (count == 0) {
                          selectedItems.remove(name);
                        } else {
                          selectedItems[name] = count;
                        }
                        itemDetails[name] = data;
                      });
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 242, 241, 241),
      appBar: AppBar(
        title: Text(
          'Create your order',
          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    buildSection("Vegetables", "vegetables"),
                    buildSection("Meats", "meats"),
                    buildSection("Carbs", "carbs"),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Cal", style: GoogleFonts.poppins(fontSize: 16)),
                      Text(
                        "${totalCalories.toStringAsFixed(0)} Cal out of ${widget.targetCalories.toStringAsFixed(0)} Cal",
                        style: GoogleFonts.poppins(fontSize: 16),
                      ),
                    ],
                  ),
                  SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Price", style: GoogleFonts.poppins(fontSize: 16)),
                      Text(
                        "\$${totalPrice.toStringAsFixed(0)}",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: const Color.fromRGBO(242, 87, 0, 1),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: ElevatedButton(
                onPressed: isWithinTarget
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OrderSummaryScreen(
                              targetCalories: widget.targetCalories,
                              selectedItems: selectedItems,
                              itemDetails: itemDetails,
                            ),
                          ),
                        );
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(350, 60),
                  backgroundColor: isWithinTarget
                      ? const Color.fromRGBO(242, 87, 0, 1)
                      : const Color.fromRGBO(234, 236, 240, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  "Place Order",
                  style: GoogleFonts.poppins(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
