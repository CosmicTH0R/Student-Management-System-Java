package com.example.sms.service;

import com.example.sms.dto.PagedResponse;
import com.example.sms.dto.StudentDto;
import java.util.List;

public interface StudentService {
    StudentDto createStudent(StudentDto dto);
    StudentDto getStudentById(Long id);
    PagedResponse<StudentDto> getAllStudents(int pageNo, int pageSize, String sortBy, String sortDir, String search);
    List<StudentDto> getStudentsByDepartment(Long departmentId);
    StudentDto updateStudent(Long id, StudentDto dto);
    void deleteStudent(Long id);
}
