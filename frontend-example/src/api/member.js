import axios from "axios";

const API_URL = "http://localhost:8080/api/members";

// 표준화된 API 응답 구조에 맞게 데이터 추출
const extractData = (response) => response.data.data;

export const getMembers = async () => {
  const response = await axios.get(API_URL);
  return {
    ...response,
    data: extractData(response) // ApiResponse.data 부분만 반환
  };
};

export const addMember = async (name) => {
  const response = await axios.post(API_URL, { name });
  return {
    ...response,
    data: extractData(response) // ApiResponse.data 부분만 반환
  };
};

export const deleteMember = async (id) => {
  const response = await axios.delete(`${API_URL}/${id}`);
  return {
    ...response,
    data: extractData(response) // ApiResponse.data 부분만 반환
  };
}; 