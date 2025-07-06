import 'package:flutter/material.dart';
import '../models/minuman.dart';
import '../services/minuman_service.dart';

class MinumanProvider extends ChangeNotifier {
  final MinumanService _service = MinumanService();
  List<Minuman> _list = [];

  List<Minuman> get minumanList => _list;

  Future<void> loadMinuman() async {
    _list = await _service.getAllMinuman();
    notifyListeners();
  }

  Future<void> addMinuman(String nama, int harga) async {
    await _service.addMinuman(nama, harga);
    await loadMinuman();
  }

  Future<void> updateMinuman(Minuman m) async {
    await _service.updateMinuman(m);
    await loadMinuman();
  }

  Future<void> deleteMinuman(String id) async {
    await _service.deleteMinuman(id);
    await loadMinuman();
  }
}
