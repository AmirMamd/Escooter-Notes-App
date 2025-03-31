import 'package:email_otp/email_otp.dart';
import 'package:escooter_notes_app/utils/config/config.dart';

class EmailService {
  void init() {
    EmailOTP.config(
      appName: 'Escooter Notes',
      otpType: OTPType.numeric,
      expiry: 300000,
      // 5 minutes
      emailTheme: EmailTheme.v6,
      appEmail: 'escooternotes@gmail.com',
      otpLength: 4,
    );

    EmailOTP.setSMTP(
      host: 'smtp.gmail.com',
      emailPort: EmailPort.port587,
      secureType: SecureType.tls,
      username: 'escooternotes@gmail.com',
      password: AppwriteConfig.gmailInAppPassword,
    );
  }

  Future<bool> sendOtp(String email) async {
    return await EmailOTP.sendOTP(email: email);
  }

  Future<bool> verifyOtp(String code) async {
    return EmailOTP.verifyOTP(
      otp: code,
    );
  }
}
