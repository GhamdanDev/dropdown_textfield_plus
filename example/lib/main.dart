import 'package:dropdown_textfield_plus/dropdown_textfield_plus.dart';
import 'package:flutter/material.dart';

const List<DropDownValueModel> countries = [
  DropDownValueModel(name: 'Yemen', value: 'ye'),
  DropDownValueModel(name: 'United Kingdom', value: 'uk'),
  DropDownValueModel(name: 'Germany', value: 'de'),
  DropDownValueModel(name: 'France', value: 'fr'),
  DropDownValueModel(name: 'Japan', value: 'jp'),
  DropDownValueModel(name: 'Brazil', value: 'br'),
  DropDownValueModel(name: 'Canada', value: 'ca'),
  DropDownValueModel(name: 'Australia', value: 'au'),
  DropDownValueModel(name: 'India', value: 'in'),
  DropDownValueModel(name: 'Egypt', value: 'eg'),
];

const List<DropDownValueModel> skills = [
  DropDownValueModel(
    name: 'Flutter',
    value: 'flutter',
    toolTipMsg:
        "Google's UI toolkit for natively compiled mobile, web, and desktop apps",
  ),
  DropDownValueModel(
    name: 'Dart',
    value: 'dart',
    toolTipMsg:
        'Client-optimized programming language for fast apps on any platform',
  ),
  DropDownValueModel(
    name: 'Firebase',
    value: 'firebase',
    toolTipMsg: "Google's platform for building and scaling backend services",
  ),
  DropDownValueModel(
    name: 'React Native',
    value: 'react_native',
    toolTipMsg: "Facebook's framework for building native apps using React",
  ),
  DropDownValueModel(
    name: 'SwiftUI',
    value: 'swiftui',
    toolTipMsg: "Apple's declarative framework for building iOS/macOS UI",
  ),
];

const List<DropDownValueModel> frameworks = [
  DropDownValueModel(name: 'Flutter (3.27+)', value: 'flutter'),
  DropDownValueModel(name: 'React Native (0.76+)', value: 'react_native'),
  DropDownValueModel(name: 'SwiftUI (iOS 17+)', value: 'swiftui'),
  DropDownValueModel(name: 'Jetpack Compose', value: 'jetpack_compose'),
];

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DropdownTextField+ Examples',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.system,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('DropdownTextField+'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 28),
            child: Column(
              children: [
                Icon(
                  Icons.arrow_drop_down_circle_outlined,
                  size: 64,
                  color: colorScheme.primary,
                ),
                const SizedBox(height: 12),
                Text(
                  'DropdownTextField+',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'A versatile dropdown widget with single and multi-selection '
                  'modes, search, validation, and full customization.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          _NavCard(
            icon: Icons.arrow_drop_down_circle_outlined,
            title: 'Single Selection',
            subtitle: 'Search, editable mode, and programmatic control',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SingleSelectionPage()),
            ),
          ),
          const SizedBox(height: 12),
          _NavCard(
            icon: Icons.checklist,
            title: 'Multi Selection',
            subtitle: 'Checkboxes, tooltips, display options',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const MultiSelectionPage()),
            ),
          ),
          const SizedBox(height: 12),
          _NavCard(
            icon: Icons.description_outlined,
            title: 'Form Integration',
            subtitle: 'Validation, auto-validate, form submission',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const FormIntegrationPage()),
            ),
          ),
          const SizedBox(height: 12),
          _NavCard(
            icon: Icons.palette_outlined,
            title: 'Custom Styling',
            subtitle: 'Icons, colors, checkbox properties, text styles',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CustomStylingPage()),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _NavCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Icon(icon),
        title: Text(title),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(subtitle),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}

class SingleSelectionPage extends StatefulWidget {
  const SingleSelectionPage({super.key});

  @override
  State<SingleSelectionPage> createState() => _SingleSelectionPageState();
}

class _SingleSelectionPageState extends State<SingleSelectionPage> {
  final _countryCtrl = SingleValueDropDownController();
  final _frameworkCtrl = SingleValueDropDownController();
  String? _lastSelected;

  @override
  void dispose() {
    _countryCtrl.dispose();
    _frameworkCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Single Selection')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
        children: [
          Text('Country', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          DropDownTextField(
            controller: _countryCtrl,
            dropDownList: countries,
            enableSearch: true,
            clearOption: true,
            textFieldDecoration: const InputDecoration(
              hintText: 'Select a country',
              prefixIcon: Icon(Icons.public_outlined),
              border: OutlineInputBorder(),
              filled: true,
            ),
          ),
          const SizedBox(height: 24),
          Text('Framework', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          DropDownTextField(
            controller: _frameworkCtrl,
            dropDownList: frameworks,
            readOnly: false,
            clearOption: true,
            textFieldDecoration: const InputDecoration(
              hintText: 'Select or type a framework',
              prefixIcon: Icon(Icons.code_outlined),
              border: OutlineInputBorder(),
              filled: true,
            ),
            onChanged: (v) {
              setState(() {
                _lastSelected = v is DropDownValueModel ? v.name : v.toString();
              });
            },
          ),
          if (_lastSelected != null) ...[
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.green),
                    const SizedBox(width: 12),
                    Text('Selected: $_lastSelected'),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class MultiSelectionPage extends StatefulWidget {
  const MultiSelectionPage({super.key});

  @override
  State<MultiSelectionPage> createState() => _MultiSelectionPageState();
}

class _MultiSelectionPageState extends State<MultiSelectionPage> {
  final _skillsCtrl = MultiValueDropDownController();
  List<String> _selectedSkills = [];

  @override
  void dispose() {
    _skillsCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Multi Selection')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
        children: [
          Text('Skills', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          DropDownTextField.multiSelection(
            controller: _skillsCtrl,
            dropDownList: skills,
            displayCompleteItem: true,
            submitButtonText: 'Apply',
            clearOption: true,
            textFieldDecoration: const InputDecoration(
              hintText: 'Pick your skills',
              prefixIcon: Icon(Icons.psychology_outlined),
              border: OutlineInputBorder(),
              filled: true,
            ),
            onChanged: (v) {
              if (v is List<DropDownValueModel>) {
                setState(() => _selectedSkills = v.map((e) => e.name).toList());
              } else {
                setState(() => _selectedSkills = []);
              }
            },
          ),
          if (_selectedSkills.isNotEmpty) ...[
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Selected Skills:',
                        style: Theme.of(context).textTheme.titleSmall),
                    const SizedBox(height: 8),
                    ..._selectedSkills.map(
                      (s) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Row(
                          children: [
                            const Icon(Icons.check, size: 18, color: Colors.green),
                            const SizedBox(width: 8),
                            Text(s),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class FormIntegrationPage extends StatefulWidget {
  const FormIntegrationPage({super.key});

  @override
  State<FormIntegrationPage> createState() => _FormIntegrationPageState();
}

class _FormIntegrationPageState extends State<FormIntegrationPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _countryCtrl = SingleValueDropDownController();
  final _skillsCtrl = MultiValueDropDownController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _countryCtrl.dispose();
    _skillsCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final skills = _skillsCtrl.dropDownValueList;
    if (skills == null || skills.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one skill')),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Form submitted!'), behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Form Integration')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
          children: [
            TextFormField(
              controller: _nameCtrl,
              decoration: const InputDecoration(
                labelText: 'Full Name',
                prefixIcon: Icon(Icons.person_outline),
                border: OutlineInputBorder(),
                filled: true,
              ),
              validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            DropDownTextField(
              controller: _countryCtrl,
              dropDownList: countries,
              enableSearch: true,
              clearOption: true,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (v) => v == null || v.isEmpty ? 'Select a country' : null,
              textFieldDecoration: const InputDecoration(
                labelText: 'Country',
                prefixIcon: Icon(Icons.public_outlined),
                border: OutlineInputBorder(),
                filled: true,
              ),
            ),
            const SizedBox(height: 16),
            DropDownTextField.multiSelection(
              controller: _skillsCtrl,
              dropDownList: skills,
              displayCompleteItem: true,
              submitButtonText: 'Select',
              textFieldDecoration: const InputDecoration(
                labelText: 'Skills',
                prefixIcon: Icon(Icons.psychology_outlined),
                border: OutlineInputBorder(),
                filled: true,
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _submit,
              icon: const Icon(Icons.check_circle_outline),
              label: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomStylingPage extends StatefulWidget {
  const CustomStylingPage({super.key});

  @override
  State<CustomStylingPage> createState() => _CustomStylingPageState();
}

class _CustomStylingPageState extends State<CustomStylingPage> {
  final _singleCtrl = SingleValueDropDownController();
  final _multiCtrl = MultiValueDropDownController();

  @override
  void dispose() {
    _singleCtrl.dispose();
    _multiCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Custom Styling')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
        children: [
          Text('Styled Single Selection',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          DropDownTextField(
            controller: _singleCtrl,
            dropDownList: countries,
            enableSearch: true,
            clearOption: true,
            dropdownRadius: 24,
            dropdownColor: Theme.of(context).colorScheme.tertiaryContainer,
            dropDownIconProperty: const IconProperty(
              icon: Icons.expand_circle_down,
              color: Colors.deepPurple,
              size: 28,
            ),
            clearIconProperty: const IconProperty(
              icon: Icons.backspace,
              color: Colors.red,
              size: 20,
            ),
            textStyle: const TextStyle(
              color: Colors.deepPurple,
              fontWeight: FontWeight.w500,
            ),
            textFieldDecoration: InputDecoration(
              hintText: 'Custom styled country',
              prefixIcon: Icon(Icons.flag, color: Colors.deepPurple.shade300),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              filled: true,
              fillColor: Theme.of(context).colorScheme.tertiaryContainer,
            ),
          ),
          const SizedBox(height: 24),
          Text('Styled Multi Selection',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          DropDownTextField.multiSelection(
            controller: _multiCtrl,
            dropDownList: frameworks,
            displayCompleteItem: true,
            submitButtonText: 'Done',
            submitButtonColor: Colors.deepPurple,
            dropdownRadius: 24,
            dropdownColor: Theme.of(context).colorScheme.tertiaryContainer,
            checkBoxProperty: CheckBoxProperty(
              activeColor: Colors.deepPurple,
              checkColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            dropDownIconProperty: const IconProperty(
              icon: Icons.playlist_add_check_circle_outlined,
              color: Colors.deepPurple,
              size: 28,
            ),
            textFieldDecoration: InputDecoration(
              hintText: 'Pick frameworks',
              prefixIcon: Icon(Icons.widgets, color: Colors.deepPurple.shade300),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              filled: true,
              fillColor: Theme.of(context).colorScheme.tertiaryContainer,
            ),
          ),
        ],
      ),
    );
  }
}
