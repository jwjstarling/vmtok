import 'package:flutter/material.dart';

import '../services/content_services.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? pageContent;
  Map<String, List<Map<String, dynamic>>>? contentByType;
  Map<String, String>? labels;

  @override
  void initState() {
    super.initState();
    //_fetchContent();
    _fetchLabels();
  }

  Future<void> _fetchLabels() async {
    labels = await getContentLabels('app.profile.intro');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    // Here, you would extract the content labels and other content from pageContent and contentByType
    // and display them using appropriate Flutter widgets.

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(100.0),
        child: Column(
          children: [
            Center(child:Text(labels?['page.apply.step1.name.label.error'] ?? 'Loading...')),
            Center(child:Text(labels?['page.apply.step1.name.label'] ?? 'Loading...')),
            Center(child:Text(labels?['page.apply.step1.title.label'] ?? 'Loading...')),
            Center(child:Text(labels?['page.apply.step1.next.cta.label'] ?? 'Loading...')),
            Center(child:Text(labels?['page.apply.step1.dob.label'] ?? 'Loading...')),
          ],
        ),
      ),
    );
    
  }
}
