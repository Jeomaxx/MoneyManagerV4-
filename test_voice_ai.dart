#!/usr/bin/env dart

import 'dart:io';

// Simple test that doesn't require Flutter dependencies
void main() async {
  print('🎤 Testing Voice Transaction Parsing\n');
  
  // Test cases for voice parsing (focusing on Arabic numbers)
  List<String> testInputs = [
    'اشتريت قهوة بـ 25 جنيه',
    'دفعت فاتورة كهرباء 200 جنيه', 
    'ركبت تاكسي بـ 50 جنيه',
    'استلمت راتب خمسة آلاف جنيه',
    'اشتريت طعام بـ 150 جنيه',
    'دفعت إيجار الفين جنيه',
    'ذهبت للدكتور 30 جنيه',
    'خمسمائة جنيه', // Test the main case
    'خمسمية جنيه مصروفات',
    'خمسمایه للطعام',
    'خمسميه ملابس',
    'خمسمايه تسوق',
  ];
  
  print('📝 Voice Parsing Number Extraction Tests:');
  print('=' * 60);
  
  for (String input in testInputs) {
    print('Input: "$input"');
    
    // Test Arabic number extraction manually
    double? amount = _extractAmount(input);
    String type = _extractType(input);
    String category = _extractCategory(input);
    
    print('  Amount: ${amount ?? "NOT FOUND"}');
    print('  Type: $type');  
    print('  Category: $category');
    print('  Valid: ${amount != null && amount > 0}');
    print('---');
  }
  
  print('\n🔑 Gemini API Key Test:');
  print('=' * 40);
  String apiKey = Platform.environment['GEMINI_API_KEY'] ?? '';
  if (apiKey.isNotEmpty) {
    print('✅ GEMINI_API_KEY is available (${apiKey.length} characters)');
    print('   Starts with: ${apiKey.substring(0, apiKey.length.clamp(0, 10))}...');
  } else {
    print('❌ GEMINI_API_KEY is not available');
  }
  
  print('\n✅ Testing Complete!');
}

// Simplified number extraction (mirrors voice parser logic)
double? _extractAmount(String text) {
  text = text.toLowerCase().trim();
  
  // Try numeric first
  RegExp numberRegex = RegExp(r'\d+(\.\d+)?');
  Match? match = numberRegex.firstMatch(text);
  if (match != null) {
    return double.tryParse(match.group(0)!);
  }
  
  // Arabic numbers mapping (key ones for testing)
  Map<String, int> arabicNumbers = {
    'خمسمية': 500,
    'خمسمائة': 500,
    'خمسميه': 500,
    'خمسمايه': 500,
    'خمسمایه': 500, // Alternative spelling
    'ألف': 1000,
    'الف': 1000,
    'الفين': 2000,
    'ألفين': 2000,
    'خمسة آلاف': 5000,
    'خمس آلاف': 5000,
    'مية': 100,
    'مائة': 100,
    'ميتين': 200,
    'مائتين': 200,
  };
  
  // Sort by length to match longest first
  List<String> sortedKeys = arabicNumbers.keys.toList()
    ..sort((a, b) => b.length.compareTo(a.length));
  
  for (String numberWord in sortedKeys) {
    if (text.contains(numberWord)) {
      return arabicNumbers[numberWord]!.toDouble();
    }
  }
  
  return null;
}

String _extractType(String text) {
  text = text.toLowerCase();
  
  if (text.contains('راتب') || text.contains('دخل') || text.contains('استلمت')) {
    return 'income';
  }
  return 'expense';
}

String _extractCategory(String text) {
  text = text.toLowerCase();
  
  if (text.contains('قهوة') || text.contains('طعام') || text.contains('أكل')) return 'طعام';
  if (text.contains('كهرباء') || text.contains('فاتورة')) return 'فواتير';
  if (text.contains('تاكسي') || text.contains('مواصلات')) return 'مواصلات';
  if (text.contains('راتب')) return 'راتب';
  if (text.contains('إيجار') || text.contains('ايجار')) return 'سكن';
  if (text.contains('دكتور') || text.contains('صحة')) return 'صحة';
  if (text.contains('ملابس')) return 'ملابس';
  if (text.contains('تسوق')) return 'تسوق';
  
  return 'أخرى';
}