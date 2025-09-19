import 'lib/screens/add_transaction_screen.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

void main() async {
  print('🎤 === اختبار وظيفة التحويل من الصوت إلى النص ===\n');
  
  await testSpeechToTextAvailability();
  await testSpeechToTextPermissions();
  await testSpeechRecognitionSetup();
  
  print('\n✅ === انتهاء اختبار الصوت إلى النص ===');
}

Future<void> testSpeechToTextAvailability() async {
  print('📱 اختبار توفر خدمة Speech-to-Text:');
  
  try {
    stt.SpeechToText speech = stt.SpeechToText();
    bool available = await speech.initialize();
    
    if (available) {
      print('✅ خدمة Speech-to-Text متاحة');
      
      List<stt.LocaleName> locales = await speech.locales();
      print('🌐 اللغات المتاحة: ${locales.length}');
      
      // Check for Arabic support
      var arabicLocales = locales.where((locale) => 
        locale.localeId.contains('ar') || 
        locale.name.contains('Arabic') ||
        locale.name.contains('العربية')
      ).toList();
      
      if (arabicLocales.isNotEmpty) {
        print('✅ اللغة العربية مدعومة:');
        for (var locale in arabicLocales) {
          print('   - ${locale.name} (${locale.localeId})');
        }
      } else {
        print('⚠️ اللغة العربية قد لا تكون مدعومة مباشرة');
        print('📝 اللغات المتاحة:');
        for (var locale in locales.take(5)) {
          print('   - ${locale.name} (${locale.localeId})');
        }
      }
    } else {
      print('❌ خدمة Speech-to-Text غير متاحة');
    }
  } catch (e) {
    print('❌ خطأ في اختبار Speech-to-Text: $e');
  }
}

Future<void> testSpeechToTextPermissions() async {
  print('\n🔒 اختبار صلاحيات الميكروفون:');
  
  try {
    stt.SpeechToText speech = stt.SpeechToText();
    bool hasPermission = await speech.hasPermission;
    
    if (hasPermission) {
      print('✅ صلاحيات الميكروفون متوفرة');
    } else {
      print('⚠️ صلاحيات الميكروفون غير متوفرة');
      print('📝 يجب طلب الصلاحيات من المستخدم أولاً');
    }
  } catch (e) {
    print('❌ خطأ في فحص صلاحيات الميكروفون: $e');
  }
}

Future<void> testSpeechRecognitionSetup() async {
  print('\n⚙️ اختبار إعداد التعرف على الصوت:');
  
  try {
    stt.SpeechToText speech = stt.SpeechToText();
    
    print('📊 إحصائيات الخدمة:');
    print('   - متاحة: ${await speech.initialize()}');
    print('   - الحالة: ${speech.isAvailable ? "جاهز" : "غير جاهز"}');
    print('   - يستمع: ${speech.isListening ? "نعم" : "لا"}');
    
    // Test basic configuration
    var options = stt.SpeechListenOptions(
      onResult: (result) {
        print('🎯 نتيجة التعرف: ${result.recognizedWords}');
        print('   - الثقة: ${(result.confidence * 100).toStringAsFixed(1)}%');
        print('   - مكتمل: ${result.finalResult ? "نعم" : "لا"}');
      },
      listenFor: Duration(seconds: 5),
      pauseFor: Duration(seconds: 3),
      partialResults: true,
      cancelOnError: false,
    );
    
    print('✅ إعدادات التعرف على الصوت تم تحضيرها');
    print('   - مدة الاستماع: ${options.listenFor?.inSeconds} ثانية');
    print('   - مدة التوقف: ${options.pauseFor?.inSeconds} ثانية');
    print('   - النتائج الجزئية: ${options.partialResults ? "مفعل" : "معطل"}');
    
    // Test Arabic locale selection
    List<stt.LocaleName> locales = await speech.locales();
    var arabicLocale = locales.firstWhere(
      (locale) => locale.localeId.startsWith('ar'),
      orElse: () => locales.first,
    );
    
    print('🌐 اللغة المختارة: ${arabicLocale.name} (${arabicLocale.localeId})');
    
  } catch (e) {
    print('❌ خطأ في إعداد التعرف على الصوت: $e');
  }
}

// Test integration with your app
void testVoiceIntegrationFlow() {
  print('\n🔄 اختبار تدفق التكامل مع التطبيق:');
  
  print('📝 خطوات التكامل:');
  print('   1. المستخدم يضغط على زر الميكروفون');
  print('   2. فحص صلاحيات الميكروفون');
  print('   3. بدء التسجيل الصوتي');
  print('   4. تحويل الصوت إلى نص (Speech-to-Text)');
  print('   5. تحليل النص بالذكاء الاصطناعي أو القواعد');
  print('   6. استخراج: المبلغ، النوع، الفئة');
  print('   7. ملء الحقول تلقائياً');
  print('   8. عرض النتيجة للمستخدم للتأكيد');
  
  print('\n✅ تدفق التكامل جاهز للتطبيق');
}