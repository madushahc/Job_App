class CloudinaryConfig {
  static const String cloudName =
      'dcaragpha'; 
  static const String uploadPreset =
      'job_app_profile_upload'; 
  static const String apiKey = '566776567789896'; 
  static const String apiSecret =
      'iI5FWAI0cKZFJyFQspeuDZc4pzs'; 
}

class RapidApiConfig {
  static const String host = 'jsearch.p.rapidapi.com';
  static const String apiKey =
      '48fea61a3fmsh72dc8d6f1b29208p1cd121jsn5b7f40a19052';

  static Map<String, String> getHeaders() {
    return {
      'x-rapidapi-host': host,
      'x-rapidapi-key': apiKey,
    };
  }
}
