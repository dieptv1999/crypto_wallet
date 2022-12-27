import 'dart:convert';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:crypto/crypto.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class CameraService {
  static final CameraService _singleton = CameraService._internal();

  factory CameraService() {
    return _singleton;
  }

  CameraService._internal();

  Future<CameraDescription> takePhoto() async {
    final cameras = await availableCameras();

    final firstCamera = cameras.first;
    return firstCamera;
  }

  Future<String> hashImage(Uint8List? desc) async {
    String encoded = sha256.convert(desc!).toString();
    return encoded;
  }
}
