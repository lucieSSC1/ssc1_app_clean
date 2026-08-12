import 'package:flutter/material.dart';
import '../../models/residence_model.dart';
import '../../services/residence_service.dart';
import 'residence_detail.dart';
import 'residence_form.dart';

class ResidenceList extends StatefulWidget {
  const ResidenceList({super.key});

  @override
  State<ResidenceList> createState() => _ResidenceListState();
}

class _ResidenceListState extends State<ResidenceList> {
  final _service = ResidenceService();
  List<Residence> _items = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _charger();
  }

  Future<void> _charger() async {
    _items = await _service.getAll();
    setState(() => _loading = false);
  }

  Future<void> _ajouter() async {
    final updated = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ResidenceForm()),
    );

    if (updated == true) {
      _charger();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Résidences"),
        actions: [IconButton(icon: const Icon(Icons.add), onPressed: _ajouter)],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _items.length,
              itemBuilder: (_, i) {
                final r = _items[i];

                return ListTile(
                  title: Text(r.adresse),
                  subtitle: Text("${r.ville}, ${r.province}"),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () async {
                    final updated = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ResidenceDetail(residence: r),
                      ),
                    );

                    if (updated == true) {
                      _charger();
                    }
                  },
                );
              },
            ),
    );
  }
}
