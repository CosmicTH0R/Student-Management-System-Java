import React, { useState } from 'react';
import { Bell, Search, Menu, LogOut, User } from 'lucide-react';
import { useAuth } from '../../context/AuthContext';
import { useNavigate } from 'react-router-dom';

const Topbar = () => {
  const { user, logout } = useAuth();
  const navigate = useNavigate();
  const [isDropdownOpen, setIsDropdownOpen] = useState(false);

  const handleLogout = () => {
    logout();
    navigate('/login');
  };

  const getInitials = (email: string) => {
    return email ? email.charAt(0).toUpperCase() : 'U';
  };

  return (
    <header className="h-16 bg-white/80 backdrop-blur-md border-b border-slate-200 flex items-center justify-between px-6 sticky top-0 z-20">
      <div className="flex items-center gap-4">
        <button className="md:hidden text-slate-500 hover:text-slate-700">
          <Menu className="w-6 h-6" />
        </button>
        <div className="hidden md:flex relative group">
          <Search className="w-4 h-4 text-slate-400 absolute left-3 top-1/2 -translate-y-1/2 group-focus-within:text-brand-500 transition-colors" />
          <input 
            type="text" 
            placeholder="Search anything..." 
            className="pl-10 pr-4 py-2 bg-slate-100/50 border border-transparent rounded-full text-sm focus:border-brand-500/30 focus:ring-4 focus:ring-brand-500/10 focus:bg-white transition-all w-64 outline-none placeholder:text-slate-400 text-slate-700"
          />
        </div>
      </div>
      
      <div className="flex items-center gap-4 relative">
        <button className="relative p-2 text-slate-400 hover:text-slate-600 transition-colors rounded-full hover:bg-slate-100">
          <Bell className="w-5 h-5" />
          <span className="absolute top-1.5 right-1.5 w-2 h-2 bg-red-500 rounded-full border-2 border-white"></span>
        </button>
        
        <div className="w-px h-6 bg-slate-200 hidden sm:block"></div>
        
        <div 
          className="flex items-center gap-3 cursor-pointer group"
          onClick={() => setIsDropdownOpen(!isDropdownOpen)}
        >
          <div className="text-right hidden sm:block">
            <p className="text-sm font-semibold text-slate-700 group-hover:text-brand-600 transition-colors">
              {user?.roles?.includes('ROLE_ADMIN') ? 'Administrator' : 'Student'}
            </p>
            <p className="text-xs text-slate-500">{user?.sub}</p>
          </div>
          <div className="w-9 h-9 rounded-full bg-gradient-to-tr from-brand-500 to-brand-400 flex items-center justify-center shadow-sm text-white font-medium ring-2 ring-white">
            {getInitials(user?.sub || 'User')}
          </div>
        </div>

        {/* Dropdown Menu */}
        {isDropdownOpen && (
          <div className="absolute top-full right-0 mt-2 w-48 rounded-xl bg-white shadow-lg ring-1 ring-black ring-opacity-5 focus:outline-none z-50 overflow-hidden animate-in fade-in slide-in-from-top-2 duration-200">
            <div className="py-1">
              <button className="flex w-full items-center gap-2 px-4 py-2 text-sm text-slate-700 hover:bg-slate-50 transition-colors">
                <User className="w-4 h-4 text-slate-400" />
                Profile
              </button>
              <div className="h-px bg-slate-100 my-1"></div>
              <button 
                onClick={handleLogout}
                className="flex w-full items-center gap-2 px-4 py-2 text-sm text-red-600 hover:bg-red-50 transition-colors"
              >
                <LogOut className="w-4 h-4 text-red-500" />
                Sign out
              </button>
            </div>
          </div>
        )}
      </div>
    </header>
  );
};

export default Topbar;
