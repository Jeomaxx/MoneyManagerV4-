import 'dart:io';
import 'lib/services/voice_transaction_parser.dart';
import 'lib/services/gemini_ai_service.dart';
import 'lib/services/ai_transaction_parser.dart';
import 'lib/models/transaction.dart';

void main() async {
  print('🧪 === بدء اختبار شامل لميزات الذكاء الاصطناعي والصوت ===\n');
  
  // Test 1: Arabic Number Recognition
  print('📊 === اختبار تحليل الأرقام العربية ===');
  await testArabicNumbers();
  
  // Test 2: Gemini AI Setup and Connection
  print('\n🤖 === اختبار اتصال الذكاء الاصطناعي (Gemini) ===');
  await testGeminiConnection();
  
  // Test 3: Voice Transaction Parsing
  print('\n🎤 === اختبار تحليل المعاملات الصوتية ===');
  await testVoiceTransactionParsing();
  
  // Test 4: AI Transaction Parsing
  print('\n🧠 === اختبار تحليل المعاملات بالذكاء الاصطناعي ===');
  await testAiTransactionParsing();
  
  // Test 5: Compound Numbers and Edge Cases
  print('\n🔢 === اختبار الأرقام المركبة والحالات الخاصة ===');
  await testCompoundNumbers();
  
  print('\n✅ === انتهاء الاختبارات الشاملة ===');
}

Future<void> testArabicNumbers() async {
  print('اختبار تحليل أرقام "خمسمائة" بتنويعاتها المختلفة:');
  
  List<String> fiveHundredVariations = [
    'خمسمائة جنيه قهوة',
    'خمسمية جنيه أكل', 
    'خمسميه جنيه طعام',
    'خمسمايه جنيه مطعم',
    'خمسمیه جنيه غداء', // Persian ی
  ];
  
  for (String text in fiveHundredVariations) {
    var result = VoiceTransactionParser.parseVoiceInput(text);
    String status = result.amount == 500 ? '✅' : '❌';
    print('$status "$text" → ${result.amount} جنيه (متوقع: 500)');
  }
  
  print('\nاختبار أرقام عربية متنوعة:');
  Map<String, double> testNumbers = {
    'واحد': 1,
    'اثنين': 2,
    'عشرة': 10,
    'عشرين': 20, 
    'مية': 100,
    'مائة': 100,
    'الفين': 2000,
    'ألفين': 2000,
    'خمسة آلاف': 5000,
    'خمس آلاف': 5000,
  };
  
  for (var entry in testNumbers.entries) {
    String text = '${entry.key} جنيه';
    var result = VoiceTransactionParser.parseVoiceInput(text);
    String status = result.amount == entry.value ? '✅' : '❌';
    print('$status "$text" → ${result.amount} (متوقع: ${entry.value})');
  }
}

Future<void> testGeminiConnection() async {
  try {
    // Check environment variable
    final apiKey = Platform.environment['GEMINI_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      print('❌ مفتاح API غير موجود في متغيرات البيئة');
      return;
    }
    
    print('✅ مفتاح Gemini API موجود (${apiKey.length} حرف)');
    
    // Test service initialization
    var geminiService = GeminiAiService();
    print('✅ تم إنشاء خدمة Gemini بنجاح');
    
    if (geminiService.isAvailable) {
      print('✅ خدمة Gemini متاحة ومستعدة للاستخدام');
    } else {
      print('❌ خدمة Gemini غير متاحة');
    }
  } catch (e) {
    print('❌ خطأ في اختبار اتصال Gemini: $e');
  }
}

Future<void> testVoiceTransactionParsing() async {
  List<Map<String, dynamic>> testCases = [
    {
      'input': 'اشتريت قهوة بـ 25 جنيه',
      'expectedAmount': 25.0,
      'expectedType': 'مصروف',
      'expectedCategory': 'طعام'
    },
    {
      'input': 'دفعت فاتورة كهرباء 200 جنيه',
      'expectedAmount': 200.0,
      'expectedType': 'مصروف', 
      'expectedCategory': 'فواتير'
    },
    {
      'input': 'استلمت راتب خمسة آلاف جنيه',
      'expectedAmount': 5000.0,
      'expectedType': 'دخل',
      'expectedCategory': 'راتب'
    },
    {
      'input': 'ركبت تاكسي بـ خمسين جنيه',
      'expectedAmount': 50.0,
      'expectedType': 'مصروف',
      'expectedCategory': 'مواصلات'
    },
    {
      'input': 'دفعت إيجار الفين جنيه',
      'expectedAmount': 2000.0,
      'expectedType': 'مصروف',
      'expectedCategory': 'سكن'
    }
  ];
  
  for (var testCase in testCases) {
    print('\nاختبار: "${testCase['input']}"');
    var result = VoiceTransactionParser.parseVoiceInput(testCase['input']);
    
    String amountStatus = result.amount == testCase['expectedAmount'] ? '✅' : '❌';
    String typeStatus = result.type == testCase['expectedType'] ? '✅' : '❌';
    String categoryStatus = result.category == testCase['expectedCategory'] ? '✅' : '❌';
    
    print('  $amountStatus المبلغ: ${result.amount} (متوقع: ${testCase['expectedAmount']})');
    print('  $typeStatus النوع: ${result.type} (متوقع: ${testCase['expectedType']})');
    print('  $categoryStatus الفئة: ${result.category} (متوقع: ${testCase['expectedCategory']})');
    print('  📝 الملاحظة: ${result.note ?? "غير محدد"}');
  }
}

Future<void> testAiTransactionParsing() async {
  try {
    List<String> testInputs = [
      'اشتريت قهوة من ستاربكس بـ 45 جنيه امبارح',
      'دفعت فاتورة النت والكهرباء 350 جنيه',
      'استلمت مكافأة من الشركة 1500 جنيه',
      'ذهبت للدكتور ودفعت 300 جنيه للكشف',
      'اشتريت حذاء جديد بـ 800 جنيه من المول'
    ];
    
    for (String input in testInputs) {
      print('\nاختبار الذكاء الاصطناعي: "$input"');
      
      try {
        var result = await AiTransactionParser.parseTransactionInput(input);
        
        print('  💰 المبلغ: ${result.amount} جنيه');
        print('  📂 الفئة: ${result.category}');
        print('  📊 النوع: ${result.type}');
        print('  🎯 الثقة: ${(result.confidence * 100).toStringAsFixed(1)}%');
        print('  🛠️ الطريقة: ${result.parsingMethod}');
        print('  📝 الملاحظة: ${result.note ?? "غير محدد"}');
        
        String confidenceStatus = result.confidence > 0.7 ? '✅ ثقة عالية' : '⚠️ ثقة متوسطة';
        print('  $confidenceStatus');
        
      } catch (e) {
        print('  ❌ خطأ في تحليل الذكاء الاصطناعي: $e');
      }
    }
  } catch (e) {
    print('❌ خطأ عام في اختبار الذكاء الاصطناعي: $e');
  }
}

Future<void> testCompoundNumbers() async {
  print('اختبار الأرقام المركبة بـ "و":');
  
  Map<String, double> compoundTests = {
    'خمسة وعشرين جنيه': 30.0, // 5 + 25 = 30
    'مية وخمسين جنيه': 150.0, // 100 + 50 = 150
    'ثلاثة وثلاثين جنيه': 36.0, // 3 + 33 = 36 (though this might not parse correctly)
  };
  
  for (var entry in compoundTests.entries) {
    var result = VoiceTransactionParser.parseVoiceInput(entry.key);
    String status = result.amount == entry.value ? '✅' : '❌';
    print('$status "${entry.key}" → ${result.amount} (متوقع: ${entry.value})');
  }
  
  print('\nاختبار حالات خاصة:');
  
  List<String> edgeCases = [
    '500 جنيه', // رقم إنجليزي
    '٥٠٠ جنيه', // رقم عربي
    'نص جنيه', // كسر
    'جنيه واحد', // ترتيب مختلف
    'فلوس كتير', // غير محدد
  ];
  
  for (String testCase in edgeCases) {
    var result = VoiceTransactionParser.parseVoiceInput(testCase);
    print('🔍 "$testCase" → ${result.amount ?? "غير محدد"} جنيه');
  }
}