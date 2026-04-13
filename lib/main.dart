import 'package:flutter/material.dart';
import 'growth_tracker_screen.dart';
import 'repositories/app_repository.dart';
import 'models/settings_model.dart';
import 'models/goal_model.dart';
import 'models/baby_activity_model.dart';
import 'models/self_care_reminder_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Postpartum Care',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        scaffoldBackgroundColor: const Color(0xFFFFFBF5),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      // FutureBuilder checks DB for existing settings on every launch.
      // If settings exist → skip onboarding and go straight to HomeScreen.
      // If not           → first launch, show WelcomeScreen.
      home: FutureBuilder<SettingsModel?>(
        future: AppRepository().getSettings(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          final settings = snapshot.data;

          if (settings == null) {
            return const WelcomeScreen();
          }

          return HomeScreen(
            motherName: settings.motherName,
            babyGender: settings.babyGender,
            dueDate: DateTime.parse(settings.dueDate),
            themeColor: Color(settings.themeColor),
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Welcome Screen
// ─────────────────────────────────────────────────────────────────────────────
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE0BBE4),
              Color(0xFFF8F4FF),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),

                Container(
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF9C88D9).withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.favorite,
                    size: 80,
                    color: Color(0xFF9C88D9),
                  ),
                ),

                const SizedBox(height: 40),

                const Text(
                  'Welcome, Mama',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF9C88D9),
                  ),
                ),

                const SizedBox(height: 15),

                Text(
                  'Your postpartum journey companion',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[700],
                  ),
                ),

                const SizedBox(height: 50),

                _buildFeature(Icons.child_care, 'Track baby\'s feeding, sleep & diapers'),
                const SizedBox(height: 15),
                _buildFeature(Icons.favorite, 'Monitor your mood & self-care'),
                const SizedBox(height: 15),
                _buildFeature(Icons.notifications, 'Gentle reminders for your well-being'),

                const Spacer(),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SetupScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF9C88D9),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 5,
                    ),
                    child: const Text(
                      'Get Started',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeature(IconData icon, String text) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.5),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: const Color(0xFF9C88D9), size: 24),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 16, color: Colors.grey[800]),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Setup Screen
// ─────────────────────────────────────────────────────────────────────────────
class SetupScreen extends StatefulWidget {
  const SetupScreen({Key? key}) : super(key: key);

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  final TextEditingController _motherNameController = TextEditingController();
  DateTime? _dueDate;
  String? _selectedGender;
  Color? _selectedColor;

  final Map<String, Color> _colorOptions = {
    'Boy (Blue)': const Color(0xFFAEC6FF),
    'Girl (Pink)': const Color(0xFFFFB5E8),
    'Neutral (Yellow/Nude)': const Color(0xFFFFF4C1),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF9C88D9)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Let\'s personalize',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFF9C88D9),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Help us create your perfect experience',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),

            const SizedBox(height: 40),

            const Text(
              'Your Name',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _motherNameController,
              decoration: InputDecoration(
                hintText: 'Enter your name',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: const Icon(Icons.person, color: Color(0xFF9C88D9)),
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              'Baby\'s Gender',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(child: _buildGenderOption('Boy', Icons.male, const Color(0xFFAEC6FF))),
                const SizedBox(width: 10),
                Expanded(child: _buildGenderOption('Girl', Icons.female, const Color(0xFFFFB5E8))),
                const SizedBox(width: 10),
                Expanded(child: _buildGenderOption('Neutral', Icons.child_care, const Color(0xFFFFF4C1))),
              ],
            ),

            const SizedBox(height: 25),

            const Text(
              'Due Date / Birth Date',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2030),
                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: const ColorScheme.light(
                          primary: Color(0xFF9C88D9),
                        ),
                      ),
                      child: child!,
                    );
                  },
                );
                if (picked != null) {
                  setState(() => _dueDate = picked);
                }
              },
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today, color: Color(0xFF9C88D9)),
                    const SizedBox(width: 15),
                    Text(
                      _dueDate == null
                          ? 'Select date'
                          : '${_dueDate!.month}/${_dueDate!.day}/${_dueDate!.year}',
                      style: TextStyle(
                        fontSize: 16,
                        color: _dueDate == null ? Colors.grey : Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              'Choose Your Color Theme',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ..._colorOptions.entries.map((entry) {
              final isSelected = _selectedColor == entry.value;
              return GestureDetector(
                onTap: () => setState(() => _selectedColor = entry.value),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: isSelected ? entry.value : Colors.grey.shade300,
                      width: isSelected ? 3 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: entry.value,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Text(
                        entry.key,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      const Spacer(),
                      if (isSelected) Icon(Icons.check_circle, color: entry.value),
                    ],
                  ),
                ),
              );
            }).toList(),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_motherNameController.text.isEmpty ||
                      _selectedGender == null ||
                      _dueDate == null ||
                      _selectedColor == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please fill in all fields'),
                        backgroundColor: Color(0xFFD4A5A5),
                      ),
                    );
                    return;
                  }

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PrivacyScreen(
                        motherName: _motherNameController.text,
                        babyGender: _selectedGender!,
                        dueDate: _dueDate!,
                        themeColor: _selectedColor!,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF9C88D9),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 5,
                ),
                child: const Text(
                  'Continue',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenderOption(String label, IconData icon, Color color) {
    final isSelected = _selectedGender == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedGender = label),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.3) : Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isSelected ? color : Colors.grey.shade300,
            width: isSelected ? 3 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 35),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Privacy Screen
// ─────────────────────────────────────────────────────────────────────────────
class PrivacyScreen extends StatefulWidget {
  final String motherName;
  final String babyGender;
  final DateTime dueDate;
  final Color themeColor;

  const PrivacyScreen({
    Key? key,
    required this.motherName,
    required this.babyGender,
    required this.dueDate,
    required this.themeColor,
  }) : super(key: key);

  @override
  State<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
  bool _agreedToTerms = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF9C88D9)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Privacy & Terms',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFF9C88D9),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Your data, your control',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),

            const SizedBox(height: 30),

            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildPrivacySection(
                        Icons.lock,
                        'Data Privacy',
                        'All your personal information and baby tracking data is stored securely on your device. We do not share or sell your data to third parties.',
                      ),
                      const SizedBox(height: 20),
                      _buildPrivacySection(
                        Icons.health_and_safety,
                        'Health Information',
                        'This app is for informational purposes only and should not replace professional medical advice. Please consult with your healthcare provider for medical concerns.',
                      ),
                      const SizedBox(height: 20),
                      _buildPrivacySection(
                        Icons.notifications,
                        'Reminders',
                        'We may send you gentle notifications to help with self-care reminders. You can disable these anytime in settings.',
                      ),
                      const SizedBox(height: 20),
                      _buildPrivacySection(
                        Icons.update,
                        'Updates',
                        'We may update these terms from time to time. Continued use of the app means you accept any changes.',
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            GestureDetector(
              onTap: () => setState(() => _agreedToTerms = !_agreedToTerms),
              child: Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: _agreedToTerms ? const Color(0xFF9C88D9) : Colors.white,
                      border: Border.all(
                        color: _agreedToTerms ? const Color(0xFF9C88D9) : Colors.grey,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: _agreedToTerms
                        ? const Icon(Icons.check, size: 18, color: Colors.white)
                        : null,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'I agree to the privacy policy and terms of use',
                      style: TextStyle(fontSize: 14, color: Colors.grey[800]),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                // ── ASYNC: saves settings to SQLite before navigating ──────
                onPressed: _agreedToTerms
                    ? () async {
                        await AppRepository().saveSettings(
                          SettingsModel(
                            motherName: widget.motherName,
                            babyGender: widget.babyGender,
                            dueDate: widget.dueDate.toIso8601String(),
                            themeColor: widget.themeColor.value,
                          ),
                        );
                        if (!mounted) return;
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomeScreen(
                              motherName: widget.motherName,
                              babyGender: widget.babyGender,
                              dueDate: widget.dueDate,
                              themeColor: widget.themeColor,
                            ),
                          ),
                          (route) => false,
                        );
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF9C88D9),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 5,
                  disabledBackgroundColor: Colors.grey[300],
                ),
                child: const Text(
                  'Start My Journey',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrivacySection(IconData icon, String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFF9C88D9).withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: const Color(0xFF9C88D9), size: 24),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              Text(description,
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      height: 1.5)),
            ],
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Home Screen
// ─────────────────────────────────────────────────────────────────────────────
class HomeScreen extends StatefulWidget {
  final String motherName;
  final String babyGender;
  final DateTime dueDate;
  final Color themeColor;

  const HomeScreen({
    Key? key,
    required this.motherName,
    required this.babyGender,
    required this.dueDate,
    required this.themeColor,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  late Color _currentThemeColor;

  @override
  void initState() {
    super.initState();
    _currentThemeColor = widget.themeColor;
  }

  void _updateThemeColor(Color newColor) {
    setState(() => _currentThemeColor = newColor);
  }

  Color _getBackgroundColor(Color themeColor) {
    if (themeColor == const Color(0xFFAEC6FF)) return const Color(0xFFF0F4FF);
    if (themeColor == const Color(0xFFFFB5E8)) return const Color(0xFFFFF5FA);
    return const Color(0xFFFFFBF5);
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      DashboardScreen(
        motherName: widget.motherName,
        babyGender: widget.babyGender,
        themeColor: _currentThemeColor,
      ),
      BabyTrackerScreen(
        babyGender: widget.babyGender,
        themeColor: _currentThemeColor,
      ),
      SelfCareScreen(themeColor: _currentThemeColor),
      GrowthTrackerScreen(themeColor: _currentThemeColor),
      SettingsScreen(
        motherName: widget.motherName,
        babyGender: widget.babyGender,
        themeColor: _currentThemeColor,
        onThemeColorChanged: _updateThemeColor,
      ),
    ];

    return Scaffold(
      backgroundColor: _getBackgroundColor(_currentThemeColor),
      body: screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: _currentThemeColor.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) => setState(() => _selectedIndex = index),
          selectedItemColor: _currentThemeColor,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.child_care), label: 'Baby'),
            BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Self-Care'),
            BottomNavigationBarItem(icon: Icon(Icons.park), label: 'Growth'),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Dashboard Screen  (StatefulWidget — loads goals & last activity from DB)
// ─────────────────────────────────────────────────────────────────────────────
class DashboardScreen extends StatefulWidget {
  final String motherName;
  final String babyGender;
  final Color themeColor;

  const DashboardScreen({
    Key? key,
    required this.motherName,
    required this.babyGender,
    required this.themeColor,
  }) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<GoalModel> _goals = [];
  BabyActivityModel? _lastFeeding;
  BabyActivityModel? _lastSleep;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // ── ASYNC: loads today's goals and last feeding/sleep from SQLite ─────────
  Future<void> _loadData() async {
    final today = DateTime.now().toIso8601String().substring(0, 10);
    var goals = await AppRepository().getGoalsForDate(today);

    // Seed default goals on first load of the day
    if (goals.isEmpty) {
      final defaults = [
        'Drink 8 glasses of water',
        'Take your vitamins',
        'Rest for 30 minutes',
        'Eat a healthy meal',
      ];
      for (final title in defaults) {
        await AppRepository().insertGoal(
          GoalModel(title: title, date: today),
        );
      }
      goals = await AppRepository().getGoalsForDate(today);
    }

    final feeding = await AppRepository().getLastActivityByType('Feeding');
    final sleep   = await AppRepository().getLastActivityByType('Sleep');

    if (!mounted) return;
    setState(() {
      _goals       = goals;
      _lastFeeding = feeding;
      _lastSleep   = sleep;
    });
  }

  /// Converts a stored ISO-8601 timestamp into a human-friendly "X ago" string.
  String _timeAgo(String isoString) {
    final logged = DateTime.parse(isoString);
    final diff   = DateTime.now().difference(logged);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24)   return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello, ${widget.motherName} 💕',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: widget.themeColor,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'You\'re doing amazing with your baby ${widget.babyGender}!',
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
            const SizedBox(height: 30),

            // Stat cards — show real last-activity times from DB
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Last Feeding',
                    _lastFeeding != null
                        ? _timeAgo(_lastFeeding!.loggedAt)
                        : 'None yet',
                    Icons.restaurant,
                    widget.themeColor,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: _buildStatCard(
                    'Last Sleep',
                    _lastSleep != null
                        ? _timeAgo(_lastSleep!.loggedAt)
                        : 'None yet',
                    Icons.bedtime,
                    widget.themeColor.withOpacity(0.7),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            const Text(
              'Today\'s Goals',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),

            // Goals driven by DB — tapping toggles completion
            ..._goals.map((goal) => GestureDetector(
              onTap: () async {
                // ── ASYNC: persists toggle to SQLite then refreshes UI ─────
                await AppRepository().toggleGoal(goal.id!, !goal.isComplete);
                _loadData();
              },
              child: _buildChecklistItem(
                  goal.title, goal.isComplete, widget.themeColor),
            )),

            const Spacer(),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: widget.themeColor.withOpacity(0.3),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Icon(Icons.spa, color: widget.themeColor, size: 30),
                  const SizedBox(width: 15),
                  const Expanded(
                    child: Text(
                      'Remember: Your well-being matters too',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
      String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 35),
          const SizedBox(height: 10),
          Text(value,
              style: const TextStyle(
                  fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          Text(label,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildChecklistItem(
      String text, bool checked, Color themeColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            checked ? Icons.check_circle : Icons.circle_outlined,
            color: checked ? themeColor : Colors.grey,
          ),
          const SizedBox(width: 10),
          Text(
            text,
            style: TextStyle(
              fontSize: 16,
              decoration: checked ? TextDecoration.lineThrough : null,
              color: checked ? Colors.grey : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Baby Tracker Screen  (loads & saves activities via SQLite)
// ─────────────────────────────────────────────────────────────────────────────
class BabyTrackerScreen extends StatefulWidget {
  final String babyGender;
  final Color themeColor;

  const BabyTrackerScreen({
    Key? key,
    required this.babyGender,
    required this.themeColor,
  }) : super(key: key);

  @override
  State<BabyTrackerScreen> createState() => _BabyTrackerScreenState();
}

class _BabyTrackerScreenState extends State<BabyTrackerScreen> {
  List<BabyActivityModel> _activities = [];

  @override
  void initState() {
    super.initState();
    _loadActivities();
  }

  // ── ASYNC: fetches the 20 most recent activities from SQLite ──────────────
  Future<void> _loadActivities() async {
    final data = await AppRepository().getRecentActivities(limit: 20);
    if (!mounted) return;
    setState(() => _activities = data);
  }

  // ── ASYNC: inserts a new activity row then refreshes the list ─────────────
  Future<void> _addActivity(String type) async {
    await AppRepository().logBabyActivity(
      BabyActivityModel(
        type: type,
        loggedAt: DateTime.now().toIso8601String(),
      ),
    );
    await _loadActivities();

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$type logged!'),
        backgroundColor: widget.themeColor,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// Converts a stored ISO-8601 timestamp into a human-friendly "X ago" string.
  String _timeAgo(String isoString) {
    final logged = DateTime.parse(isoString);
    final diff   = DateTime.now().difference(logged);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24)   return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  IconData _iconForType(String type) {
    switch (type) {
      case 'Feeding': return Icons.restaurant;
      case 'Sleep':   return Icons.bedtime;
      default:        return Icons.child_care; // Diaper
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Baby Tracker 👶',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: widget.themeColor,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Tracking your ${widget.babyGender.toLowerCase()}',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 30),

            // Quick-log buttons — each calls _addActivity (async)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton('Feed',   Icons.restaurant, widget.themeColor,
                    () => _addActivity('Feeding')),
                _buildActionButton('Diaper', Icons.child_care,
                    widget.themeColor.withOpacity(0.7),
                    () => _addActivity('Diaper')),
                _buildActionButton('Sleep',  Icons.bedtime,
                    widget.themeColor.withOpacity(0.5),
                    () => _addActivity('Sleep')),
              ],
            ),

            const SizedBox(height: 30),

            const Text(
              'Recent Activity',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),

            // Activity list — populated from DB
            Expanded(
              child: _activities.isEmpty
                  ? Center(
                      child: Text(
                        'No activities logged yet.\nTap a button above to start!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.grey[500], fontSize: 16),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _activities.length,
                      itemBuilder: (context, index) {
                        final activity = _activities[index];
                        final color = widget.themeColor
                            .withOpacity(1 - (index * 0.05).clamp(0.0, 0.5));
                        return Container(
                          margin: const EdgeInsets.only(bottom: 15),
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: color.withOpacity(0.2),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: color.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  _iconForType(activity.type),
                                  color: color,
                                  size: 25,
                                ),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(activity.type,
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 3),
                                    Text(_timeAgo(activity.loggedAt),
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[600])),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
      String label, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color.withOpacity(0.3),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 35),
            const SizedBox(height: 8),
            Text(label,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800])),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Self-Care Screen  (loads reminders from DB, logs mood & completions)
// ─────────────────────────────────────────────────────────────────────────────
class SelfCareScreen extends StatefulWidget {
  final Color themeColor;

  const SelfCareScreen({Key? key, required this.themeColor}) : super(key: key);

  @override
  State<SelfCareScreen> createState() => _SelfCareScreenState();
}

class _SelfCareScreenState extends State<SelfCareScreen> {
  String selectedMood = 'Good';
  List<SelfCareReminderModel> _reminders = [];

  final List<Map<String, dynamic>> moods = [
    {'emoji': '😊', 'label': 'Good'},
    {'emoji': '😌', 'label': 'Calm'},
    {'emoji': '😫', 'label': 'Tired'},
    {'emoji': '😢', 'label': 'Sad'},
  ];

  @override
  void initState() {
    super.initState();
    _loadReminders();
  }

  // ── ASYNC: fetches reminders seeded by DatabaseHelper from SQLite ─────────
  Future<void> _loadReminders() async {
    final data = await AppRepository().getReminders();
    if (!mounted) return;
    setState(() => _reminders = data);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Self-Care 💖',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: widget.themeColor,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'How are you feeling today?',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 30),

            // Mood selector — tapping persists to DB via logMood()
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: moods.map((mood) {
                final isSelected = selectedMood == mood['label'];
                return GestureDetector(
                  onTap: () async {
                    // ── ASYNC: saves mood log to SQLite ────────────────────
                    setState(() => selectedMood = mood['label'] as String);
                    await AppRepository().logMood(mood['label'] as String);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? widget.themeColor.withOpacity(0.3)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: isSelected
                            ? widget.themeColor
                            : Colors.grey.shade300,
                        width: 2,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(mood['emoji'] as String,
                            style: const TextStyle(fontSize: 35)),
                        const SizedBox(height: 5),
                        Text(
                          mood['label'] as String,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 30),

            const Text(
              'Daily Reminders',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),

            // Reminders from DB — bell icon logs a completion record
            Expanded(
              child: ListView(
                children: _reminders.map((reminder) {
                  final color = widget.themeColor.withOpacity(
                      1 - (_reminders.indexOf(reminder) * 0.1)
                          .clamp(0.0, 0.6));
                  return _buildReminderCard(
                    reminder.title,
                    reminder.description ?? '',
                    IconData(reminder.iconCode,
                        fontFamily: 'MaterialIcons'),
                    color,
                    onNotificationTap: () async {
                      // ── ASYNC: logs reminder completion to SQLite ───────
                      await AppRepository()
                          .markReminderComplete(reminder.id!);
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${reminder.title} logged!'),
                          backgroundColor: widget.themeColor,
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
            ),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: widget.themeColor.withOpacity(0.3),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Text(
                    '✨ Daily Affirmation ✨',
                    style: TextStyle(
                      color: widget.themeColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    '"I am strong, capable, and deserving of rest"',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReminderCard(
    String title,
    String description,
    IconData icon,
    Color color, {
    VoidCallback? onNotificationTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 25),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 3),
                Text(description,
                    style: TextStyle(
                        fontSize: 14, color: Colors.grey[600])),
              ],
            ),
          ),
          // Tapping the bell icon logs this reminder as complete in SQLite
          GestureDetector(
            onTap: onNotificationTap,
            child: Icon(Icons.notifications_outlined,
                color: Colors.grey[400]),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Settings Screen  (persists theme color changes to SQLite)
// ─────────────────────────────────────────────────────────────────────────────
class SettingsScreen extends StatelessWidget {
  final String motherName;
  final String babyGender;
  final Color themeColor;
  final Function(Color) onThemeColorChanged;

  const SettingsScreen({
    Key? key,
    required this.motherName,
    required this.babyGender,
    required this.themeColor,
    required this.onThemeColorChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Settings ⚙️',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: themeColor,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Manage your account and preferences',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 30),

            // Profile card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: themeColor.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Profile',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 15),
                  Row(children: [
                    Icon(Icons.person, color: themeColor),
                    const SizedBox(width: 10),
                    Text(motherName,
                        style: const TextStyle(fontSize: 16)),
                  ]),
                  const SizedBox(height: 10),
                  Row(children: [
                    Icon(Icons.child_care, color: themeColor),
                    const SizedBox(width: 10),
                    Text('Baby Gender: $babyGender',
                        style: const TextStyle(fontSize: 16)),
                  ]),
                ],
              ),
            ),

            const SizedBox(height: 20),

            _buildSettingOption(
              context,
              'Change Theme Color',
              'Choose your preferred color theme',
              Icons.palette_outlined,
              themeColor,
              () => _showColorPicker(context),
            ),

            _buildSettingOption(
              context,
              'Notifications',
              'Manage reminder settings',
              Icons.notifications_outlined,
              themeColor,
              () => ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Notification settings coming soon!'),
                  backgroundColor: themeColor,
                ),
              ),
            ),

            _buildSettingOption(
              context,
              'Privacy',
              'View privacy policy',
              Icons.lock_outline,
              themeColor,
              () => ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Privacy policy coming soon!'),
                  backgroundColor: themeColor,
                ),
              ),
            ),

            _buildSettingOption(
              context,
              'Help & Support',
              'Get help and contact us',
              Icons.help_outline,
              themeColor,
              () => ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Support coming soon!'),
                  backgroundColor: themeColor,
                ),
              ),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Logout'),
                        content:
                            const Text('Are you sure you want to logout?'),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const WelcomeScreen()),
                                (route) => false,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Logout'),
                          ),
                        ],
                      );
                    },
                  );
                },
                icon: const Icon(Icons.logout),
                label: const Text('Logout',
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  elevation: 5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showColorPicker(BuildContext context) {
    final Map<String, Color> colorOptions = {
      'Boy (Blue)': const Color(0xFFAEC6FF),
      'Girl (Pink)': const Color(0xFFFFB5E8),
      'Neutral (Yellow/Nude)': const Color(0xFFFFF4C1),
    };

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Choose Theme Color'),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: colorOptions.entries.map((entry) {
              final isSelected = themeColor == entry.value;
              return GestureDetector(
                onTap: () async {
                  // ── ASYNC: updates saved theme color in SQLite ──────────
                  onThemeColorChanged(entry.value);
                  final current = await AppRepository().getSettings();
                  if (current != null) {
                    await AppRepository().saveSettings(
                      SettingsModel(
                        id: current.id,
                        motherName: current.motherName,
                        babyGender: current.babyGender,
                        dueDate: current.dueDate,
                        themeColor: entry.value.value,
                      ),
                    );
                  }
                  if (!context.mounted) return;
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Theme changed to ${entry.key}'),
                      backgroundColor: entry.value,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: isSelected
                          ? entry.value
                          : Colors.grey.shade300,
                      width: isSelected ? 3 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: entry.value,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Text(
                        entry.key,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                      const Spacer(),
                      if (isSelected)
                        Icon(Icons.check_circle, color: entry.value),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Widget _buildSettingOption(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 25),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 3),
                  Text(subtitle,
                      style: TextStyle(
                          fontSize: 14, color: Colors.grey[600])),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios,
                color: Colors.grey[400], size: 18),
          ],
        ),
      ),
    );
  }
}