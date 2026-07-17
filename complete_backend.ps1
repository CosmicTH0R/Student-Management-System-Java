$basePath = "c:\Student Management System\backend\src\main\java\com\example\sms"

# ================= PHASE 12: STUDENT CRUD =================
$sService = @"
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
"@
Set-Content -Path "$basePath\service\StudentService.java" -Value $sService

$sServiceImpl = @"
package com.example.sms.service.impl;
import com.example.sms.dto.StudentDto;
import com.example.sms.entity.Department;
import com.example.sms.entity.Student;
import com.example.sms.exception.ResourceNotFoundException;
import com.example.sms.repository.DepartmentRepository;
import com.example.sms.repository.StudentRepository;
import com.example.sms.service.StudentService;
import lombok.RequiredArgsConstructor;
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
    public List<StudentDto> getAllStudents() {
        return studentRepository.findAll().stream().map(this::mapToDto).collect(Collectors.toList());
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
"@
Set-Content -Path "$basePath\service\impl\StudentServiceImpl.java" -Value $sServiceImpl

$sCtrl = @"
package com.example.sms.controller;
import com.example.sms.dto.StudentDto;
import com.example.sms.service.StudentService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/students")
@RequiredArgsConstructor
public class StudentController {
    private final StudentService studentService;

    @PostMapping
    public ResponseEntity<StudentDto> createStudent(@Valid @RequestBody StudentDto dto) {
        return new ResponseEntity<>(studentService.createStudent(dto), HttpStatus.CREATED);
    }
    @GetMapping("/{id}")
    public ResponseEntity<StudentDto> getStudentById(@PathVariable Long id) {
        return ResponseEntity.ok(studentService.getStudentById(id));
    }
    @GetMapping
    public ResponseEntity<List<StudentDto>> getAllStudents() {
        return ResponseEntity.ok(studentService.getAllStudents());
    }
    @PutMapping("/{id}")
    public ResponseEntity<StudentDto> updateStudent(@PathVariable Long id, @Valid @RequestBody StudentDto dto) {
        return ResponseEntity.ok(studentService.updateStudent(id, dto));
    }
    @DeleteMapping("/{id}")
    public ResponseEntity<String> deleteStudent(@PathVariable Long id) {
        studentService.deleteStudent(id);
        return ResponseEntity.ok("Student deleted successfully.");
    }
}
"@
Set-Content -Path "$basePath\controller\StudentController.java" -Value $sCtrl

$iq12 = @"

## Phase 12: Student CRUD

**Q: In our `StudentServiceImpl`, why do we need to fetch the `Department` from the database before saving a new `Student`?**
*Answer:* In JPA, relationships are managed by object references. A `Student` doesn't just hold a `department_id` integer; it holds an entire `Department` object. We must fetch the existing `Department` entity using the provided ID and set it onto the new `Student` object so Hibernate can establish the foreign key correctly in the database.
"@
Add-Content -Path "c:\Student Management System\docs\interview_questions.md" -Value $iq12

cd "c:\Student Management System"
git add .
git commit -m "feat: complete Phase 12 - Student CRUD"
git push origin main

# ================= PHASE 13: COURSE CRUD =================
$cService = @"
package com.example.sms.service;
import com.example.sms.dto.CourseDto;
import java.util.List;
public interface CourseService {
    CourseDto createCourse(CourseDto dto);
    CourseDto getCourseById(Long id);
    List<CourseDto> getAllCourses();
    CourseDto updateCourse(Long id, CourseDto dto);
    void deleteCourse(Long id);
}
"@
Set-Content -Path "$basePath\service\CourseService.java" -Value $cService

$cServiceImpl = @"
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
"@
Set-Content -Path "$basePath\service\impl\CourseServiceImpl.java" -Value $cServiceImpl

$cCtrl = @"
package com.example.sms.controller;
import com.example.sms.dto.CourseDto;
import com.example.sms.service.CourseService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/courses")
@RequiredArgsConstructor
public class CourseController {
    private final CourseService courseService;

    @PostMapping
    public ResponseEntity<CourseDto> createCourse(@Valid @RequestBody CourseDto dto) {
        return new ResponseEntity<>(courseService.createCourse(dto), HttpStatus.CREATED);
    }
    @GetMapping("/{id}")
    public ResponseEntity<CourseDto> getCourseById(@PathVariable Long id) {
        return ResponseEntity.ok(courseService.getCourseById(id));
    }
    @GetMapping
    public ResponseEntity<List<CourseDto>> getAllCourses() {
        return ResponseEntity.ok(courseService.getAllCourses());
    }
    @PutMapping("/{id}")
    public ResponseEntity<CourseDto> updateCourse(@PathVariable Long id, @Valid @RequestBody CourseDto dto) {
        return ResponseEntity.ok(courseService.updateCourse(id, dto));
    }
    @DeleteMapping("/{id}")
    public ResponseEntity<String> deleteCourse(@PathVariable Long id) {
        courseService.deleteCourse(id);
        return ResponseEntity.ok("Course deleted successfully.");
    }
}
"@
Set-Content -Path "$basePath\controller\CourseController.java" -Value $cCtrl

$iq13 = @"

## Phase 13: Course CRUD

**Q: Are Controllers tightly coupled to Repositories?**
*Answer:* No, they are strictly separated by the Service layer. If we ever switch our database technology (e.g., from MySQL to MongoDB), the Controller remains completely unchanged because it only talks to the Service Interface.
"@
Add-Content -Path "c:\Student Management System\docs\interview_questions.md" -Value $iq13

cd "c:\Student Management System"
git add .
git commit -m "feat: complete Phase 13 - Course CRUD"
git push origin main

# ================= PHASE 14: ROLE-BASED ACCESS CONTROL =================
Function Add-Rbac {
    param([string]$path)
    $content = Get-Content -Path $path -Raw
    $content = $content -replace "import org.springframework.web.bind.annotation.\*;", "import org.springframework.web.bind.annotation.*;`nimport org.springframework.security.access.prepost.PreAuthorize;"
    $content = $content -replace "@PostMapping", "@PreAuthorize(`"hasRole('ADMIN')`")`n    @PostMapping"
    $content = $content -replace "@PutMapping", "@PreAuthorize(`"hasRole('ADMIN')`")`n    @PutMapping"
    $content = $content -replace "@DeleteMapping", "@PreAuthorize(`"hasRole('ADMIN')`")`n    @DeleteMapping"
    Set-Content -Path $path -Value $content
}

Add-Rbac "$basePath\controller\DepartmentController.java"
Add-Rbac "$basePath\controller\StudentController.java"
Add-Rbac "$basePath\controller\CourseController.java"

$iq14 = @"

## Phase 14: Role-Based Access Control

**Q: How do we restrict access to specific endpoints based on user roles?**
*Answer:* By enabling Method Security (`@EnableMethodSecurity` in our SecurityConfig), we can place `@PreAuthorize("hasRole('ADMIN')")` directly above our Controller methods. If a user logs in as a `STUDENT` and attempts to hit a DELETE endpoint, Spring Security will intercept the request and return an HTTP 403 Forbidden status.
"@
Add-Content -Path "c:\Student Management System\docs\interview_questions.md" -Value $iq14

cd "c:\Student Management System"
git add .
git commit -m "feat: complete Phase 14 - Role Based Access Control (RBAC)"
git push origin main

# ================= PHASE 15: PAGINATION AND SORTING =================
$sResp = @"
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
"@
Set-Content -Path "$basePath\dto\StudentResponse.java" -Value $sResp

$ssContent = Get-Content "$basePath\service\StudentService.java" -Raw
$ssContent = $ssContent -replace "List<StudentDto> getAllStudents\(\);", "import com.example.sms.dto.StudentResponse;`n    StudentResponse getAllStudents(int pageNo, int pageSize, String sortBy, String sortDir);"
Set-Content -Path "$basePath\service\StudentService.java" -Value $ssContent

$ssiContent = @"
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
"@
Set-Content -Path "$basePath\service\impl\StudentServiceImpl.java" -Value $ssiContent

$scContent = @"
package com.example.sms.controller;
import com.example.sms.dto.StudentDto;
import com.example.sms.dto.StudentResponse;
import com.example.sms.service.StudentService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/students")
@RequiredArgsConstructor
public class StudentController {
    private final StudentService studentService;

    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping
    public ResponseEntity<StudentDto> createStudent(@Valid @RequestBody StudentDto dto) {
        return new ResponseEntity<>(studentService.createStudent(dto), HttpStatus.CREATED);
    }

    @GetMapping("/{id}")
    public ResponseEntity<StudentDto> getStudentById(@PathVariable Long id) {
        return ResponseEntity.ok(studentService.getStudentById(id));
    }

    @GetMapping
    public ResponseEntity<StudentResponse> getAllStudents(
            @RequestParam(value = "pageNo", defaultValue = "0", required = false) int pageNo,
            @RequestParam(value = "pageSize", defaultValue = "10", required = false) int pageSize,
            @RequestParam(value = "sortBy", defaultValue = "id", required = false) String sortBy,
            @RequestParam(value = "sortDir", defaultValue = "asc", required = false) String sortDir
    ) {
        return ResponseEntity.ok(studentService.getAllStudents(pageNo, pageSize, sortBy, sortDir));
    }

    @PreAuthorize("hasRole('ADMIN')")
    @PutMapping("/{id}")
    public ResponseEntity<StudentDto> updateStudent(@PathVariable Long id, @Valid @RequestBody StudentDto dto) {
        return ResponseEntity.ok(studentService.updateStudent(id, dto));
    }

    @PreAuthorize("hasRole('ADMIN')")
    @DeleteMapping("/{id}")
    public ResponseEntity<String> deleteStudent(@PathVariable Long id) {
        studentService.deleteStudent(id);
        return ResponseEntity.ok("Student deleted successfully.");
    }
}
"@
Set-Content -Path "$basePath\controller\StudentController.java" -Value $scContent

$iq15 = @"

## Phase 15: Pagination and Sorting

**Q: Why do we implement Pagination on the backend?**
*Answer:* If we have 100,000 students in the database and the frontend calls `GET /students`, the backend will crash from out-of-memory errors trying to serialize 100,000 objects into JSON, and the frontend will crash trying to render them. Pagination handles data in chunks (e.g., 10 per page), significantly improving performance, memory usage, and load times.

**Q: How does Spring Data JPA make Pagination easy?**
*Answer:* Because our repository extends `JpaRepository`, we get pagination for free. We construct a `PageRequest` object with the `pageNo`, `pageSize`, and `Sort` parameters, and pass it into `studentRepository.findAll(pageable)`. Spring automatically converts this into the equivalent SQL `LIMIT` and `OFFSET` queries.
"@
Add-Content -Path "c:\Student Management System\docs\interview_questions.md" -Value $iq15

cd "c:\Student Management System"
git add .
git commit -m "feat: complete Phase 15 - Pagination and Sorting"
git push origin main

# ================= PHASE 16: CORS CONFIGURATION =================
$cors = @"
package com.example.sms.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class CorsConfig implements WebMvcConfigurer {
    @Override
    public void addCorsMappings(CorsRegistry registry) {
        registry.addMapping("/**")
                .allowedOrigins("http://localhost:5173") // Vite default port
                .allowedMethods("GET", "POST", "PUT", "DELETE", "OPTIONS")
                .allowedHeaders("*")
                .allowCredentials(true);
    }
}
"@
New-Item -ItemType Directory -Force -Path "$basePath\config" | Out-Null
Set-Content -Path "$basePath\config\CorsConfig.java" -Value $cors

$iq16 = @"

## Phase 16: CORS Configuration

**Q: What is CORS (Cross-Origin Resource Sharing) and why did we configure it?**
*Answer:* By default, modern browsers block HTTP requests made from one domain (e.g., `http://localhost:5173` where React runs) to another domain (e.g., `http://localhost:8080` where Spring Boot runs) for security reasons. Configuring CORS in our backend explicitly tells the browser: "It is safe to accept requests from our React app."
"@
Add-Content -Path "c:\Student Management System\docs\interview_questions.md" -Value $iq16

cd "c:\Student Management System"
git add .
git commit -m "feat: complete Phase 16 - CORS Configuration for React Frontend"
git push origin main
