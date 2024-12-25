import 'dart:convert';
import 'package:dart_frog/dart_frog.dart';
import 'package:http/http.dart' as http;

const String slackWebhookUrl = 'https://hooks.slack.com/services/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';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.post) {
    return Response.json(
      statusCode: 405,
      body: {'error': 'Only POST requests are allowed'},
    );
  }

  final body = await context.request.json();
  final String? message = body['message'] as String?;
  final String? channel = body['channel'] as String?;

  if (message == null || message.isEmpty) {
    return Response.json(
      statusCode: 400,
      body: {'error': 'Message is required'},
    );
  }

  final Map<String, dynamic> slackPayload = {
    'text': message,
  };

  if (channel != null) {
    slackPayload['channel'] = channel;
  }

  try {
    final response = await http.post(
      Uri.parse(slackWebhookUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(slackPayload),
    );

    if (response.statusCode == 200) {
      return Response.json(
        body: {'success': true, 'message': 'Slack message sent successfully'},
      );
    } else {
      return Response.json(
        statusCode: response.statusCode,
        body: {'error': 'Failed to send Slack message', 'details': response.body},
      );
    }
  } catch (e) {
    return Response.json(
      statusCode: 500,
      body: {'error': 'Internal server error', 'details': e.toString()},
    );
  }
}