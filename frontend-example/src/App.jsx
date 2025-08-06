import { useEffect, useState } from "react";
import MemberForm from "./components/MemberForm";
import MemberList from "./components/MemberList";
import { getMembers } from "./api/member";

export default function App() {
  const [members, setMembers] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  const loadMembers = async () => {
    try {
      setLoading(true);
      setError(null);
      const res = await getMembers();
      setMembers(res.data);
    } catch (error) {
      console.error("회원 목록 로드 실패:", error);
      setError("회원 목록을 불러오는데 실패했습니다.");
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    loadMembers();
  }, []);

  const handleAdd = (newMember) => {
    setMembers((prev) => [...prev, newMember]);
  };

  const handleDelete = (id) => {
    setMembers((prev) => prev.filter((m) => m.id !== id));
  };

  if (loading) {
    return (
      <div className="max-w-md mx-auto p-4">
        <div className="text-center py-8">
          <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-blue-500 mx-auto"></div>
          <p className="mt-2 text-gray-600">회원 목록을 불러오는 중...</p>
        </div>
      </div>
    );
  }

  return (
    <div className="max-w-md mx-auto p-4">
      <h1 className="text-2xl font-bold mb-4 text-center">회원 관리</h1>
      
      {error && (
        <div className="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded mb-4">
          {error}
          <button 
            onClick={loadMembers}
            className="ml-2 underline hover:no-underline"
          >
            다시 시도
          </button>
        </div>
      )}

      <MemberForm onAdd={handleAdd} />
      <MemberList members={members} onDelete={handleDelete} />
      
      <div className="mt-4 text-center text-sm text-gray-500">
        총 {members.length}명의 회원이 등록되어 있습니다.
      </div>
    </div>
  );
} 