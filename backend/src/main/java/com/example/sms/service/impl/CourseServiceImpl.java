package com.example.sms.service.impl;
import com.example.sms.dto.CourseDto;
import com.example.sms.entity.Department;
import com.example.sms.entity.Course;
import com.example.sms.exception.ResourceNotFoundException;
import com.example.sms.repository.DepartmentRepository;
import com.example.sms.repository.CourseRepository;
import com.example.sms.service.CourseService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class CourseServiceImpl implements CourseService {
    private final CourseRepository courseRepository;
    private final DepartmentRepository departmentRepository;

    @Override
    public CourseDto createCourse(CourseDto dto) {
        Department dept = departmentRepository.findById(dto.getDepartmentId())
                .orElseThrow(() -> new ResourceNotFoundException("Department", "id", dto.getDepartmentId()));
        Course course = new Course();
        course.setName(dto.getName());
        course.setCode(dto.getCode());
        course.setCredits(dto.getCredits());
        course.setDepartment(dept);
        Course saved = courseRepository.save(course);
        return mapToDto(saved);
    }

    @Override
    public CourseDto getCourseById(Long id) {
        Course course = courseRepository.findById(id).orElseThrow(() -> new ResourceNotFoundException("Course", "id", id));
        return mapToDto(course);
    }

    @Override
    public List<CourseDto> getAllCourses() {
        return courseRepository.findAll().stream().map(this::mapToDto).collect(Collectors.toList());
    }

    @Override
    public CourseDto updateCourse(Long id, CourseDto dto) {
        Course course = courseRepository.findById(id).orElseThrow(() -> new ResourceNotFoundException("Course", "id", id));
        Department dept = departmentRepository.findById(dto.getDepartmentId())
                .orElseThrow(() -> new ResourceNotFoundException("Department", "id", dto.getDepartmentId()));
        course.setName(dto.getName());
        course.setCode(dto.getCode());
        course.setCredits(dto.getCredits());
        course.setDepartment(dept);
        Course updated = courseRepository.save(course);
        return mapToDto(updated);
    }

    @Override
    public void deleteCourse(Long id) {
        Course course = courseRepository.findById(id).orElseThrow(() -> new ResourceNotFoundException("Course", "id", id));
        courseRepository.delete(course);
    }

    private CourseDto mapToDto(Course course) {
        CourseDto dto = new CourseDto();
        dto.setId(course.getId());
        dto.setName(course.getName());
        dto.setCode(course.getCode());
        dto.setCredits(course.getCredits());
        dto.setDepartmentId(course.getDepartment().getId());
        return dto;
    }
}
