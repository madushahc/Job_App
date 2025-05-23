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
      '02e57dea4amsh5d35b1f8ef8ac3ap1c0bdbjsn7d6f596d0010';

  static Map<String, String> getHeaders() {
    return {
      'x-rapidapi-host': host,
      'x-rapidapi-key': apiKey,
    };
  }
}
