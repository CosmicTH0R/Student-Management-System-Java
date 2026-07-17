package com.example.sms.service.impl;
import com.example.sms.dto.StudentDto;
import com.example.sms.dto.StudentResponse;
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
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class StudentServiceImpl implements StudentService {
    private final StudentRepository studentRepository;
    private final DepartmentRepository departmentRepository;

    @Override
    public StudentDto createStudent(StudentDto dto) {
        Department dept = departmentRepository.findById(dto.getDepartmentId())
                .orElseThrow(() -> new ResourceNotFoundException("Department", "id", dto.getDepartmentId()));
        Student student = new Student();
        student.setFirstName(dto.getFirstName());
        student.setLastName(dto.getLastName());
        student.setEmail(dto.getEmail());
        student.setEnrollmentDate(dto.getEnrollmentDate());
        student.setCurrentSemester(dto.getCurrentSemester());
        student.setDepartment(dept);
        Student saved = studentRepository.save(student);
        return mapToDto(saved);
    }

    @Override
    public StudentDto getStudentById(Long id) {
        Student student = studentRepository.findById(id).orElseThrow(() -> new ResourceNotFoundException("Student", "id", id));
        return mapToDto(student);
    }

    @Override
    public StudentResponse getAllStudents(int pageNo, int pageSize, String sortBy, String sortDir) {
        Sort sort = sortDir.equalsIgnoreCase(Sort.Direction.ASC.name()) ? Sort.by(sortBy).ascending()
                : Sort.by(sortBy).descending();
        Pageable pageable = PageRequest.of(pageNo, pageSize, sort);
        Page<Student> students = studentRepository.findAll(pageable);
        List<StudentDto> content = students.getContent().stream().map(this::mapToDto).collect(Collectors.toList());
        
        StudentResponse studentResponse = new StudentResponse();
        studentResponse.setContent(content);
        studentResponse.setPageNo(students.getNumber());
        studentResponse.setPageSize(students.getSize());
        studentResponse.setTotalElements(students.getTotalElements());
        studentResponse.setTotalPages(students.getTotalPages());
        studentResponse.setLast(students.isLast());
        return studentResponse;
    }

    @Override
    public StudentDto updateStudent(Long id, StudentDto dto) {
        Student student = studentRepository.findById(id).orElseThrow(() -> new ResourceNotFoundException("Student", "id", id));
        Department dept = departmentRepository.findById(dto.getDepartmentId())
                .orElseThrow(() -> new ResourceNotFoundException("Department", "id", dto.getDepartmentId()));
        student.setFirstName(dto.getFirstName());
        student.setLastName(dto.getLastName());
        student.setEmail(dto.getEmail());
        student.setEnrollmentDate(dto.getEnrollmentDate());
        student.setCurrentSemester(dto.getCurrentSemester());
        student.setDepartment(dept);
        Student updated = studentRepository.save(student);
        return mapToDto(updated);
    }

    @Override
    public void deleteStudent(Long id) {
        Student student = studentRepository.findById(id).orElseThrow(() -> new ResourceNotFoundException("Student", "id", id));
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
        dto.setDepartmentId(student.getDepartment().getId());
        return dto;
    }
}
