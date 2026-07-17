import React from 'react';
import { NavLink } from 'react-router-dom';
import { LayoutDashboard, Users, BookOpen, Building2, Settings } from 'lucide-react';
import clsx from 'clsx';
import { twMerge } from 'tailwind-merge';

const Sidebar = () => {
  const navItems = [
    { name: 'Dashboard', path: '/', icon: LayoutDashboard },
    { name: 'Students', path: '/students', icon: Users },
    { name: 'Courses', path: '/courses', icon: BookOpen },
    { name: 'Departments', path: '/departments', icon: Building2 },
  ];

  return (
    <aside className="w-64 hidden md:flex flex-col border-r border-slate-200 bg-white shadow-sm z-10">
      <div className="h-16 flex items-center px-6 border-b border-slate-100">
        <div className="flex items-center gap-2">
          <div className="w-8 h-8 rounded-lg bg-brand-500 flex items-center justify-center shadow-sm">
            <span className="text-white font-bold text-lg">S</span>
          </div>
          <span className="font-semibold text-xl tracking-tight text-slate-800">SMS Portal</span>
        </div>
      </div>
      
      <div className="flex-1 overflow-y-auto py-6 px-4 flex flex-col gap-1">
        <div className="text-xs font-semibold text-slate-400 uppercase tracking-wider mb-2 px-3">Menu</div>
        {navItems.map((item) => (
          <NavLink
            key={item.name}
            to={item.path}
            className={({ isActive }) => twMerge(
              clsx(
                "flex items-center gap-3 px-3 py-2.5 rounded-lg text-sm font-medium transition-all duration-200 group",
                isActive 
                  ? "bg-brand-50 text-brand-600" 
                  : "text-slate-500 hover:bg-slate-50 hover:text-slate-900"
              )
            )}
          >
            <item.icon className={clsx("w-5 h-5 transition-colors", "group-hover:text-brand-500")} />
            {item.name}
          </NavLink>
        ))}
      </div>

      <div className="p-4 border-t border-slate-100">
        <button className="flex items-center gap-3 px-3 py-2.5 rounded-lg text-sm font-medium text-slate-500 hover:bg-slate-50 hover:text-slate-900 transition-all w-full group">
          <Settings className="w-5 h-5 group-hover:text-slate-700" />
          Settings
        </button>
      </div>
    </aside>
  );
};

export default Sidebar;
