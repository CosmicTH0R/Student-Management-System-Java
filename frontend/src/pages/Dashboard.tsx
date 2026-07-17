import React, { useState, useEffect } from 'react';
import { Users, BookOpen, Building2, TrendingUp, Loader2 } from 'lucide-react';
import { getStudents } from '../api/studentService';
import { getCourses } from '../api/courseService';
import { getDepartments } from '../api/departmentService';
import toast from 'react-hot-toast';

const Dashboard = () => {
  const [stats, setStats] = useState({
    students: 0,
    courses: 0,
    departments: 0
  });
  const [recentStudents, setRecentStudents] = useState<any[]>([]);
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    const fetchDashboardData = async () => {
      try {
        // Fetch in parallel for better performance
        const [studentsData, coursesData, deptsData] = await Promise.all([
          getStudents(0, 5, '', 'id', 'desc'), // get recent 5
          getCourses(),
          getDepartments()
        ]);

        setStats({
          students: studentsData.totalElements,
          courses: coursesData.length,
          departments: deptsData.length
        });
        
        setRecentStudents(studentsData.content);
      } catch (error) {
        console.error('Failed to fetch dashboard data', error);
        toast.error('Could not load dashboard data');
      } finally {
        setIsLoading(false);
      }
    };

    fetchDashboardData();
  }, []);

  if (isLoading) {
    return (
      <div className="flex justify-center items-center h-full min-h-[400px]">
        <Loader2 className="w-8 h-8 text-brand-500 animate-spin" />
      </div>
    );
  }

  return (
    <div className="space-y-8 animate-in fade-in duration-500">
      <div>
        <h1 className="text-2xl font-bold tracking-tight text-slate-900">Dashboard</h1>
        <p className="text-slate-500 mt-1 text-sm">Real-time overview of your institution.</p>
      </div>
      
      {/* Stats Grid */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
        {[
          { label: 'Total Students', value: stats.students, trend: '+12%', icon: Users, color: 'text-blue-600', bg: 'bg-blue-50' },
          { label: 'Active Courses', value: stats.courses, trend: '+4%', icon: BookOpen, color: 'text-brand-600', bg: 'bg-brand-50' },
          { label: 'Departments', value: stats.departments, trend: '0%', icon: Building2, color: 'text-purple-600', bg: 'bg-purple-50' },
        ].map((stat, i) => (
          <div key={i} className="glass-panel p-6 rounded-2xl relative overflow-hidden group hover:shadow-md transition-all hover:-translate-y-1 duration-300">
            <div className={`absolute top-6 right-6 w-12 h-12 rounded-xl ${stat.bg} flex items-center justify-center transition-transform group-hover:scale-110 duration-300`}>
                <stat.icon className={`w-6 h-6 ${stat.color}`} />
            </div>
            <p className="text-sm font-medium text-slate-500">{stat.label}</p>
            <div className="mt-4 flex items-baseline gap-2">
              <p className="text-3xl font-bold text-slate-900 tracking-tight">{stat.value}</p>
              <span className={`text-xs font-semibold px-2 py-1 rounded-full ${stat.trend.startsWith('+') ? 'bg-emerald-50 text-emerald-600' : 'bg-slate-100 text-slate-600'}`}>
                <TrendingUp className="w-3 h-3 inline mr-1" />
                {stat.trend}
              </span>
            </div>
          </div>
        ))}
      </div>

      {/* Recent Students Table */}
      <div className="glass-panel rounded-2xl overflow-hidden shadow-sm">
        <div className="px-6 py-5 border-b border-slate-100 flex justify-between items-center bg-white/50">
            <h3 className="text-base font-semibold text-slate-800">Recently Enrolled Students</h3>
            <button className="text-sm font-medium text-brand-600 hover:text-brand-700 transition-colors">View All</button>
        </div>
        <div className="overflow-x-auto">
          <table className="w-full text-sm text-left">
            <thead className="bg-slate-50/50 text-slate-500 font-medium">
              <tr>
                <th className="px-6 py-4">Name</th>
                <th className="px-6 py-4">Email</th>
                <th className="px-6 py-4">Semester</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-slate-100 bg-white/30">
              {recentStudents.length === 0 ? (
                <tr>
                    <td colSpan={3} className="px-6 py-8 text-center text-slate-500">No students found.</td>
                </tr>
              ) : (
                recentStudents.map((student) => (
                  <tr key={student.id} className="hover:bg-slate-50/80 transition-colors">
                    <td className="px-6 py-4 font-medium text-slate-800">{student.firstName} {student.lastName}</td>
                    <td className="px-6 py-4 text-slate-600">{student.email}</td>
                    <td className="px-6 py-4">
                        <span className="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-indigo-50 text-indigo-700 border border-indigo-100">
                            Sem {student.currentSemester}
                        </span>
                    </td>
                  </tr>
                ))
              )}
            </tbody>
          </table>
        </div>
      </div>
    </div>
  );
};

export default Dashboard;
