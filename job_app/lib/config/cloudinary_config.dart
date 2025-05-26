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
      'a825ec3b19mshdcd90db93522f9ap1d88cfjsnca9e11a06a34';

  static Map<String, String> getHeaders() {
    return {
      'x-rapidapi-host': host,
      'x-rapidapi-key': apiKey,
    };
  }
}
