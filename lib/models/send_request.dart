class SendRequest {
  final String medium;
  final String message;
  final String senderId;
  final String requestType;
  final String number;
  final int expiryTime;
  final int codeLength;

  SendRequest({
    required this.medium,
    required this.message,
    required this.senderId,
    required this.requestType,
    required this.number,
    required this.expiryTime,
    required this.codeLength,
  });
}
