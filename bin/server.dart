import 'dart:io';
import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_static/shelf_static.dart';
import 'package:shelf_router/shelf_router.dart';

void main() async {
  // Get port from environment variable, defaulting to 5000
  final port = int.parse(Platform.environment['PORT'] ?? '5000');
  
  // Create a handler for static files (serve from web/ directory instead of build/web)
  final staticHandler = createStaticHandler(
    'web',
    defaultDocument: 'index.html',
    listDirectories: false,
  );
  
  // Create a comprehensive landing page for the expense manager
  final indexHtml = '''
<!DOCTYPE html>
<html dir="rtl" lang="ar">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>مدير المصروفات الشخصية</title>
  <link rel="manifest" href="manifest.json">
  <link rel="icon" type="image/png" href="favicon.png"/>
  <style>
    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
    }
    body {
      font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
      line-height: 1.6;
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      min-height: 100vh;
      direction: rtl;
    }
    .container {
      max-width: 1200px;
      margin: 0 auto;
      padding: 20px;
    }
    .header {
      text-align: center;
      color: white;
      margin-bottom: 2rem;
      padding: 2rem 0;
    }
    .header h1 {
      font-size: 3rem;
      margin-bottom: 1rem;
      text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
    }
    .header p {
      font-size: 1.2rem;
      opacity: 0.9;
    }
    .status {
      background: rgba(76, 175, 80, 0.9);
      color: white;
      padding: 1rem;
      border-radius: 10px;
      text-align: center;
      margin: 2rem auto;
      max-width: 500px;
      box-shadow: 0 4px 15px rgba(0,0,0,0.2);
    }
    .features-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(350px, 1fr));
      gap: 2rem;
      margin: 2rem 0;
    }
    .feature-card {
      background: rgba(255, 255, 255, 0.95);
      padding: 2rem;
      border-radius: 15px;
      box-shadow: 0 8px 32px rgba(0,0,0,0.1);
      backdrop-filter: blur(10px);
      border: 1px solid rgba(255, 255, 255, 0.2);
      transition: transform 0.3s ease;
    }
    .feature-card:hover {
      transform: translateY(-5px);
    }
    .feature-card h3 {
      color: #2c3e50;
      margin-bottom: 1rem;
      font-size: 1.4rem;
      display: flex;
      align-items: center;
      gap: 10px;
    }
    .feature-card ul {
      list-style: none;
    }
    .feature-card li {
      margin: 0.5rem 0;
      padding: 0.5rem;
      background: rgba(103, 126, 234, 0.1);
      border-radius: 5px;
      border-right: 3px solid #667eea;
    }
    .tech-stack {
      background: rgba(255, 255, 255, 0.1);
      backdrop-filter: blur(10px);
      padding: 2rem;
      border-radius: 15px;
      margin: 2rem 0;
      color: white;
    }
    .tech-stack h3 {
      text-align: center;
      margin-bottom: 1.5rem;
      font-size: 1.8rem;
    }
    .tech-items {
      display: flex;
      flex-wrap: wrap;
      gap: 1rem;
      justify-content: center;
    }
    .tech-item {
      background: rgba(255, 255, 255, 0.2);
      padding: 0.5rem 1rem;
      border-radius: 25px;
      font-size: 0.9rem;
      border: 1px solid rgba(255, 255, 255, 0.3);
    }
    .footer {
      text-align: center;
      color: white;
      margin-top: 3rem;
      padding: 2rem;
      font-size: 1.1rem;
    }
    .demo-notice {
      background: rgba(255, 193, 7, 0.9);
      color: #856404;
      padding: 1.5rem;
      border-radius: 10px;
      text-align: center;
      margin: 2rem auto;
      max-width: 600px;
      box-shadow: 0 4px 15px rgba(0,0,0,0.2);
    }
    @media (max-width: 768px) {
      .header h1 { font-size: 2rem; }
      .features-grid { grid-template-columns: 1fr; }
      .container { padding: 10px; }
    }
  </style>
</head>
<body>
  <div class="container">
    <div class="header">
      <h1>💰 مدير المصروفات الشخصية</h1>
      <p>تطبيق شامل لإدارة المصروفات والمالية الشخصية</p>
    </div>
    
    <div class="status">
      ✅ الخادم يعمل بنجاح على المنفذ 5000
    </div>
    
    <div class="demo-notice">
      <strong>⚠️ ملاحظة هامة:</strong> هذا عرض توضيحي لواجهة الخادم. التطبيق الكامل يتطلب بناء مشروع Flutter للحصول على الواجهة التفاعلية الكاملة.
    </div>

    <div class="features-grid">
      <div class="feature-card">
        <h3>🚀 الميزات الأساسية</h3>
        <ul>
          <li>تتبع المصروفات عبر منصات متعددة</li>
          <li>إدخال صوتي للمصروفات</li>
          <li>تصنيف ذكي بالذكاء الاصطناعي</li>
          <li>تصور البيانات بالمخططات التفاعلية</li>
          <li>تصدير البيانات (CSV/Excel)</li>
          <li>دعم متعدد اللغات</li>
        </ul>
      </div>
      
      <div class="feature-card">
        <h3>📱 دعم المنصات</h3>
        <ul>
          <li>تطبيق ويب تفاعلي (PWA)</li>
          <li>تطبيق iOS أصلي</li>
          <li>تطبيق Android أصلي</li>
          <li>تطبيق Windows للسطح المكتب</li>
          <li>تطبيق Linux للسطح المكتب</li>
          <li>تطبيق macOS للسطح المكتب</li>
        </ul>
      </div>
      
      <div class="feature-card">
        <h3>🎯 الذكاء الاصطناعي</h3>
        <ul>
          <li>تصنيف تلقائي للمصروفات</li>
          <li>تحليل أنماط الإنفاق</li>
          <li>اقتراحات لتوفير المال</li>
          <li>تنبيهات ذكية للميزانية</li>
          <li>تقارير مالية مخصصة</li>
          <li>تكامل مع Google AI</li>
        </ul>
      </div>
      
      <div class="feature-card">
        <h3>🔒 الأمان والخصوصية</h3>
        <ul>
          <li>تخزين محلي آمن للبيانات</li>
          <li>تشفير البيانات الحساسة</li>
          <li>نظام مصادقة متقدم</li>
          <li>نسخ احتياطية مؤمنة</li>
          <li>عدم مشاركة البيانات مع أطراف ثالثة</li>
          <li>امتثال لمعايير الخصوصية</li>
        </ul>
      </div>
    </div>

    <div class="tech-stack">
      <h3>🛠️ التقنيات المستخدمة</h3>
      <div class="tech-items">
        <span class="tech-item">Flutter</span>
        <span class="tech-item">Dart</span>
        <span class="tech-item">Hive Database</span>
        <span class="tech-item">SQLite</span>
        <span class="tech-item">Google AI</span>
        <span class="tech-item">Material Design</span>
        <span class="tech-item">PWA</span>
        <span class="tech-item">Shelf Framework</span>
        <span class="tech-item">Speech Recognition</span>
        <span class="tech-item">FL Chart</span>
      </div>
    </div>

    <div class="footer">
      <p>🚀 جاهز للنشر والاستخدام في الإنتاج</p>
      <p style="font-size: 0.9rem; opacity: 0.8; margin-top: 1rem;">
        مطور بواسطة Flutter • يعمل على Replit
      </p>
    </div>
  </div>
</body>
</html>
''';
  
  // Create a proper SPA fallback handler that only serves index.html for HTML requests
  Handler spaFallbackHandler = (request) {
    // Only serve index.html for GET requests that accept HTML
    if (request.method == 'GET') {
      final acceptHeader = request.headers['accept'] ?? '';
      if (acceptHeader.contains('text/html')) {
        return Response.ok(
          indexHtml,
          headers: {'content-type': 'text/html; charset=utf-8'},
        );
      }
    }
    // Return 404 for non-HTML requests and missing assets
    return Response.notFound('Not Found');
  };
  
  // Add API routes handler
  final apiHandler = Router()
    ..post('/api/ai/parse', _handleAiParseTransaction)
    ..post('/api/ai/analyze', _handleAiAnalyzeFinancials)
    ..post('/api/ai/suggest', _handleAiSuggestions);
  
  // Create a cascade handler with API routes
  final cascadeHandler = Cascade()
    .add(apiHandler)
    .add(staticHandler)
    .add(spaFallbackHandler)
    .handler;
  
  // Add basic middleware
  final handler = Pipeline()
    .addMiddleware(logRequests())
    .addHandler(cascadeHandler);
  
  // Start the server
  final server = await shelf_io.serve(
    handler,
    '0.0.0.0',
    port,
  );
  
  print('Server running on http://${server.address.host}:${server.port}');
}