package com.example.sms.dto;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class CourseDto {
    private Long id;
    
    @NotBlank(message = "Course name is required")
    private String name;
    
    @NotBlank(message = "Course code is required")
    private String code;
    
    @NotNull(message = "Credits are required")
    @Min(value = 1, message = "Course must have at least 1 credit")
    private Integer credits;
    
    @NotNull(message = "Department ID is required")
    private Long departmentId;
}
