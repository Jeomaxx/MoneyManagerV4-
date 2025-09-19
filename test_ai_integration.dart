#!/usr/bin/env dart

import 'dart:io';
import 'dart:convert';

// Test AI integration using HTTP directly to verify the API key works
void main() async {
  print('🤖 Testing Google Gemini AI Integration\n');
  
  String apiKey = Platform.environment['GEMINI_API_KEY'] ?? '';
  if (apiKey.isEmpty) {
    print('❌ GEMINI_API_KEY not found');
    return;
  }
  
  print('✅ API Key found: ${apiKey.substring(0, 10)}...');
  print('🔍 Testing direct API call to Gemini...\n');
  
  // Test with a simple Arabic transaction parsing request
  String testInput = 'اشتريت قهوة من كافيه بـ 45 جنيه';
  
  try {
    // Create the HTTP client and request
    HttpClient client = HttpClient();
    String url = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$apiKey';
    
    HttpClientRequest request = await client.postUrl(Uri.parse(url));
    request.headers.set('Content-Type', 'application/json');
    
    // Create the request body for transaction parsing
    Map<String, dynamic> requestBody = {
      'contents': [
        {
          'parts': [
            {
              'text': '''
أنت مساعد ذكي لتحليل المعاملات المالية باللغة العربية.
قم بتحليل النص التالي واستخراج معلومات المعاملة المالية:

النص: "$testInput"

يجب أن تعيد JSON صحيح بالشكل التالي:
{
  "type": "income" أو "expense",
  "amount": رقم المبلغ,
  "category": الفئة المناسبة,
  "note": ملاحظة مختصرة,
  "confidence": نسبة الثقة من 0 إلى 1
}

فئات الدخل المتاحة: ["راتب", "مكافأة", "استثمار", "هدية", "بيع", "عمل إضافي", "أخرى"]
فئات المصروفات المتاحة: ["طعام", "مواصلات", "سكن", "فواتير", "صحة", "تسوق", "ملابس", "ترفيه", "تعليم", "أخرى"]

ملاحظات مهمة:
- استخدم "income" للدخل و "expense" للمصروفات
- اختر الفئة الأنسب من القائمة المتاحة
- إذا لم تجد فئة مناسبة، استخدم "أخرى"
- العملة المفترضة هي الجنيه المصري
'''
            }
          ]
        }
      ],
      'generationConfig': {
        'temperature': 0.1,
        'topP': 1,
        'topK': 1,
        'maxOutputTokens': 2048,
      }
    };
    
    String jsonBody = json.encode(requestBody);
    request.write(jsonBody);
    
    HttpClientResponse response = await request.close();
    String responseBody = await response.transform(utf8.decoder).join();
    
    print('Response Status: ${response.statusCode}');
    
    if (response.statusCode == 200) {
      print('✅ API call successful!');
      
      // Parse response
      Map<String, dynamic> responseData = json.decode(responseBody);
      
      if (responseData['candidates'] != null && 
          responseData['candidates'].isNotEmpty) {
        
        String aiText = responseData['candidates'][0]['content']['parts'][0]['text'];
        print('\n📝 AI Response:');
        print(aiText);
        
        // Try to extract JSON from the response
        try {
          String cleanJson = aiText.trim();
          if (cleanJson.startsWith('```json')) {
            cleanJson = cleanJson.substring(7);
          }
          if (cleanJson.startsWith('```')) {
            cleanJson = cleanJson.substring(3);
          }
          if (cleanJson.endsWith('```')) {
            cleanJson = cleanJson.substring(0, cleanJson.length - 3);
          }
          
          Map<String, dynamic> parsedTransaction = json.decode(cleanJson.trim());
          
          print('\n✅ Parsed Transaction:');
          print('   Type: ${parsedTransaction['type']}');
          print('   Amount: ${parsedTransaction['amount']}');
          print('   Category: ${parsedTransaction['category']}');
          print('   Note: ${parsedTransaction['note']}');
          print('   Confidence: ${parsedTransaction['confidence']}');
          
          if (parsedTransaction['amount'] != null && parsedTransaction['amount'] > 0) {
            print('\n🎉 Transaction parsing successful!');
          } else {
            print('\n⚠️ Transaction parsing incomplete');
          }
          
        } catch (e) {
          print('\n⚠️ Could not parse JSON response: $e');
          print('Raw response: $aiText');
        }
        
      } else {
        print('❌ No candidates in response');
      }
      
    } else {
      print('❌ API call failed');
      print('Response: $responseBody');
    }
    
    client.close();
    
  } catch (e) {
    print('❌ Error testing AI integration: $e');
  }
  
  print('\n✅ AI Integration Test Complete!');
}