import api from './axios';

export const getStudents = async (pageNo = 0, pageSize = 10, search = '', sortBy = 'id', sortDir = 'desc') => {
  const response = await api.get('/students', {
    params: { pageNo, pageSize, search, sortBy, sortDir }
  });
  return response.data;
};

export const createStudent = async (data: any) => {
  const response = await api.post('/students', data);
  return response.data;
};

export const updateStudent = async (id: number, data: any) => {
  const response = await api.put(`/students/${id}`, data);
  return response.data;
};

export const deleteStudent = async (id: number) => {
  const response = await api.delete(`/students/${id}`);
  return response.data;
};
