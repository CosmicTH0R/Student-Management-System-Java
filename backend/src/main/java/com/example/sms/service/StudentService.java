package com.example.sms.service;
import com.example.sms.dto.StudentDto;
import java.util.List;
public interface StudentService {
    StudentDto createStudent(StudentDto dto);
    StudentDto getStudentById(Long id);
    import com.example.sms.dto.StudentResponse;
    StudentResponse getAllStudents(int pageNo, int pageSize, String sortBy, String sortDir);
    StudentDto updateStudent(Long id, StudentDto dto);
    void deleteStudent(Long id);
}

