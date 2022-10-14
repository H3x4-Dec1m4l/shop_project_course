class HtttpException implements Exception {
  final String msg;

  const HtttpException(this.msg);

  @override 
  String toString(){
    return msg;
  }
}