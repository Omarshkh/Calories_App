import 'package:flutter/material.dart';
import 'package:flutterflow_assesment/Screens/Details/details.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderSummaryScreen extends StatefulWidget {
  final double targetCalories;
  final Map<String, int> selectedItems;
  final Map<String, Map<String, dynamic>> itemDetails;

  const OrderSummaryScreen({
    required this.targetCalories,
    required this.selectedItems,
    required this.itemDetails,
  });

  @override
  State<OrderSummaryScreen> createState() => _OrderSummaryScreenState();
}

class _OrderSummaryScreenState extends State<OrderSummaryScreen> {
  late Map<String, int> selectedItems;

  @override
  void initState() {
    super.initState();
    selectedItems = Map.from(widget.selectedItems);
  }

  void updateItem(String name, int delta) {
    setState(() {
      selectedItems[name] = (selectedItems[name] ?? 0) + delta;
      if (selectedItems[name]! <= 0) {
        selectedItems.remove(name);
      }
    });
  }

  double get totalCalories {
    double sum = 0;
    selectedItems.forEach((name, count) {
      final item = widget.itemDetails[name];
      if (item != null) {
        sum += (item['calories'] ?? 0) * count;
      }
    });
    return sum;
  }

  double get totalPrice {
    double sum = 0;
    selectedItems.forEach((name, count) {
      final item = widget.itemDetails[name];
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

  Future<void> placeOrder() async {
    final List<Map<String, dynamic>> items = selectedItems.entries.map((entry) {
      final name = entry.key;
      final quantity = entry.value;
      final price = widget.itemDetails[name]?['price'] ?? 0;
      return {
        "name": name,
        "total_price": price * quantity,
        "quantity": quantity,
      };
    }).toList();

    final Map<String, dynamic> body = {"items": items};

    // 🔍 Print JSON before sending
    print("Sending JSON to API:");
    print(jsonEncode(body));

    final url = Uri.parse('https://uz8if7.buildship.run/placeOrder');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Order Confirmed!")));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Order Failed: ${response.reasonPhrase}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 246, 244, 244),
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 50),
          child: Text(
            "Order Summary",
            style: GoogleFonts.poppins(fontSize: 20),
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: selectedItems.entries.map((entry) {
                final name = entry.key;
                final count = entry.value;
                final item = widget.itemDetails[name]!;
                final price = item['price'];
                final cal = item['calories'];
                final imageUrl = item['image_url'];

                return Card(
                  color: Colors.white,
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            imageUrl,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      name,
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '\$${price.toStringAsFixed(0)}',
                                    style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '$cal Cal',
                                    style: GoogleFonts.poppins(
                                      color: const Color.fromRGBO(
                                        149,
                                        149,
                                        149,
                                        1,
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          Icons.remove_circle,
                                          color: const Color.fromRGBO(
                                            242,
                                            87,
                                            0,
                                            1,
                                          ),
                                        ),
                                        onPressed: () => updateItem(name, -1),
                                      ),
                                      Text('$count'),
                                      IconButton(
                                        icon: Icon(
                                          Icons.add_circle,
                                          color: const Color.fromRGBO(
                                            242,
                                            87,
                                            0,
                                            1,
                                          ),
                                        ),
                                        onPressed: () => updateItem(name, 1),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 3),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Cals", style: GoogleFonts.poppins(fontSize: 16)),
                      Text(
                        "${totalCalories.toStringAsFixed(0)} Cal out of ${widget.targetCalories.toStringAsFixed(0)} cal",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: const Color.fromRGBO(149, 149, 149, 1),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.only(left: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(" Price", style: GoogleFonts.poppins(fontSize: 16)),
                      Text(
                        "\$${totalPrice.toStringAsFixed(0)}",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: const Color.fromRGBO(242, 87, 0, 1),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 40, top: 15),
                  child: ElevatedButton(
                    onPressed: isWithinTarget ? () => placeOrder() : null,
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(350, 60),
                      backgroundColor: isWithinTarget
                          ? const Color.fromRGBO(242, 87, 0, 1)
                          : Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      "Confirm Order",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
