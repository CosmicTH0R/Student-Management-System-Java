package com.example.sms.service.impl;

import com.example.sms.dto.PagedResponse;
import com.example.sms.dto.StudentDto;
import com.example.sms.entity.Department;
import com.example.sms.entity.Student;
import com.example.sms.exception.ResourceNotFoundException;
import com.example.sms.repository.DepartmentRepository;
import com.example.sms.repository.StudentRepository;
import com.example.sms.service.StudentService;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class StudentServiceImpl implements StudentService {

    private final StudentRepository studentRepository;
    private final DepartmentRepository departmentRepository;

    @Override
    @Transactional
    public StudentDto createStudent(StudentDto dto) {
        if (studentRepository.existsByEmail(dto.getEmail())) {
            throw new RuntimeException("Email already exists");
        }

        Department department = departmentRepository.findById(dto.getDepartmentId())
                .orElseThrow(() -> new ResourceNotFoundException("Department", "id", dto.getDepartmentId()));

        Student student = new Student();
        student.setFirstName(dto.getFirstName());
        student.setLastName(dto.getLastName());
        student.setEmail(dto.getEmail());
        student.setEnrollmentDate(dto.getEnrollmentDate());
        student.setCurrentSemester(dto.getCurrentSemester());
        student.setDepartment(department);

        Student savedStudent = studentRepository.save(student);
        return mapToDto(savedStudent);
    }

    @Override
    public StudentDto getStudentById(Long id) {
        Student student = studentRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Student", "id", id));
        return mapToDto(student);
    }

    @Override
    public PagedResponse<StudentDto> getAllStudents(int pageNo, int pageSize, String sortBy, String sortDir, String search) {
        Sort sort = sortDir.equalsIgnoreCase(Sort.Direction.ASC.name()) ? Sort.by(sortBy).ascending()
                : Sort.by(sortBy).descending();

        Pageable pageable = PageRequest.of(pageNo, pageSize, sort);
        Page<Student> students;

        if (search != null && !search.isEmpty()) {
            students = studentRepository.searchStudents(search, pageable);
        } else {
            students = studentRepository.findAll(pageable);
        }

        List<StudentDto> content = students.getContent().stream()
                .map(this::mapToDto)
                .collect(Collectors.toList());

        PagedResponse<StudentDto> response = new PagedResponse<>();
        response.setContent(content);
        response.setPageNo(students.getNumber());
        response.setPageSize(students.getSize());
        response.setTotalElements(students.getTotalElements());
        response.setTotalPages(students.getTotalPages());
        response.setLast(students.isLast());

        return response;
    }

    @Override
    public List<StudentDto> getStudentsByDepartment(Long departmentId) {
        Department department = departmentRepository.findById(departmentId)
                .orElseThrow(() -> new ResourceNotFoundException("Department", "id", departmentId));

        return studentRepository.findByDepartmentId(department.getId()).stream()
                .map(this::mapToDto)
                .collect(Collectors.toList());
    }

    @Override
    @Transactional
    public StudentDto updateStudent(Long id, StudentDto dto) {
        Student student = studentRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Student", "id", id));

        Department department = departmentRepository.findById(dto.getDepartmentId())
                .orElseThrow(() -> new ResourceNotFoundException("Department", "id", dto.getDepartmentId()));

        student.setFirstName(dto.getFirstName());
        student.setLastName(dto.getLastName());
        student.setEmail(dto.getEmail());
        student.setEnrollmentDate(dto.getEnrollmentDate());
        student.setCurrentSemester(dto.getCurrentSemester());
        student.setDepartment(department);

        Student updatedStudent = studentRepository.save(student);
        return mapToDto(updatedStudent);
    }

    @Override
    @Transactional
    public void deleteStudent(Long id) {
        Student student = studentRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Student", "id", id));
        studentRepository.delete(student);
    }

    private StudentDto mapToDto(Student student) {
        StudentDto dto = new StudentDto();
        dto.setId(student.getId());
        dto.setFirstName(student.getFirstName());
        dto.setLastName(student.getLastName());
        dto.setEmail(student.getEmail());
        dto.setEnrollmentDate(student.getEnrollmentDate());
        dto.setCurrentSemester(student.getCurrentSemester());
        if (student.getDepartment() != null) {
            dto.setDepartmentId(student.getDepartment().getId());
        }
        return dto;
    }
}
