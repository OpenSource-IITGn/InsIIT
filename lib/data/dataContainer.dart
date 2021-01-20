import 'package:instiapp/data/feedContainer.dart';
import 'package:instiapp/data/messContainer.dart';
import 'package:instiapp/data/scheduleContainer.dart';
import 'package:instiapp/data/importantContactsContainer.dart';
import 'package:instiapp/data/shuttleContainer.dart';
import 'package:instiapp/data/representativesContainer.dart';
import 'package:instiapp/data/quickLinksContainer.dart';
import 'package:instiapp/data/authContainer.dart';
import 'package:instiapp/utilities/googleSheets.dart';

var dataContainer;

class DataContainer {
  String baseUrl = "serene-reaches-30469.herokuapp.com";
  GSheet sheet = GSheet('1dEsbM4uTo7VeOZyJE-8AmSWJv_XyHjNSVsKpl1GBaz8');
  FeedContainer feed = FeedContainer();
  MessContainer mess = MessContainer();

  ScheduleContainer schedule = ScheduleContainer();
  ImportantContactsContainer contacts = ImportantContactsContainer();
  ShuttleContainer shuttle = ShuttleContainer();
  RepresentativesContainer representatives = RepresentativesContainer();
  QuickLinksContainer quickLinks = QuickLinksContainer();
  AuthContainer auth = AuthContainer();

  Future<void> initializeCaches() async {
    await schedule.initializeCache();
    await mess.initializeCache();
    await sheet.initializeCache();
  }

  getOtherData() {
    schedule.getData();
    contacts.getData();
    shuttle.getData();
    representatives.getData();
    quickLinks.getData();
  }
}
