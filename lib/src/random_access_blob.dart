import 'dart:html';
import 'dart:async';

class RandomAccessBlob {
  RandomAccessBlob(this.blob);

  Future<List<int>> read(int count) {
    final int startOffset = _offset;
    if (startOffset >= _cachedOffset &&
      _cachedBytes.length >= startOffset+count-_cachedOffset) {
      int listOffset = startOffset-_cachedOffset;
      return new Future.value(_cachedBytes.sublist(listOffset,
        listOffset+count));
    }
    Completer<List<int>> completer = new Completer();
    FileReader reader = new FileReader();
    reader.onLoad.listen((_) {
      _cachedBytes = reader.result as List<int>;
      _cachedOffset = startOffset;
      completer.complete(_cachedBytes.sublist(0, count));
    });
    reader.onLoadEnd.listen((ProgressEvent event) {
      if (!completer.isCompleted)
        completer.completeError("Unknown error during blob read");
    });
    reader.onError.listen((Event event) {
      completer.completeError(event);
    });
    int bytesToRead = count;
    if (count < _MIN_CACHE_SIZE)
      bytesToRead = _MIN_CACHE_SIZE;
    reader.readAsArrayBuffer(blob.slice(startOffset, startOffset+bytesToRead));
    _offset += count;
    return completer.future;
  }

  Future<int> readByte() async {
    List<int> result = await read(1);
    return result[0];
  }

  void setPosition(int newOffset) {
    _offset = newOffset;
  }

  int position() => _offset;

  final Blob blob;
  int _offset = 0;
  int _cachedOffset = 0;
  List<int> _cachedBytes = const [ ];

  static final int _MIN_CACHE_SIZE = 4096;
}
