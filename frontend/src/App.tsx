import React from 'react';
import { BrowserRouter, Routes, Route } from 'react-router-dom';
import MainLayout from './components/layout/MainLayout';
import Dashboard from './pages/Dashboard';

function App() {
  return (
    <BrowserRouter>
      <Routes>
        <Route path="/" element={<MainLayout />}>
          <Route index element={<Dashboard />} />
          <Route path="students" element={<div className="p-4 text-slate-500">Students Page (WIP)</div>} />
          <Route path="courses" element={<div className="p-4 text-slate-500">Courses Page (WIP)</div>} />
          <Route path="departments" element={<div className="p-4 text-slate-500">Departments Page (WIP)</div>} />
        </Route>
      </Routes>
    </BrowserRouter>
  );
}

export default App;
