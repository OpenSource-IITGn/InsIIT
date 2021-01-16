import 'package:hive/hive.dart';
import 'package:instiapp/data/feedContainer.dart';
import 'package:instiapp/data/messContainer.dart';
import 'package:instiapp/data/scheduleContainer.dart';
import 'package:instiapp/data/importantContactsContainer.dart';
import 'package:instiapp/data/shuttleContainer.dart';
import 'package:instiapp/data/representativesContainer.dart';
import 'package:instiapp/data/quickLinksContainer.dart';
import 'package:instiapp/data/fireBaseContainer.dart';
import 'package:instiapp/themeing/notifier.dart';
import 'package:path_provider/path_provider.dart';

var dataContainer;

class DataContainer {
  String baseUrl = "serene-reaches-30469.herokuapp.com";
  FeedContainer feed;
  MessContainer mess;
  //ScheduleContainer schedule = ScheduleContainer();
  ScheduleContainer schedule;
  ImportantContactsContainer contacts;
  ShuttleContainer shuttle;
  RepresentativesContainer representatives;
  QuickLinksContainer quickLinks;
  AuthContainer auth = AuthContainer();

  DataContainer() {
    feed = FeedContainer();
    mess = MessContainer();
    schedule = ScheduleContainer();
    contacts = ImportantContactsContainer();
    shuttle = ShuttleContainer();
    representatives = RepresentativesContainer();
    quickLinks = QuickLinksContainer();
  }

  Future<void> initializeCaches() async {
    await schedule.initializeCache();
    await mess.initializeCache();
  }

  getOtherData() {
    schedule.getData();
    contacts.getData();
    shuttle.getData();
    representatives.getData();
    quickLinks.getData();
  }
}
