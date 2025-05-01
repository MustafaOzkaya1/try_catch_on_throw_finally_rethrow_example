import 'dart:async';  // Dart'ın Stream ve Future gibi asenkron işlevselliği için gerekli kütüphaneyi içeri aktarıyoruz.
StreamController _myStreamController = StreamController();  // StreamController nesnesi oluşturuyoruz. Bu, asenkron veri akışını yönetmek için kullanılacak.
void main() {
  try {
    fetchData();  // main fonksiyonu uygulamanın başlangıç noktasıdır ve burada fetchData fonksiyonu çağrılarak veri akışının başlatılması sağlanır.
  } on ExceptionA { 
    print("A type error has been detected");  // ExceptionA türü bir hata oluşursa, burada mesaj yazdırılacak.
  } on ExceptionB {
    print("B type error has been detected");  // ExceptionB türü bir hata oluşursa, burada mesaj yazdırılacak.
  } catch (e) {
    print("An error occurred: $e");  // Diğer tüm hatalar burada yakalanacak ve ekrana yazdırılacak.
  } finally {
    print("Code execution completed in every condition");  // Kod her durumda çalışacak bu kısım her zaman çalışır.
  }
}
class ExceptionA implements Exception {}  // ExceptionA, Exception sınıfından türemiş özel bir hata türüdür.
class ExceptionB implements Exception {}  // ExceptionB, Exception sınıfından türemiş özel bir hata türüdür.

void functionStreamController() async {
  // Bu fonksiyon, stream'e veri göndermek için asenkron bir şekilde çalışacak.

  for (int i = 0; i < 11; i++) {  // 0'dan 10'a kadar dönen bir döngü oluşturuyoruz.
    await Future.delayed(Duration(seconds: 2));  // Her adımda 2 saniye bekleme ekliyoruz, bu sayede veri her 2 saniyede bir gönderilecek.
    _myStreamController.sink.add(i * 2);  // Döngüdeki her bir sayıyı 2 ile çarparak stream'e ekliyoruz (i*2).
  }

  _myStreamController.close();  // Döngü tamamlandığında stream'i kapatıyoruz. Bu, veri akışının sonlanacağı anlamına gelir.
}
void fetchData() {
  functionStreamController();  // functionStreamController fonksiyonunu çağırarak veri akışını başlatıyoruz.
  _myStreamController.stream.listen((event) {
    try {
      if (event > 16) {
        throw ExceptionA();  // event 16'dan büyükse ExceptionA hatasını fırlatıyoruz.
      } else if (event > 10) {
        throw ExceptionB();  // event 10'dan büyükse ve 16'dan küçükse ExceptionB hatasını fırlatıyoruz.
      } else {
        print(event * 10);  // Event, 10'dan küçükse gelen veriyi 10 ile çarpıp ekrana yazdırıyoruz.
      }
    } catch (e) {
      print("Caught an error: $e");  // Eğer hata oluşursa, hata mesajı ekrana yazdırılır.
    }
  },
  onDone: () => print("Çalışma bitti"),  // Stream tamamlandığında çalışacak kodu belirtiyoruz. Bu durumda "Çalışma bitti" yazdırılacak.
  onError: (e) {  // Hata durumunda çalışacak kodu belirtiyoruz.
    print("Stream error: $e");  // Eğer bir hata olursa, bu hatayı ekrana yazdırıyoruz.
  },
  cancelOnError: true,  // Hata oluşursa, dinleyicinin otomatik olarak iptal edilmesini sağlıyoruz.
  );
}
