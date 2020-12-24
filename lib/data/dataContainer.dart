import 'package:instiapp/data/feedContainer.dart';
import 'package:instiapp/data/messContainer.dart';
import 'package:instiapp/data/scheduleContainer.dart';

var dataContainer = DataContainer();

class DataContainer {
  String baseUrl = "serene-reaches-30469.herokuapp.com";
  FeedContainer feed = FeedContainer();
  MessContainer mess = MessContainer();
  ScheduleContainer schedule = ScheduleContainer();
}
