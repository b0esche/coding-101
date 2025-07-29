import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Tasksheet614 extends StatefulWidget {
  const Tasksheet614({super.key});

  @override
  State<Tasksheet614> createState() => _Tasksheet614State();
}

class _Tasksheet614State extends State<Tasksheet614> {
  late Future<int> _docCountFuture;
  late Future<Map<String, dynamic>?> _firstDocFuture;
  late Future<List<Map<String, dynamic>>> _allDocsFuture;

  @override
  void initState() {
    super.initState();
    _docCountFuture = _getDocCount();
    _firstDocFuture = _loadFirstDoc();
    _allDocsFuture = _loadAllDocs();
  }

  // Anzahl der Dokumente zählen
  Future<int> _getDocCount() async {
    final snapshot = await FirebaseFirestore.instance.collection('users').get();
    return snapshot.docs.length;
  }

  // Erstes Dokument laden
  Future<Map<String, dynamic>?> _loadFirstDoc() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('users').limit(1).get();

    if (snapshot.docs.isNotEmpty) {
      return snapshot.docs.first.data();
    } else {
      return null;
    }
  }

  // Alle Dokumente laden
  Future<List<Map<String, dynamic>>> _loadAllDocs() async {
    final snapshot = await FirebaseFirestore.instance.collection('users').get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Firestore Beispiel')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          spacing: 24,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FilledButton(
              onPressed: () {
                setState(() {
                  _docCountFuture = _getDocCount();
                });
              },
              child: const Text('get doc count'),
            ),
            FutureBuilder<int>(
              future: _docCountFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Fehler: ${snapshot.error}');
                } else {
                  return Text('Anzahl der Dokumente: ${snapshot.data}');
                }
              },
            ),

            FilledButton(
              onPressed: () {
                setState(() {
                  _firstDocFuture = _loadFirstDoc();
                });
              },
              child: const Text('load first document'),
            ),
            FutureBuilder<Map<String, dynamic>?>(
              future: _firstDocFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Fehler: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data == null) {
                  return const Text('Kein Dokument gefunden.');
                } else {
                  return Text('Erstes Dokument:\n${snapshot.data}');
                }
              },
            ),

            FilledButton(
              onPressed: () {
                setState(() {
                  _allDocsFuture = _loadAllDocs();
                });
              },
              child: const Text('load all docs'),
            ),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: _allDocsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Fehler: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('Keine Dokumente vorhanden.');
                } else {
                  return Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final doc = snapshot.data![index];
                        return ListTile(
                          title: Text(doc['name'] ?? 'Ohne Namen'),
                          subtitle: Text(doc.toString()),
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
