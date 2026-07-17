package com.example.sms.service;
import com.example.sms.dto.LoginDto;
import com.example.sms.dto.RegisterDto;
public interface AuthService {
    String login(LoginDto loginDto);
    String register(RegisterDto registerDto);
}
