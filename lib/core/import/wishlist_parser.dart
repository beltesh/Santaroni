import '../model/wishlist_entry.dart';

export '../model/wishlist_entry.dart';

final _trailingUrl = RegExp(r'(?:^|\s)((?:https?://|www\.)\S+)$',
    caseSensitive: false);
final _separators = RegExp(r'\s*(?:\r\n|\r|\n|\s\|\s)\s*');

/// Splits a wishlist cell into items.
///
/// Items are separated by line breaks (Alt+Enter in a spreadsheet cell) or
/// " | ". When an item ends with a link, the link is split off; an item that
/// is only a link uses the link as its text too.
///
/// "Saga Vol. 1 https://example.com/saga" →
///   WishlistEntry("Saga Vol. 1", "https://example.com/saga")
List<WishlistEntry> parseWishlist(String cell) {
  final items = <WishlistEntry>[];
  for (final raw in cell.split(_separators)) {
    final item = raw.trim();
    if (item.isEmpty) continue;
    items.add(parseWishlistItem(item));
  }
  return items;
}

WishlistEntry parseWishlistItem(String item) {
  final match = _trailingUrl.firstMatch(item);
  if (match == null) return WishlistEntry(item);

  var url = match.group(1)!;
  if (url.toLowerCase().startsWith('www.')) url = 'https://$url';
  final text = item
      .substring(0, match.start)
      .trim()
      // Drop separators people put before links: "Book - https://…".
      .replaceAll(RegExp(r'[\s\-–—:|,]+$'), '');
  return WishlistEntry(text.isEmpty ? url : text, url);
}
