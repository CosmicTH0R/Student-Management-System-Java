import React from 'react';
import { Users, BookOpen, Building2 } from 'lucide-react';

const Dashboard = () => {
  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-2xl font-bold tracking-tight text-slate-900">Dashboard</h1>
        <p className="text-slate-500 mt-1 text-sm">Welcome back, here's what's happening today.</p>
      </div>
      
      <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
        {[
          { label: 'Total Students', value: '1,248', trend: '+12%', icon: Users, color: 'text-blue-600', bg: 'bg-blue-50' },
          { label: 'Active Courses', value: '42', trend: '+2%', icon: BookOpen, color: 'text-brand-600', bg: 'bg-brand-50' },
          { label: 'Departments', value: '8', trend: '0%', icon: Building2, color: 'text-purple-600', bg: 'bg-purple-50' },
        ].map((stat, i) => (
          <div key={i} className="glass-panel p-6 rounded-2xl relative overflow-hidden group hover:shadow-md transition-all hover:-translate-y-1 duration-300">
            <div className={bsolute top-6 right-6 w-12 h-12 rounded-xl  + stat.bg +  flex items-center justify-center transition-transform group-hover:scale-110 duration-300}>
                <stat.icon className={w-6 h-6  + stat.color} />
            </div>
            <p className="text-sm font-medium text-slate-500">{stat.label}</p>
            <div className="mt-4 flex items-baseline gap-2">
              <p className="text-3xl font-bold text-slate-900 tracking-tight">{stat.value}</p>
              <span className={	ext-xs font-semibold px-2 py-1 rounded-full  + (stat.trend.startsWith('+') ? 'bg-emerald-50 text-emerald-600' : 'bg-slate-100 text-slate-600')}>
                {stat.trend}
              </span>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
};

export default Dashboard;
