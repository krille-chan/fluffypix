import 'dart:convert';

import 'package:fluffypix/model/fluffy_pix.dart';
import 'package:web_socket_channel/io.dart';

import 'notification.dart';
import 'status.dart';
import 'stream_update.dart';

extension FluffyPixWebsocketExtension on FluffyPix {
  void subscribeToWebsocket() async {
    final uri = instance!.resolveUri(
      Uri(
        scheme: 'wss',
        host: instance!.host,
        path: '${instance!.path}api/v1/streaming',
        queryParameters: {
          'access_token': accessTokenCredentials!.accessToken,
          'stream': 'user',
        },
      ),
    );
    final channel = IOWebSocketChannel.connect(uri.toString());
    onUpdateSub = channel.stream.listen(_handleWebsocketUpdate);
  }

  void _handleWebsocketUpdate(dynamic data) {
    final json = jsonDecode(data.toString()) as Map<String, dynamic>;
    final update = StreamUpdate.fromJson(json);
    switch (update.event) {
      case StreamUpdateEvent.update:
        onHomeTimelineUpdate.sink
            .add(Status.fromJson(jsonDecode(update.payload)));
        break;
      case StreamUpdateEvent.notification:
        onNotificationUpdate.sink
            .add(PushNotification.fromJson(jsonDecode(update.payload)));
        break;
      case StreamUpdateEvent.delete:
        onDeleteStatusUpdate.sink.add(update.payload);
        break;
      case StreamUpdateEvent.filters_changed:
        onChangeFilterUpdate.sink.add(null);
        break;
    }
  }

  void unsubscribeToWebsocket() {
    onUpdateSub?.cancel();
    channel?.sink.close();
  }
}
