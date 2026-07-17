package com.example.sms.dto;
import lombok.*;
import java.util.List;
@Data
@AllArgsConstructor
@NoArgsConstructor
public class StudentResponse {
    private List<StudentDto> content;
    private int pageNo;
    private int pageSize;
    private long totalElements;
    private int totalPages;
    private boolean last;
}
