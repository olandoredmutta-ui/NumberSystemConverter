import 'package:flutter/material.dart';

void main() {
  runApp(const NumberConverterApp());
}

class NumberConverterApp extends StatelessWidget {
  const NumberConverterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Number System Converter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF9C27B0),
        ),
        useMaterial3: true,
      ),
      home: const ConverterScreen(),
    );
  }
}

class ConverterScreen extends StatefulWidget {
  const ConverterScreen({super.key});

  @override
  State<ConverterScreen> createState() => _ConverterScreenState();
}

class _ConverterScreenState extends State<ConverterScreen> {
  final TextEditingController _controller = TextEditingController();

  String _selectedBase = 'Decimal';
  String _error = '';
  Map<String, String> _results = {};

  final Map<String, int> _bases = {
    'Binary': 2,
    'Octal': 8,
    'Decimal': 10,
    'Hexadecimal': 16,
  };

  void _convert() {
    final input = _controller.text.trim();

    if (input.isEmpty) {
      setState(() {
        _error = 'Please enter a number.';
        _results = {};
      });
      return;
    }

    try {
      final number = int.parse(
        input,
        radix: _bases[_selectedBase]!,
      );

      setState(() {
        _error = '';
        _results = {
          'Binary': number.toRadixString(2),
          'Octal': number.toRadixString(8),
          'Decimal': number.toString(),
          'Hexadecimal': number.toRadixString(16).toUpperCase(),
        };
      });
    } on FormatException {
      setState(() {
        _error = 'Invalid $_selectedBase number. Check your input.';
        _results = {};
      });
    }
  }

  void _clear() {
    setState(() {
      _controller.clear();
      _error = '';
      _results = {};
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F3FA),
      appBar: AppBar(
        title: const Text(
          'Number Converter',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF6750A4),
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(
                    Icons.calculate_rounded,
                    size: 75,
                    color: Color(0xFF6750A4),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Convert Any Number',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Convert between Binary, Decimal, Octal '
                    'and Hexadecimal.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black54),
                  ),
                  const SizedBox(height: 28),
                  DropdownButtonFormField<String>(
                    value: _selectedBase,
                    decoration: const InputDecoration(
                      labelText: 'Input number system',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    items: _bases.keys.map((base) {
                      return DropdownMenuItem(
                        value: base,
                        child: Text('$base (Base ${_bases[base]})'),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedBase = value;
                          _error = '';
                          _results = {};
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: 'Enter your number',
                      hintText: 'e.g. 255',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    onSubmitted: (_) => _convert(),
                  ),
                  if (_error.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Text(
                      _error,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ],
                  const SizedBox(height: 18),
                  FilledButton.icon(
                    onPressed: _convert,
                    icon: const Icon(Icons.sync_alt),
                    label: const Text('Convert Number'),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                    ),
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton.icon(
                    onPressed: _clear,
                    icon: const Icon(Icons.clear),
                    label: const Text('Clear'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.all(14),
                    ),
                  ),
                  if (_results.isNotEmpty) ...[
                    const SizedBox(height: 28),
                    const Text(
                      'Conversion Results',
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ..._results.entries.map((entry) {
                      return Card(
                        color: Colors.white,
                        child: ListTile(
                          leading: const Icon(
                            Icons.check_circle_outline,
                            color: Color(0xFF6750A4),
                          ),
                          title: Text(entry.key),
                          subtitle: SelectableText(
                            entry.value,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          trailing: IconButton(
                            tooltip: 'Copy result',
                            icon: const Icon(Icons.copy),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    '${entry.key} result: ${entry.value}',
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    }),
                  ],
                  const SizedBox(height: 24),
                  const Text(
                    'Built with Flutter & Dart',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black45),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

