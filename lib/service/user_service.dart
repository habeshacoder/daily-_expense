import 'package:exp_tracker/nfc_app/model/connected_friends_model.dart';

class UserService {
  static final instance = UserService._privateConstructor();

  UserService._privateConstructor() {
    // initialization here.
  }

  //only for [NFC APP] do not use this for other use cases
  List<TagModel> allSharedTag = [];
}
