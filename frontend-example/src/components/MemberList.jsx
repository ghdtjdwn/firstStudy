import { useState } from "react";
import { deleteMember } from "../api/member";

export default function MemberList({ members, onDelete }) {
  const [deletingIds, setDeletingIds] = useState(new Set());

  const handleDelete = async (id) => {
    setDeletingIds(prev => new Set(prev).add(id));
    try {
      await deleteMember(id);
      onDelete(id); // 삭제된 ID 전달
    } catch (error) {
      console.error("회원 삭제 실패:", error);
      alert("회원 삭제에 실패했습니다.");
    } finally {
      setDeletingIds(prev => {
        const newSet = new Set(prev);
        newSet.delete(id);
        return newSet;
      });
    }
  };

  if (members.length === 0) {
    return (
      <div className="text-center text-gray-500 py-8">
        등록된 회원이 없습니다.
      </div>
    );
  }

  return (
    <ul className="space-y-2">
      {members.map((m) => (
        <li key={m.id} className="flex justify-between items-center border p-3 rounded shadow-sm">
          <span className="font-medium">{m.name}</span>
          <button
            onClick={() => handleDelete(m.id)}
            disabled={deletingIds.has(m.id)}
            className="bg-red-500 text-white px-3 py-1 rounded text-sm disabled:bg-gray-300 hover:bg-red-600 transition-colors"
          >
            {deletingIds.has(m.id) ? "삭제 중..." : "삭제"}
          </button>
        </li>
      ))}
    </ul>
  );
} 