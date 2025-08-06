import { useState } from "react";
import { addMember } from "../api/member";

export default function MemberForm({ onAdd }) {
  const [name, setName] = useState("");
  const [loading, setLoading] = useState(false);

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (!name.trim()) return;

    setLoading(true);
    try {
      const res = await addMember(name);
      onAdd(res.data);  // 추가된 멤버를 상위로 전달
      setName("");
    } catch (error) {
      console.error("회원 추가 실패:", error);
      alert("회원 추가에 실패했습니다.");
    } finally {
      setLoading(false);
    }
  };

  return (
    <form onSubmit={handleSubmit} className="flex gap-2 my-4">
      <input
        type="text"
        placeholder="이름 입력"
        value={name}
        onChange={(e) => setName(e.target.value)}
        className="border p-2 rounded w-full"
        disabled={loading}
      />
      <button 
        type="submit"
        disabled={loading || !name.trim()}
        className="bg-blue-500 text-white px-4 rounded disabled:bg-gray-300"
      >
        {loading ? "추가 중..." : "추가"}
      </button>
    </form>
  );
} 