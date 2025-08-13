import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutterflow_assesment/Screens/ProductScreen/product_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class EnterDetailsScreen extends StatefulWidget {
  @override
  _EnterDetailsScreenState createState() => _EnterDetailsScreenState();
}

class _EnterDetailsScreenState extends State<EnterDetailsScreen> {
  String? selectedGender;
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController ageController = TextEditingController();

  bool get isFormComplete {
    return selectedGender != null &&
        weightController.text.isNotEmpty &&
        heightController.text.isNotEmpty &&
        ageController.text.isNotEmpty;
  }

  @override
  void initState() {
    super.initState();
    weightController.addListener(_updateState);
    heightController.addListener(_updateState);
    ageController.addListener(_updateState);
  }

  void _updateState() {
    setState(() {});
  }

  @override
  void dispose() {
    weightController.dispose();
    heightController.dispose();
    ageController.dispose();
    super.dispose();
  }

  void calculateAndNavigate() {
    double weight = double.tryParse(weightController.text) ?? 0;
    double height = double.tryParse(heightController.text) ?? 0;
    int age = int.tryParse(ageController.text) ?? 0;
    double calories = 0.0;

    if (selectedGender == 'Female') {
      calories = 655.1 + (9.56 * weight) + (1.85 * height) - (4.67 * age);
    } else if (selectedGender == 'Male') {
      calories = 666.47 + (13.75 * weight) + (5 * height) - (6.75 * age);
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductScreen(targetCalories: calories),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool enableNext = isFormComplete;

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: Text('Enter your details'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Gender',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton2<String>(
                  isExpanded: true,
                  hint: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      "Choose your gender",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: const Color.fromRGBO(149, 149, 149, 1),
                      ),
                    ),
                  ),
                  value: selectedGender,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedGender = newValue;
                    });
                  },
                  items: ['Male', 'Female'].map((String gender) {
                    return DropdownMenuItem<String>(
                      value: gender,
                      child: StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                          final isItemSelected = selectedGender == gender;
                          return Container(
                            decoration: BoxDecoration(
                              color: isItemSelected
                                  ? Colors.orange.withOpacity(0.1)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    gender,
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      color: isItemSelected
                                          ? Colors.orange
                                          : Colors.black,
                                    ),
                                  ),
                                  Spacer(),
                                  if (isItemSelected)
                                    Icon(Icons.check, color: Colors.orange),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }).toList(),
                  dropdownStyleData: DropdownStyleData(
                    maxHeight: 200,
                    width: MediaQuery.of(context).size.width - 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Colors.white,
                    ),
                    offset: const Offset(0, -5),
                    scrollbarTheme: ScrollbarThemeData(
                      radius: const Radius.circular(40),
                      thickness: MaterialStateProperty.all<double>(6),
                      thumbVisibility: MaterialStateProperty.all<bool>(true),
                    ),
                  ),
                  buttonStyleData: ButtonStyleData(
                    height: 50,
                    width: double.infinity,
                    padding: const EdgeInsets.only(left: 14, right: 14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.grey.shade300),
                      color: Colors.white,
                    ),
                  ),
                  iconStyleData: const IconStyleData(
                    icon: Icon(Icons.arrow_drop_down),
                    iconSize: 24,
                    iconEnabledColor: Colors.grey,
                    iconDisabledColor: Colors.grey,
                  ),
                  menuItemStyleData: const MenuItemStyleData(
                    height: 40,
                    padding: EdgeInsets.only(left: 14, right: 14),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Rest of your form fields remain the same...
            Text(
              'Weight',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: weightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                suffixText: "Kg",
                hintText: "Enter your weight",
                hintStyle: GoogleFonts.poppins(
                  fontSize: 16,
                  color: const Color.fromRGBO(149, 149, 149, 1),
                ),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),

            Text(
              'Height',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: heightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                suffixText: "Cm",
                hintText: "Enter your height",
                hintStyle: GoogleFonts.poppins(
                  fontSize: 16,
                  color: const Color.fromRGBO(149, 149, 149, 1),
                ),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),

            Text(
              'Age',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: ageController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Enter your age in years",
                hintStyle: GoogleFonts.poppins(
                  fontSize: 16,
                  color: const Color.fromRGBO(149, 149, 149, 1),
                ),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 240),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: enableNext ? calculateAndNavigate : null,
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(327, 60),
                  backgroundColor: enableNext
                      ? Color.fromRGBO(242, 87, 0, 1)
                      : Colors.grey.shade300,
                  foregroundColor: enableNext
                      ? Colors.white
                      : Colors.grey.shade600,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text("Next"),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
