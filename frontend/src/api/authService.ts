import api from './axios';

export const loginApi = async (credentials: { email: string; password: string }) => {
  const response = await api.post('/auth/login', credentials);
  return response.data; // Expected { token: "eyJhbG..." }
};
