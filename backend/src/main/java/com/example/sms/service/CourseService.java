package com.example.sms.service;

import com.example.sms.dto.CourseDto;
import java.util.List;

public interface CourseService {
    CourseDto createCourse(CourseDto dto);
    CourseDto getCourseById(Long id);
    List<CourseDto> getAllCourses();
    List<CourseDto> getCoursesByDepartment(Long departmentId);
    CourseDto updateCourse(Long id, CourseDto dto);
    void deleteCourse(Long id);
}
