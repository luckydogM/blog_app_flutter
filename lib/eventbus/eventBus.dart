import 'package:event_bus/event_bus.dart';

EventBus eventBus = new EventBus();

class MyEvent {
  bool isFront;
  MyEvent(this.isFront);
}