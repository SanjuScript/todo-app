int normalizeId(String id) {
  return id.hashCode & 0x7FFFFFFF;
}