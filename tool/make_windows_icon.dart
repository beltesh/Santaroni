// Builds the multi-size Windows icon (windows/runner/resources/app_icon.ico)
// from assets/icons/santaroni-full.png, with rounded corners.
//
// Run from the project root: dart run tool/make_windows_icon.dart
//
// Each size is downscaled separately from the full image, so the small
// ones Windows uses for the title bar and taskbar (16-32 px) stay sharp.
import 'dart:io';
import 'dart:math' as math;

import 'package:image/image.dart' as img;

const source = 'assets/icons/santaroni-full.png';
const output = 'windows/runner/resources/app_icon.ico';
const sizes = [256, 128, 96, 64, 48, 40, 32, 24, 20, 16];

/// Corner radius as a fraction of the icon size. Set to 0 for square.
const cornerRadius = 0.18;

void main() {
  final src = img.decodeImage(File(source).readAsBytesSync())!;
  final rounded = img.Image(width: src.width, height: src.height, numChannels: 4);
  final r = src.width * cornerRadius;
  for (final p in src) {
    // Coverage from the distance to the nearest corner arc (anti-aliased).
    final cx = p.x < r ? r : (p.x > src.width - 1 - r ? src.width - 1 - r : p.x.toDouble());
    final cy = p.y < r ? r : (p.y > src.height - 1 - r ? src.height - 1 - r : p.y.toDouble());
    final d = math.sqrt(math.pow(p.x - cx, 2) + math.pow(p.y - cy, 2));
    final alpha = r == 0 ? 1.0 : (r - d + 0.5).clamp(0.0, 1.0);
    rounded.setPixelRgba(p.x, p.y, p.r, p.g, p.b, (alpha * 255).round());
  }

  final images = [
    for (final s in sizes)
      img.copyResize(rounded, width: s, height: s, interpolation: img.Interpolation.average),
  ];
  File(output).writeAsBytesSync(img.IcoEncoder().encodeImages(images));
  stdout.writeln('Wrote $output (${sizes.join(', ')} px)');
}
