import api from './axios';

export const getStudents = async (pageNo = 0, pageSize = 10, search = '', sortBy = 'id', sortDir = 'desc') => {
  const response = await api.get('/students', {
    params: { pageNo, pageSize, search, sortBy, sortDir }
  });
  return response.data; // Returns PagedResponse<StudentDto>
};
