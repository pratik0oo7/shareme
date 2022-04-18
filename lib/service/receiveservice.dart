// ignore_for_file: always_use_package_imports, avoid_dynamic_calls

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shareme/configfile.dart';
import 'package:shareme/service/ipservice.dart';
import 'package:shareme/service/sharingobject_service.dart';


class ReceiverService extends ChangeNotifier {
  final ipService = localIpservice();
  // todo SharingObject instead
  final List<Receiver> receivers = [];

  bool loaded = false;
  int loop = 0;

  void kill() {
    loaded = false;
  }

  Future<void> init() async {
    await ipService.load();
    loaded = true;
    notifyListeners();

    while (true) {
      if (!loaded) {
        return;
      }

      final res = await compute(_run, ipService.getIp());
      receivers.clear();
      receivers.addAll(res);

      loop++;
      notifyListeners();
      await Future.delayed(const Duration(seconds: 1));
    }
  }

  static Future<List<Receiver>> _run(String _ip) async {
    final _ = _ip.split('.');
    final thisDevice = int.parse(_.removeLast());

    final ip = _.join('.');

    final devices = [
      for (var d in List.generate(254, (index) => index + 1))
        if (d != thisDevice) '$ip.$d'
    ];

    final futuresPing = <NetworkAddr, Future<bool>>{};

    // todo run first port every time, second every second time, etc
    for (final device in devices) {
      for (final port in ports) {
        final n = NetworkAddr(ip: device, port: port);
        futuresPing[n] = _ping(n);
      }
    }

    final futuresSharik = <Future<Receiver?>>[];

    for (final ping in futuresPing.entries) {
      final p = await ping.value;

      if (p) {
        futuresSharik.add(_hasSharik(ping.key));
      }
    }

    final result = <Receiver>[];

    for (final sharik in futuresSharik) {
      final r = await sharik;
      if (r != null) {
        result.add(r);
      }
    }

    return result;
  }

  static Future<Receiver?> _hasSharik(NetworkAddr addr) async {
    try {
      final result = await http
          .get(Uri.parse('http://${addr.ip}:${addr.port}/sharik.json'))
          .timeout(const Duration(milliseconds: 800));

      return Receiver.fromJson(addr: addr, json: result.body);
    } catch (_) {
      return null;
    }
  }

  // todo check if this works when sharing extra large files
  static Future<bool> _ping(NetworkAddr addr) async {
    try {
      final s = await Socket.connect(
        addr.ip,
        addr.port,
        timeout: const Duration(seconds: 1),
      );
      s.destroy();
      return true;
    } catch (_) {
      return false;
    }
  }
}

class NetworkAddr {
  final String ip;
  final int port;

  const NetworkAddr({
    required this.ip,
    required this.port,
  });
}

class Receiver {
  final NetworkAddr addr;

  final String os;
  final String name;
  final SharingObjectType type;

  const Receiver({
    required this.addr,
    required this.os,
    required this.name,
    required this.type,
  });

  factory Receiver.fromJson({required NetworkAddr addr, required String json}) {
    final parsed = jsonDecode(json);

    return Receiver(
      addr: addr,
      os: parsed['os'] as String,
      name: parsed['name'] as String,
      type: string2fileType(parsed['type'] as String),
    );
  }
}
