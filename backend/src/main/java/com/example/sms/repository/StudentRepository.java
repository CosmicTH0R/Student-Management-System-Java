package com.example.sms.repository;

import com.example.sms.entity.Student;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface StudentRepository extends JpaRepository<Student, Long> {
    List<Student> findByDepartmentId(Long departmentId);
    List<Student> findByCurrentSemester(Integer semester);
    Boolean existsByEmail(String email);
}
