import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'dart:async';

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

class CustomHealthData {
  double? weight;
  double? height;
  double? bmi;
  double? restingHeartRate;

  CustomHealthData({this.weight, this.height, this.bmi, this.restingHeartRate});

  double calculateBmi() {
    if (weight != null && height != null && height! > 0) {
      return weight! / ((height! / 100) * (height! / 100));
    }
    return 0.0;
  }
}

class WellbeingScreen extends StatefulWidget {
  const WellbeingScreen({Key? key}) : super(key: key);

  @override
  State<WellbeingScreen> createState() => _WellbeingScreenState();
}

class _WellbeingScreenState extends State<WellbeingScreen> {
  final HealthFactory _health = HealthFactory();

  int stepsToday = 0;
  double kmToday = 0.0;
  double weight = 0.0;
  double bmi = 0.0;
  double height = 0.0;
  double restingHeartRate = 0.0;
  int wellbeingTasksPercent = 0;
  DateTime lastUpdate = DateTime.now();

  bool _isAuthorized = false;
  bool _isLoading = true;
  bool _manualMode = false;
  CustomHealthData customHealthData = CustomHealthData();

  // --- BMI Section State ---
  final TextEditingController _bmiWeightController = TextEditingController();
  final TextEditingController _bmiHeightController = TextEditingController();
  BmiUnit _bmiSelectedUnit = BmiUnit.metric;
  double? _bmiValue;
  String? _bmiStatus;
  String? _bmiAdvice;
  final List<BmiEntry> _bmiHistory = [];

  final types = <HealthDataType>[
    HealthDataType.STEPS,
    HealthDataType.WEIGHT,
    HealthDataType.HEIGHT,
    HealthDataType.HEART_RATE,
    HealthDataType.BODY_MASS_INDEX,
  ];

  @override
  void initState() {
    super.initState();
    _initHealth();
  }

  Future<void> _initHealth() async {
    setState(() {
      _isLoading = true;
      _manualMode = false;
    });
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day);
    final yesterday = midnight.subtract(const Duration(days: 1));

    bool authorized = await _health.requestAuthorization(types);
    if (!authorized) {
      setState(() {
        _isAuthorized = false;
        _isLoading = false;
      });
      return;
    }
    _isAuthorized = true;

    List<HealthDataPoint> healthData = [];

    try {
      healthData = await _health.getHealthDataFromTypes(
        yesterday,
        now,
        types,
      );
      healthData = HealthFactory.removeDuplicates(healthData);

      int steps = 0;
      double? weightVal;
      double? heightVal;
      double? bmiVal;
      double? hrVal;
      DateTime? stepUpdate;
      DateTime? weightUpdate;
      DateTime? heightUpdate;
      DateTime? bmiUpdate;
      DateTime? hrUpdate;

      for (var point in healthData) {
        switch (point.type) {
          case HealthDataType.STEPS:
            steps += (point.value as num).toInt();
            if (stepUpdate == null || point.dateFrom.isAfter(stepUpdate)) {
              stepUpdate = point.dateFrom;
            }
            break;
          case HealthDataType.WEIGHT:
            weightVal = (point.value as num).toDouble();
            weightUpdate = point.dateFrom;
            break;
          case HealthDataType.HEIGHT:
            heightVal = (point.value as num).toDouble();
            heightUpdate = point.dateFrom;
            break;
          case HealthDataType.BODY_MASS_INDEX:
            bmiVal = (point.value as num).toDouble();
            bmiUpdate = point.dateFrom;
            break;
          case HealthDataType.HEART_RATE:
            hrVal = (point.value as num).toDouble();
            hrUpdate = point.dateFrom;
            break;
          default:
            break;
        }
      }

      double bmiCalc = bmiVal ??
          ((weightVal != null && heightVal != null && heightVal > 0)
              ? weightVal / ((heightVal / 100) * (heightVal / 100))
              : 0.0);

      double km = steps * 0.0008;

      setState(() {
        stepsToday = steps;
        kmToday = km;
        weight = weightVal ?? 0.0;
        height = heightVal ?? 0.0;
        bmi = bmiCalc;
        restingHeartRate = hrVal ?? 0.0;
        lastUpdate = [
          stepUpdate,
          weightUpdate,
          heightUpdate,
          bmiUpdate,
          hrUpdate
        ].whereType<DateTime>().fold<DateTime>(
            DateTime(1970), (a, b) => a.isAfter(b) ? a : b);
        wellbeingTasksPercent = stepsToday >= 1500
            ? 100
            : ((stepsToday / 1500) * 100).toInt();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _switchToManualMode() {
    setState(() {
      _manualMode = true;
    });
  }

  Future<void> _showConnectDevicesSheet() async {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.watch, size: 48, color: Colors.green),
            const SizedBox(height: 12),
            const Text(
              "Connect Devices",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(height: 12),
            const Text(
              "Track your health data automatically by connecting your phone or supported wearable devices (e.g., smart watch, fitness band) to Google Fit or Apple Health.",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () async {
                Navigator.pop(context);
                await _initHealth();
              },
              icon: const Icon(Icons.mobile_friendly),
              label: const Text("Connect/Refresh Devices"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _switchToManualMode();
              },
              child: const Text("Enter Data Manually"),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showManualInputSheet() async {
    final weightCtrl = TextEditingController(text: customHealthData.weight?.toString() ?? "");
    final heightCtrl = TextEditingController(text: customHealthData.height?.toString() ?? "");
    final bmiCtrl = TextEditingController(text: customHealthData.bmi?.toString() ?? "");
    final hrCtrl = TextEditingController(text: customHealthData.restingHeartRate?.toString() ?? "");

    await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
            left: 24,
            right: 24,
            top: 24),
        child: StatefulBuilder(
          builder: (context, setModalState) {
            void recalcBmi() {
              final w = double.tryParse(weightCtrl.text);
              final h = double.tryParse(heightCtrl.text);
              double bmi = 0.0;
              if (w != null && h != null && h > 0) {
                bmi = w / ((h / 100) * (h / 100));
                bmiCtrl.text = bmi.toStringAsFixed(2);
              }
            }

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Manual Health Data Input",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                const SizedBox(height: 14),
                TextField(
                  controller: weightCtrl,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: "Weight (kg)",
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (_) {
                    setModalState(recalcBmi);
                  },
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: heightCtrl,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: "Height (cm)",
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (_) {
                    setModalState(recalcBmi);
                  },
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: bmiCtrl,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: "BMI (auto-calculated)",
                    border: OutlineInputBorder(),
                  ),
                  readOnly: true,
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: hrCtrl,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: "Resting Heart Rate (bpm)",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 18),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      customHealthData = CustomHealthData(
                        weight: double.tryParse(weightCtrl.text),
                        height: double.tryParse(heightCtrl.text),
                        bmi: double.tryParse(bmiCtrl.text),
                        restingHeartRate: double.tryParse(hrCtrl.text),
                      );
                    });
                    Navigator.pop(context);
                  },
                  child: const Text("Save"),
                ),
                const SizedBox(height: 8),
              ],
            );
          },
        ),
      ),
    );
    setState(() {});
  }

  Color getBmiColor(double bmi) {
    if (bmi < 18) return Colors.orange;
    if (bmi > 25) return Colors.red;
    return Colors.green;
  }

  // -------------------------- BMI Calculator Section Logic -----------------------

  void _updateBmiAdvice(double bmi) {
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

  void _calculateBmiSection() {
    final weight = double.tryParse(_bmiWeightController.text);
    final height = double.tryParse(_bmiHeightController.text);

    if (weight == null || height == null || height == 0) {
      setState(() {
        _bmiValue = null;
        _bmiStatus = null;
        _bmiAdvice = null;
      });
      return;
    }

    double bmi;
    if (_bmiSelectedUnit == BmiUnit.metric) {
      bmi = weight / ((height / 100) * (height / 100));
    } else {
      bmi = 703 * weight / (height * height);
    }

    _updateBmiAdvice(bmi);

    setState(() {
      _bmiValue = bmi;
    });
  }

  void _saveBmiEntry() {
    final weight = double.tryParse(_bmiWeightController.text);
    final height = double.tryParse(_bmiHeightController.text);

    if (weight == null || height == null || height == 0 || _bmiValue == null) return;

    setState(() {
      _bmiHistory.insert(0, BmiEntry(
        weight: weight,
        height: height,
        unit: _bmiSelectedUnit,
        bmi: _bmiValue!,
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

  // -------------------------- END BMI Calculator Section Logic -----------------------

  @override
  Widget build(BuildContext context) {
    final showManual = _manualMode;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.green,
        onPressed: _showConnectDevicesSheet,
        icon: const Icon(Icons.settings_input_antenna),
        label: const Text("Connect Devices / Manual"),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _initHealth,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [

              // BMI Calculator Section
              Card(
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
                              value: _bmiSelectedUnit,
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
                                  setState(() => _bmiSelectedUnit = val);
                                  _calculateBmiSection();
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: _bmiWeightController,
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              decoration: InputDecoration(
                                labelText: _bmiSelectedUnit == BmiUnit.metric ? "Weight (kg)" : "Weight (lb)",
                                border: const OutlineInputBorder(),
                              ),
                              onChanged: (_) => _calculateBmiSection(),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: _bmiHeightController,
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              decoration: InputDecoration(
                                labelText: _bmiSelectedUnit == BmiUnit.metric ? "Height (cm)" : "Height (in)",
                                border: const OutlineInputBorder(),
                              ),
                              onChanged: (_) => _calculateBmiSection(),
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
                              _calculateBmiSection();
                              _saveBmiEntry();
                            },
                            icon: const Icon(Icons.save),
                            label: const Text("Save BMI"),
                          ),
                          const SizedBox(width: 16),
                          if (_bmiValue != null)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                              decoration: BoxDecoration(
                                color: _bmiValue! < 18.5 || _bmiValue! >= 30
                                    ? Colors.red[100]
                                    : _bmiValue! < 25
                                        ? Colors.green[100]
                                        : Colors.orange[100],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    "BMI: ${_bmiValue!.toStringAsFixed(1)}",
                                    style: theme.textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: _bmiValue! < 18.5 || _bmiValue! >= 30
                                          ? Colors.red
                                          : _bmiValue! < 25
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
              ),

              Card(
                color: const Color(0xFFE6FCD9),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.health_and_safety, size: 42, color: Color(0xFF64A049)),
                      const SizedBox(height: 12),
                      const Text(
                        "Supporting your health journey",
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        "Simply dummy text of the printing and typesetting industry.",
                        style: TextStyle(fontSize: 15, color: Colors.black54),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _showConnectDevicesSheet,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                        ),
                        child: const Text("Get Started", style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
              ),
              if (_isLoading)
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(child: CircularProgressIndicator()),
                )
              else ...[
                // Daily trackers
                Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 82,
                          height: 82,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              CircularProgressIndicator(
                                value: (showManual
                                        ? (customHealthData.weight ?? 0)
                                        : stepsToday) /
                                    1500,
                                strokeWidth: 8,
                                backgroundColor: Colors.grey[200],
                                valueColor: AlwaysStoppedAnimation<Color>(const Color(0xFF64A049)),
                              ),
                              Text(
                                "${((showManual ? (customHealthData.weight ?? 0) : stepsToday) / 1500 * 100).toInt()}%",
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 18),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Steps (km)", style: TextStyle(color: Colors.grey[500], fontSize: 13)),
                              Text(
                                showManual
                                    ? "-"
                                    : stepsToday.toString(),
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                              ),
                              const SizedBox(height: 6),
                              Text("Steps (km)", style: TextStyle(color: Colors.grey[500], fontSize: 13)),
                              Text(
                                showManual
                                    ? "-"
                                    : kmToday.toStringAsFixed(2),
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),

                // Health tracker cards
                Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFD8F7B6),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.all(12),
                          margin: const EdgeInsets.only(bottom: 18),
                          child: Row(
                            children: const [
                              Icon(Icons.info_outline, color: Color(0xFF64A049)),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  "These Are Required For Your Programme\nView more detail or add a new reading.",
                                  style: TextStyle(fontSize: 14, color: Colors.black87),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: _HealthReadingCard(
                                icon: Icons.monitor_weight,
                                label: "Weight",
                                value: showManual
                                    ? (customHealthData.weight != null ? "${customHealthData.weight!.toStringAsFixed(1)}kg" : "No data")
                                    : (weight > 0 ? "${weight.toStringAsFixed(1)}kg" : "No data"),
                                updated: lastUpdate != DateTime(1970)
                                    ? "${lastUpdate.day} ${_month(lastUpdate.month)}, ${lastUpdate.year} at ${lastUpdate.hour.toString().padLeft(2, '0')}:${lastUpdate.minute.toString().padLeft(2, '0')}"
                                    : "--",
                                chart: true,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _HealthReadingCard(
                                icon: Icons.person,
                                label: "BMI",
                                value: showManual
                                    ? (customHealthData.bmi != null ? customHealthData.bmi!.toStringAsFixed(1) : "No data")
                                    : (bmi > 0 ? bmi.toStringAsFixed(1) : "No data"),
                                updated: lastUpdate != DateTime(1970)
                                    ? "${lastUpdate.day} ${_month(lastUpdate.month)}, ${lastUpdate.year} at ${lastUpdate.hour.toString().padLeft(2, '0')}:${lastUpdate.minute.toString().padLeft(2, '0')}"
                                    : "--",
                                bmiGauge: showManual
                                    ? (customHealthData.bmi != null ? customHealthData.bmi : null)
                                    : (bmi > 0 ? bmi : null),
                                bmiHealthyMin: 18,
                                bmiHealthyMax: 25,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _HealthReadingCard(
                                icon: Icons.favorite_outline,
                                label: "Resting heart rate",
                                value: showManual
                                    ? (customHealthData.restingHeartRate != null ? "${customHealthData.restingHeartRate!.toStringAsFixed(0)} bpm" : "No data")
                                    : (restingHeartRate > 0 ? "${restingHeartRate.toStringAsFixed(0)} bpm" : "No data"),
                                updated: "--",
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _HealthReadingCard(
                                icon: Icons.analytics_outlined,
                                label: "Test",
                                value: "No data",
                                updated: "--",
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFD8F7B6),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.all(12),
                          margin: const EdgeInsets.only(bottom: 18),
                          child: Row(
                            children: [
                              const Icon(Icons.tune, color: Color(0xFF64A049)),
                              const SizedBox(width: 10),
                              const Expanded(
                                child: Text(
                                  "Customize Your Health Tracker. Use the 'Edit' button to manage what you see in this section.",
                                  style: TextStyle(fontSize: 14, color: Colors.black87),
                                ),
                              ),
                              if (showManual)
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.black54),
                                  onPressed: _showManualInputSheet,
                                  tooltip: "Edit Manual Data",
                                ),
                            ],
                          ),
                        ),
                        if ((showManual && customHealthData.bmi != null && customHealthData.bmi! > 0) ||
                            (!showManual && bmi > 0))
                          _BmiGauge(
                            bmi: showManual ? customHealthData.bmi! : bmi,
                            min: 18,
                            max: 25,
                          ),
                      ],
                    ),
                  ),
                ),

                Card(
                  color: const Color(0xFFE6FCD9),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(28),
                    child: Column(
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 84,
                              height: 84,
                              child: CircularProgressIndicator(
                                value: (showManual
                                        ? (customHealthData.weight ?? 0)
                                        : wellbeingTasksPercent) /
                                    100,
                                strokeWidth: 8,
                                backgroundColor: Colors.green[100],
                                valueColor: AlwaysStoppedAnimation<Color>(const Color(0xFF64A049)),
                              ),
                            ),
                            Text(
                              "${showManual ? ((customHealthData.weight ?? 0)) : wellbeingTasksPercent}%",
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Color(0xFF64A049)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          "Keep Track Of Your Wellbeing Tasks",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                          ),
                          child: const Text("Complete Now", style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }

  String _month(int m) {
    const months = [
      "",
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ];
    return months[m];
  }
}

class _HealthReadingCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String updated;
  final bool chart;
  final double? bmiGauge;
  final double? bmiHealthyMin;
  final double? bmiHealthyMax;

  const _HealthReadingCard({
    Key? key,
    required this.icon,
    required this.label,
    required this.value,
    required this.updated,
    this.chart = false,
    this.bmiGauge,
    this.bmiHealthyMin,
    this.bmiHealthyMax,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isBmi = bmiGauge != null && bmiHealthyMin != null && bmiHealthyMax != null;
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        children: [
          Icon(icon, color: Colors.green, size: 28),
          const SizedBox(height: 10),
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: isBmi ? 22 : 20,
              color: isBmi
                  ? (bmiGauge! < bmiHealthyMin! || bmiGauge! > bmiHealthyMax!)
                      ? Colors.red
                      : Colors.green
                  : Colors.black87,
            ),
          ),
          const SizedBox(height: 6),
          if (isBmi)
            _BmiGauge(
              bmi: bmiGauge!,
              min: bmiHealthyMin!,
              max: bmiHealthyMax!,
              height: 12,
            ),
          if (chart)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: SizedBox(
                height: 28,
                child: CustomPaint(
                  size: const Size(60, 28),
                  painter: _WeightChartPainter(),
                ),
              ),
            ),
          if (!isBmi)
            Text(
              "Last Update:\n$updated",
              style: const TextStyle(fontSize: 11, color: Colors.black38),
              textAlign: TextAlign.center,
            ),
        ],
      ),
    );
  }
}

class _BmiGauge extends StatelessWidget {
  final double bmi;
  final double min;
  final double max;
  final double height;
  const _BmiGauge({Key? key, required this.bmi, required this.min, required this.max, this.height = 20}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double position = ((bmi - min) / (max - min)).clamp(0, 1).toDouble();
    return SizedBox(
      height: height + 18,
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          Container(
            height: height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(height / 2),
              gradient: const LinearGradient(
                colors: [Colors.orange, Colors.green, Colors.red],
                stops: [0, 0.6, 1],
              ),
            ),
          ),
          Positioned(
            left: position * 120,
            child: Column(
              children: [
                Icon(Icons.arrow_drop_down, color: Colors.black, size: 22),
                Text(
                  bmi.toStringAsFixed(1),
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            child: Text(min.toInt().toString(), style: const TextStyle(fontSize: 12, color: Colors.black54)),
          ),
          Positioned(
            right: 0,
            child: Text(max.toInt().toString(), style: const TextStyle(fontSize: 12, color: Colors.black54)),
          ),
        ],
      ),
    );
  }
}

class _WeightChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final points = [
      Offset(0, size.height * 0.6),
      Offset(size.width * 0.25, size.height * 0.3),
      Offset(size.width * 0.5, size.height * 0.6),
      Offset(size.width * 0.75, size.height * 0.2),
      Offset(size.width, size.height * 0.5),
    ];
    final path = Path()..moveTo(points[0].dx, points[0].dy);
    for (final p in points.skip(1)) {
      path.lineTo(p.dx, p.dy);
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_WeightChartPainter oldDelegate) => false;
}
