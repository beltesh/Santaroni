/// One wishlist item: a description and an optional link.
class WishlistEntry {
  const WishlistEntry(this.text, [this.url]);

  final String text;
  final String? url;

  @override
  bool operator ==(Object other) =>
      other is WishlistEntry && other.text == text && other.url == url;

  @override
  int get hashCode => Object.hash(text, url);

  @override
  String toString() => url == null ? text : '$text <$url>';
}
