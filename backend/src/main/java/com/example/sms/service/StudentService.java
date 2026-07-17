package com.example.sms.service;
import com.example.sms.dto.StudentDto;
import java.util.List;
public interface StudentService {
    StudentDto createStudent(StudentDto dto);
    StudentDto getStudentById(Long id);
    List<StudentDto> getAllStudents();
    StudentDto updateStudent(Long id, StudentDto dto);
    void deleteStudent(Long id);
}
