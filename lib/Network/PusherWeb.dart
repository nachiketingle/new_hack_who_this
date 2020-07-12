import 'dart:async';

import 'package:flutter_pusher/pusher.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class PusherWeb {
  Event lastEvent;
  String lastConnectionState;
  Channel channel;

  StreamController<String> _eventData = StreamController<String>();
  Sink get _inEventData => _eventData.sink;
  Stream get eventStream => _eventData.stream;

  Future<void> initPusher() async {
    try {
      print("Starting init pusher");
      await Pusher.init(DotEnv().env['PUSHER_KEY'],
          PusherOptions(cluster: DotEnv().env['PUSHER_CLUSTER']));
      print("Successfully init pusher");
    } catch (e) {
      print(e.message);
    }
  }

  void connectPusher() {
    Pusher.connect(
        onConnectionStateChange: (ConnectionStateChange connectionState) async {
      lastConnectionState = connectionState.currentState;
    }, onError: (ConnectionError e) {
      print("Error: ${e.message}");
    });
  }

  Future<void> subscribePusher(String channelName) async {
    channel = await Pusher.subscribe(channelName);
  }

  void unSubscribePusher(String channelName) {
    Pusher.unsubscribe(channelName);
  }

  void bindEvent(String eventName) {
    channel.bind(eventName, (last) {
      final String data = last.data;
      _inEventData.add(data);
    });
  }

  void unbindEvent(String eventName) {
    channel.unbind(eventName);
    _eventData.close();
  }

  Future<void> firePusher(String channelName, List<String> eventNames) async {
    await initPusher();
    connectPusher();
    await subscribePusher(channelName);
    for (String eventName in eventNames) {
      bindEvent(eventName);
      print("Subscribing on Channel Name: " + channelName + " Event Name: " + eventName);
    }
  }
}
