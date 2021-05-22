import 'package:instiapp/data/covidContainer.dart';
import 'package:instiapp/data/feedContainer.dart';
import 'package:instiapp/data/mapContainer.dart';
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

  FeedContainer feed = FeedContainer();
  MessContainer mess = MessContainer();

  ScheduleContainer schedule = ScheduleContainer();
  ImportantContactsContainer contacts = ImportantContactsContainer();
  ShuttleContainer shuttle = ShuttleContainer();
  RepresentativesContainer representatives = RepresentativesContainer();
  QuickLinksContainer quickLinks = QuickLinksContainer();
  AuthContainer auth = AuthContainer();
  MapContainer map = MapContainer();
  CovidContainer covid = CovidContainer();

  Future<void> initializeCaches() async {
    await schedule.initializeCache();
    await mess.initializeCache();
    await contacts.initializeCache();
    await shuttle.initializeCache();
    await representatives.initializeCache();
    await quickLinks.initializeCache();
    await map.initializeCache();
    await covid.initializeCache();
  }

  getOtherData({forceRefresh: false}) {
    schedule.getData(forceRefresh: forceRefresh);
    contacts.getData(forceRefresh: forceRefresh);
    shuttle.getData(forceRefresh: forceRefresh);
    representatives.getData(forceRefresh: forceRefresh);
    quickLinks.getData(forceRefresh: forceRefresh);
    covid.getData(forceRefresh: forceRefresh);
  }
}
