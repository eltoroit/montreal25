// Create request object
ExternalService.Slack.chatx5fpostMessage_Request request = new ExternalService.Slack.chatx5fpostMessage_Request();

// Set required parameters
request.token = 'TEST';  // Authentication token
request.channel = 'C085APRR75M';    // Channel to post to
request.text = 'Hello from Apex!';   // Message text

// Send message
ExternalService.Slack slack = new ExternalService.Slack();
try {
    System.debug('Before call');
    ExternalService.Slack.chatx5fpostMessage_Response response = slack.chatx5fpostMessage(request);
    System.debug('After call');
    // System.debug('Message sent successfully: ' + response);
} catch(ExternalService.Slack.chatx5fpostMessage_ResponseException e) {
    System.debug('Error sending message: ' + e.responseCode);
}