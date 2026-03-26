import 'package:flutter/material.dart';

class VirtualPlantPage extends StatefulWidget {
  const VirtualPlantPage({super.key});

  @override
  State<VirtualPlantPage> createState() => _VirtualPlantPageState();
}

class _VirtualPlantPageState extends State<VirtualPlantPage> {
  int plantStage = 0;

  final List<String> plantEmojis = ['🌱', '🌿', '🪴', '🌳'];

  final List<String> plantLabels = [
    'Seedling',
    'Growing Sprout',
    'Healthy Plant',
    'Strong Tree',
  ];

  final List<String> plantMessages = [
    'Your plant is just getting started.',
    'You are building healthy care habits.',
    'Your consistency is helping your plant grow.',
    'Great job. Your plant is thriving.',
  ];

  void growPlant() {
    setState(() {
      if (plantStage < plantEmojis.length - 1) {
        plantStage++;
      }
    });
  }

  void resetPlant() {
    setState(() {
      plantStage = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double progress = (plantStage + 1) / plantEmojis.length;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F2FB),
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: const Color(0xFFF6F2FB),
        title: const Text(
          'Virtual Plant',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Card(
                elevation: 6,
                shadowColor: Colors.black12,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 32,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Growth Tracker',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4F46A5),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Your plant grows as you keep up with care tasks.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 28),

                      Container(
                        width: 180,
                        height: 180,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F0FF),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          plantEmojis[plantStage],
                          style: const TextStyle(fontSize: 88),
                        ),
                      ),

                      const SizedBox(height: 24),

                      Text(
                        plantLabels[plantStage],
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        plantMessages[plantStage],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.black54,
                          height: 1.4,
                        ),
                      ),

                      const SizedBox(height: 24),

                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 12,
                          backgroundColor: const Color(0xFFE7E1F5),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Color(0xFF7C6EE6),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Stage ${plantStage + 1} of ${plantEmojis.length}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      const SizedBox(height: 28),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: growPlant,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF7C6EE6),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            textStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          child: const Text('Grow Plant'),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: resetPlant,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: const BorderSide(
                              color: Color(0xFF7C6EE6),
                              width: 1.4,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            foregroundColor: const Color(0xFF7C6EE6),
                            textStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          child: const Text('Reset'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}