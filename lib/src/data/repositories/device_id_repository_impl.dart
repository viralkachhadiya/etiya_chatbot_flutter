import 'package:etiya_chatbot_flutter/src/domain/device_id_repository.dart';
import 'package:etiya_chatbot_flutter/src/util/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class DeviceIdRepositoryImpl extends DeviceIdRepository {
  String _generateDeviceId() {
    final uuid = const Uuid().v1();
    return uuid;
  }

  @override
  Future<String> fetchDeviceId() async {
    const preferenceKey = Constants.deviceIDKey;
    final sp = await SharedPreferences.getInstance();
    final deviceId = sp.getString(preferenceKey);
    if (deviceId == null) {
      final generatedDeviceID = _generateDeviceId();
      sp.setString(preferenceKey, generatedDeviceID);
      return generatedDeviceID;
    }
    return deviceId;
  }
}