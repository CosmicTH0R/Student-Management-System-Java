package com.example.sms.dto;
import lombok.*;
@Getter @Setter @NoArgsConstructor @AllArgsConstructor
public class RegisterDto {
    private String username;
    private String password;
    private String role;
}
