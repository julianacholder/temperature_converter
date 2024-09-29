import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Temperature Conversion App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color.fromARGB(255, 48, 50, 52),
      ),
      home: const TemperatureConverter(),
    );
  }
}

class TemperatureConverter extends StatefulWidget {
  const TemperatureConverter({super.key});

  @override
  State<TemperatureConverter> createState() => _TemperatureConverterState();
}

enum ConversionType { cToF, fToC }

class _TemperatureConverterState extends State<TemperatureConverter> {
  final TextEditingController _controller = TextEditingController();
  ConversionType _selectedConversion = ConversionType.cToF;
  double _convertedTemperature = 0.0;
  final List<String> _history = [];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _convertTemperature() {
    double inputTemp = double.tryParse(_controller.text) ?? 0.0;
    double result = 0.0;
    String conversionDetail = '';

    if (_selectedConversion == ConversionType.cToF) {
      result = (inputTemp * 9 / 5) + 32;
      conversionDetail =
          'C to F: ${inputTemp.toStringAsFixed(2)}°C => ${result.toStringAsFixed(2)}°F';
    } else {
      result = (inputTemp - 32) * 5 / 9;
      conversionDetail =
          'F to C: ${inputTemp.toStringAsFixed(2)}°F => ${result.toStringAsFixed(2)}°C';
    }

    setState(() {
      _convertedTemperature = result;
      _history.insert(0, conversionDetail);
    });
  }

  Widget _buildConversionOptions() {
    return Column(
      children: [
        RadioListTile<ConversionType>(
          title: const Text(
            'Celsius to Fahrenheit',
            style: TextStyle(color: Colors.white),
          ),
          value: ConversionType.cToF,
          groupValue: _selectedConversion,
          activeColor: Colors.blue,
          onChanged: (ConversionType? value) {
            setState(() {
              _selectedConversion = value!;
              _convertedTemperature = 0.0;
              _controller.clear();
            });
          },
        ),
        RadioListTile<ConversionType>(
          title: const Text(
            'Fahrenheit to Celsius',
            style: TextStyle(color: Colors.white),
          ),
          value: ConversionType.fToC,
          groupValue: _selectedConversion,
          activeColor: Colors.blue,
          onChanged: (ConversionType? value) {
            setState(() {
              _selectedConversion = value!;
              _convertedTemperature = 0.0;
              _controller.clear();
            });
          },
        ),
      ],
    );
  }

  Widget _buildInputField() {
    return TextField(
      controller: _controller,
      keyboardType:
          const TextInputType.numberWithOptions(decimal: true, signed: true),
      decoration: InputDecoration(
        labelText: _selectedConversion == ConversionType.cToF
            ? 'Enter Celsius'
            : 'Enter Fahrenheit',
        labelStyle: const TextStyle(color: Colors.white),
        border: const OutlineInputBorder(),
        hintText: _selectedConversion == ConversionType.cToF
            ? 'e.g., 25.0'
            : 'e.g., 77.0',
        hintStyle: const TextStyle(color: Colors.white70),
      ),
      style: const TextStyle(color: Colors.white),
    );
  }

  Widget _buildConvertButton() {
    return ElevatedButton(
      onPressed: _convertTemperature,
      child: const Text('Convert'),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 15.0),
        textStyle: const TextStyle(fontSize: 18),
        backgroundColor: Colors.blue,
      ),
    );
  }

  Widget _buildResultDisplay() {
    return Text(
      _convertedTemperature != 0.0
          ? _selectedConversion == ConversionType.cToF
              ? '${_convertedTemperature.toStringAsFixed(2)} °F'
              : '${_convertedTemperature.toStringAsFixed(2)} °C'
          : 'No conversion yet.',
      style: const TextStyle(
          fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
    );
  }

  Widget _buildHistorySection() {
    return Expanded(
      child: _history.isEmpty
          ? const Center(
              child: Text(
                'No history yet.',
                style: TextStyle(fontSize: 16, color: Colors.white70),
              ),
            )
          : ListView.builder(
              itemCount: _history.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(Icons.history, color: Colors.white),
                  title: Text(
                    _history[index],
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              },
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Using OrientationBuilder to handle portrait and landscape orientations
    return Scaffold(
      appBar: AppBar(
        title: const Text('Temperature Converter'),
        backgroundColor: Colors.blue,
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: orientation == Orientation.portrait
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildConversionOptions(),
                      const SizedBox(height: 20),
                      _buildInputField(),
                      const SizedBox(height: 20),
                      _buildConvertButton(),
                      const SizedBox(height: 20),
                      _buildResultDisplay(),
                      const SizedBox(height: 20),
                      const Text(
                        'Conversion History:',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      _buildHistorySection(),
                    ],
                  )
                : Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            _buildConversionOptions(),
                            const SizedBox(height: 20),
                            _buildInputField(),
                            const SizedBox(height: 20),
                            _buildConvertButton(),
                            const SizedBox(height: 20),
                            _buildResultDisplay(),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Conversion History:',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            _buildHistorySection(),
                          ],
                        ),
                      ),
                    ],
                  ),
          );
        },
      ),
    );
  }
}
