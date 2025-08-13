import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductCard extends StatefulWidget {
  final Map<String, dynamic> data;
  final String name;
  final int initialCount;
  final void Function(String name, int count) onChanged;

  const ProductCard({
    required this.data,
    required this.name,
    required this.initialCount,
    required this.onChanged,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  late int count;

  @override
  void initState() {
    super.initState();
    count = widget.initialCount;
  }

  void updateCount(int delta) {
    setState(() {
      count += delta;
      if (count < 0) count = 0;
    });
    widget.onChanged(widget.name, count);
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = widget.data['image_url'];
    final price = widget.data['price'];
    final calories = widget.data['calories'];

    return Padding(
      padding: EdgeInsets.only(left: 24, bottom: 4),
      child: Container(
        width: 190,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(6)),
              child: Image.network(
                imageUrl,
                height: 108,
                width: 163,
                fit: BoxFit.cover,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(7.0),
                  child: Text(
                    widget.name,
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    '$calories cal',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    '\$${price.toStringAsFixed(0)}',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: count == 0
                      ? ElevatedButton(
                          onPressed: () => updateCount(1),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepOrange,
                            minimumSize: Size(55, 32),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            "Add",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        )
                      : Row(
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.remove_circle,
                                color: Colors.deepOrange,
                                size: 20,
                              ),
                              onPressed: () => updateCount(-1),
                            ),
                            Text('$count'),
                            IconButton(
                              icon: Icon(
                                Icons.add_circle,
                                color: Colors.deepOrange,
                                size: 20,
                              ),
                              onPressed: () => updateCount(1),
                            ),
                          ],
                        ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
