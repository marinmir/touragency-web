enum NetworkRequestType { get, post, patch, delete }

abstract class NetworkRequest {
  NetworkRequestType get type => NetworkRequestType.get;
  String get path => "";
  Map<String, String> get headers => {
    "Content-Type": "application/json"
  };
  Map<String, dynamic>? get parameters => null;
  Map<String, dynamic>? get body => null;

  Uri toUri(String host) {
    return Uri.http(host, path, parameters);
  }
}
