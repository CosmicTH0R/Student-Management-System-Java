package com.example.sms.service;

import com.example.sms.dto.StudentDto;
import java.util.List;

public interface StudentService {
    StudentDto createStudent(StudentDto dto);
    StudentDto getStudentById(Long id);
    List<StudentDto> getAllStudents();
    List<StudentDto> getStudentsByDepartment(Long departmentId);
    StudentDto updateStudent(Long id, StudentDto dto);
    void deleteStudent(Long id);
}
