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
      '45e6271b49msh02064a264dbc139p15c911jsnb36740740f5b';

  static Map<String, String> getHeaders() {
    return {
      'x-rapidapi-host': host,
      'x-rapidapi-key': apiKey,
    };
  }
}
