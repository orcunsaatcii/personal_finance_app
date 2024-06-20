class Category {
  Category({
    required this.categoryId,
    required this.name,
    required this.type,
  });

  int categoryId;
  String name;
  String type;
}


//! Category dao sınıfı oluştur bir category ekle.
//! Transaction sınıfı ve transaction dao sınıfı ekle
//! yeni bir transaction insert metodu yaz ve homepage de göstermeye çalış.
