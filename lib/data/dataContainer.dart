import 'package:instiapp/data/feedContainer.dart';
import 'package:instiapp/data/messContainer.dart';
import 'package:instiapp/data/scheduleContainer.dart';
import 'package:instiapp/data/importantContactsContainer.dart';
import 'package:instiapp/data/shuttleContainer.dart';
import 'package:instiapp/data/representativesContainer.dart';
import 'package:instiapp/data/quickLinksContainer.dart';
import 'package:instiapp/data/fireBaseContainer.dart';

var dataContainer = DataContainer();

class DataContainer {
  String baseUrl = "serene-reaches-30469.herokuapp.com";
  FeedContainer feed = FeedContainer();
  MessContainer mess = MessContainer();
  ScheduleContainer schedule = ScheduleContainer();
  ImportantContactsContainer contacts = ImportantContactsContainer();
  ShuttleContainer shuttle = ShuttleContainer();
  RepresentativesContainer representatives = RepresentativesContainer();
  QuickLinksContainer quickLinks = QuickLinksContainer();
  FireBaseContainer fireBase = FireBaseContainer();

  getOtherData() {
    schedule.getData();
    contacts.getData();
    shuttle.getData();
    representatives.getData();
    quickLinks.getData();
  }
}
