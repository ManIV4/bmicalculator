import 'package:flutter/material.dart';

void main() {
  runApp(const BMICalculatorApp());
}

class BMICalculatorApp extends StatelessWidget {
  const BMICalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const BMIScreen(),
    );
  }
}

class BMIScreen extends StatefulWidget {
  const BMIScreen({super.key}); // Added constructor with key

  @override
  State<BMIScreen> createState() => _BMIScreenState();
}

class _BMIScreenState extends State<BMIScreen> {
  bool isMetric = true;

  final TextEditingController heightCmController = TextEditingController();
  final TextEditingController heightFeetController = TextEditingController();
  final TextEditingController heightInchesController = TextEditingController();
  final TextEditingController weightController = TextEditingController();

  String _resultText = "Result will appear here";
  TextStyle _resultStyle = const TextStyle(
    fontSize: 18,
    fontStyle: FontStyle.italic,
    color: Colors.grey,
  );

  @override
  Widget build(BuildContext context) {
    // --- MODIFICATION: DISMISS KEYBOARD ON TAP ---
    // We wrap the entire screen in a GestureDetector.
    // When the user taps anywhere on the screen (outside of an
    // interactive element like a text field or button),
    // it will remove focus and dismiss the keyboard.
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("BMI Calculator"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Toggle between Metric / Imperial
              ToggleButtons(
                isSelected: [isMetric, !isMetric],
                onPressed: (index) {
                  setState(() {
                    isMetric = index == 0;
                    heightCmController.clear();
                    heightFeetController.clear();
                    heightInchesController.clear();
                    weightController.clear();
                    _resultText = "Result will appear here";
                    _resultStyle = const TextStyle(
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey,
                    );
                  });
                },
                children: const [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text("Metric"),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text("Imperial"),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Metric input fields
              if (isMetric) ...[
                TextField(
                  controller: heightCmController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Height (cm)",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
              ]
              // Imperial input fields
              else ...[
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: heightFeetController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: "Height (ft)",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: heightInchesController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: "Height (in)",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],

              // Weight input (used for both)
              TextField(
                controller: weightController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: isMetric ? "Weight (kg)" : "Weight (lbs)",
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 30),

              //Calculate Button
              ElevatedButton(
                onPressed: () {
                  // Dismiss keyboard when button is pressed
                  FocusScope.of(context).unfocus();

                  final double? weight = double.tryParse(weightController.text);
                  double? bmi;
                  String category = "";
                  Color categoryColor = Colors.red;
                  TextStyle errorStyle = const TextStyle(
                      fontSize: 18,
                      color: Colors.red,
                      fontStyle: FontStyle.italic);

                  //Check weight
                  if (weight == null || weight <= 0) {
                    setState(() {
                      _resultText = "Please enter a valid weight.";
                      _resultStyle = errorStyle;
                    });
                    return;
                  }

                  if (isMetric) {
                    final double? heightCm =
                    double.tryParse(heightCmController.text);
                    if (heightCm == null || heightCm <= 0) {
                      setState(() {
                        _resultText = "Please enter a valid height in cm.";
                        _resultStyle = errorStyle;
                      });
                      return;
                    }
                    // BMI Formula: weight (kg) / [height (m)]^2
                    double heightM = heightCm / 100;
                    bmi = weight / (heightM * heightM);
                  } else {
                    // Imperial calculation
                    final double? heightFt =
                    double.tryParse(heightFeetController.text);
                    final double? heightIn =
                    double.tryParse(heightInchesController.text);

                    // Default to 0 if a field is empty
                    final double ft = heightFt ?? 0;
                    final double inches = heightIn ?? 0;

                    if (ft <= 0 && inches <= 0) {
                      setState(() {
                        _resultText = "Please enter a valid height (ft/in).";
                        _resultStyle = errorStyle;
                      });
                      return;
                    }
                    // Convert total height to inches
                    double totalHeightInInches = (ft * 12) + inches;
                    // BMI Formula: 703 * weight (lbs) / [height (in)]^2
                    bmi = 703 * (weight / (totalHeightInInches * totalHeightInInches));
                  }

                  // Determine Category
                  if (bmi < 18.5) {
                    category = "Underweight";
                    categoryColor = Colors.blue;
                  } else if (bmi < 25) {
                    category = "Normal";
                    categoryColor = Colors.green;
                  } else if (bmi < 30) {
                    category = "Overweight";
                    categoryColor = Colors.orange;
                  } else {
                    // This covers all Obese categories
                    category = "Obese";
                    categoryColor = Colors.red;
                  }

                  // 4. Update UI State with the result
                  setState(() {
                    // \n is a "new line" character
                    _resultText =
                    "Your BMI is: ${bmi!.toStringAsFixed(1)}\n($category)";
                    _resultStyle = TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: categoryColor,
                    );
                  });
                },
                child: const Text("Calculate BMI"),
              ),

              const SizedBox(height: 20),

              // --- UPDATED: Placeholder for results ---
              Text(
                _resultText,
                style: _resultStyle,
                textAlign: TextAlign.center, // Added for better multi-line display
              ),
            ],
          ),
        ),
      ),
    );
  }
}