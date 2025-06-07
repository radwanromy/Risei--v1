import 'package:flutter/material.dart';

enum BmiUnit { metric, imperial }

class BmiEntry {
  final double weight;
  final double height;
  final BmiUnit unit;
  final double bmi;
  final DateTime date;

  BmiEntry({
    required this.weight,
    required this.height,
    required this.unit,
    required this.bmi,
    required this.date,
  });
}

class BmiCalculatorSection extends StatefulWidget {
  final void Function(double bmi)? onBmiUpdated;

  const BmiCalculatorSection({super.key, this.onBmiUpdated});

  @override
  State<BmiCalculatorSection> createState() => _BmiCalculatorSectionState();
}

class _BmiCalculatorSectionState extends State<BmiCalculatorSection> {
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  BmiUnit _selectedUnit = BmiUnit.metric;
  double? _bmi;
  String? _bmiStatus;
  String? _bmiAdvice;

  final List<BmiEntry> _bmiHistory = [];

  void _updateAdvice(double bmi) {
    if (bmi < 18.5) {
      _bmiStatus = "Underweight";
      _bmiAdvice = "Your BMI is below the healthy range. Consider consulting a nutritionist or healthcare provider to ensure you're getting proper nutrition.";
    } else if (bmi < 25) {
      _bmiStatus = "Normal";
      _bmiAdvice = "Great job! Your BMI is in the healthy range. Keep maintaining your healthy lifestyle.";
    } else if (bmi < 30) {
      _bmiStatus = "Overweight";
      _bmiAdvice = "Your BMI is above the healthy range. Consider regular exercise and a balanced diet to reach a healthier weight.";
    } else {
      _bmiStatus = "Obese";
      _bmiAdvice = "Your BMI is quite high. Consult with your healthcare provider for a personalized plan to improve your health.";
    }
  }

  void _calculateBmi() {
    final weight = double.tryParse(_weightController.text);
    final height = double.tryParse(_heightController.text);

    if (weight == null || height == null || height == 0) {
      setState(() {
        _bmi = null;
        _bmiStatus = null;
        _bmiAdvice = null;
      });
      return;
    }

    double bmi;
    if (_selectedUnit == BmiUnit.metric) {
      bmi = weight / ((height / 100) * (height / 100));
    } else {
      // Imperial formula: BMI = 703 * (weight in pounds) / (height in inches)^2
      bmi = 703 * weight / (height * height);
    }

    _updateAdvice(bmi);

    setState(() {
      _bmi = bmi;
    });

    widget.onBmiUpdated?.call(bmi);

    // Add to history (useful if the user clicks "Save")
  }

  void _saveBmiEntry() {
    final weight = double.tryParse(_weightController.text);
    final height = double.tryParse(_heightController.text);

    if (weight == null || height == null || height == 0 || _bmi == null) return;

    setState(() {
      _bmiHistory.insert(0, BmiEntry(
        weight: weight,
        height: height,
        unit: _selectedUnit,
        bmi: _bmi!,
        date: DateTime.now(),
      ));
    });
  }

  void _showBmiHistoryPopup() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("BMI History"),
        content: SizedBox(
          width: double.maxFinite,
          child: _bmiHistory.isEmpty
              ? const Text("No BMI data saved yet.")
              : ListView.separated(
              BmiCalculatorSection(),
                  shrinkWrap: true,
                  itemCount: _bmiHistory.length,
                  separatorBuilder: (_, __) => const Divider(height: 18),
                  itemBuilder: (context, i) {
                    final entry = _bmiHistory[i];
                    final dateStr =
                        "${entry.date.year}-${entry.date.month.toString().padLeft(2, '0')}-${entry.date.day.toString().padLeft(2, '0')} "
                        "${entry.date.hour.toString().padLeft(2, '0')}:${entry.date.minute.toString().padLeft(2, '0')}";
                    return ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        "BMI: ${entry.bmi.toStringAsFixed(1)} (${_statusForBmi(entry.bmi)})",
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(
                          "Weight: ${entry.weight} ${entry.unit == BmiUnit.metric ? "kg" : "lb"}\n"
                          "Height: ${entry.height} ${entry.unit == BmiUnit.metric ? "cm" : "in"}\n"
                          "Date: $dateStr"),
                    );
                  },
                ),
        ),
        actions: [
          TextButton(
            child: const Text("Close"),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ),
    );
  }

  String _statusForBmi(double bmi) {
    if (bmi < 18.5) return "Underweight";
    if (bmi < 25) return "Normal";
    if (bmi < 30) return "Overweight";
    return "Obese";
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMetric = _selectedUnit == BmiUnit.metric;

    return Card(
      color: const Color(0xFFE6FCD9),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      margin: const EdgeInsets.only(bottom: 18),
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.calculate_rounded, color: Color(0xFF64A049), size: 36),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "BMI Calculator",
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: "BMI History",
                  icon: const Icon(Icons.history, color: Color(0xFF64A049)),
                  onPressed: _showBmiHistoryPopup,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              "Enter your weight and height to check your BMI. Select your preferred unit:",
              style: theme.textTheme.bodyMedium?.copyWith(color: Colors.black54),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<BmiUnit>(
                    value: _selectedUnit,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Unit",
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: BmiUnit.metric,
                        child: Text("Metric (kg, cm)"),
                      ),
                      DropdownMenuItem(
                        value: BmiUnit.imperial,
                        child: Text("Imperial (lb, in)"),
                      ),
                    ],
                    onChanged: (val) {
                      if (val != null) {
                        setState(() => _selectedUnit = val);
                        _calculateBmi();
                      }
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _weightController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: isMetric ? "Weight (kg)" : "Weight (lb)",
                      border: const OutlineInputBorder(),
                    ),
                    onChanged: (_) => _calculateBmi(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _heightController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: isMetric ? "Height (cm)" : "Height (in)",
                      border: const OutlineInputBorder(),
                    ),
                    onChanged: (_) => _calculateBmi(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[700],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () {
                    _calculateBmi();
                    _saveBmiEntry();
                  },
                  icon: const Icon(Icons.save),
                  label: const Text("Save BMI"),
                ),
                const SizedBox(width: 16),
                if (_bmi != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: _bmi! < 18.5 || _bmi! >= 30
                          ? Colors.red[100]
                          : _bmi! < 25
                              ? Colors.green[100]
                              : Colors.orange[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Text(
                          "BMI: ${_bmi!.toStringAsFixed(1)}",
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: _bmi! < 18.5 || _bmi! >= 30
                                ? Colors.red
                                : _bmi! < 25
                                    ? Colors.green
                                    : Colors.orange,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          _bmiStatus ?? "",
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: _bmiStatus == "Normal"
                                ? Colors.green
                                : _bmiStatus == "Underweight"
                                    ? Colors.orange
                                    : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  )
              ],
            ),
            if (_bmiAdvice != null)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  _bmiAdvice!,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
