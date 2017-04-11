# webexif

Dart module to decode Exif data from tiff and jpeg files.

Web port of bigflood's command line Dart port:
<https://github.com/bigflood/dartexif>

which is a Dart port of ianaré sévi's EXIF library: <https://github.com/ianare/exif-py>.

## Installation

### Depend on it
Add this to your package's pubspec.yaml file:

```YAML
dependencies:
  webexif:
```

### Install it
You can install packages from the command line:
```
$ pub get
```

## Usage

Simple example:
```Dart
Future<int> getOrientation(Blob blob) async {
  if (blob.type == "image/jpeg") {
    Map<String, IfdTag> tags = await readExifFromBlob(blob);
    IfdTag tag = tags["Image Orientation"];
    if (tag == null)
      return -1;
    return tag.values[0] as int;
  }

  return -1;
}

void main() {
  document.querySelector("input[type=file]").
}

void registerChangeHandler(InputElement input) {
  input.onChange.listen((Event e) {
    for (File f in input.files) {
      getOrientation(f).then((int orientation) {
        window.console.log("Orientation for ${f.name} is ${orientation}");
      });
    }
  });
}
```
