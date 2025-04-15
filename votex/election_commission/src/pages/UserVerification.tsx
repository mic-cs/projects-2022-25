import React, { useEffect, useState } from 'react';
import { Check, X } from 'lucide-react';
import toast from 'react-hot-toast';
import { api } from '../api';
import type { User } from '../types';

export default function UserVerification() {
  const [users, setUsers] = useState<User[]>([]);

  useEffect(() => {
    loadUsers();
  }, []);

  const loadUsers = () => {
    api.getUnverifiedUsers()
      .then(setUsers)
      .catch(() => toast.error('Failed to load users'));
  };

  const handleVerify = async (userId: string) => {
    try {
      await api.verifyUser(userId);
      toast.success('User verified successfully');
      loadUsers();
    } catch (error) {
      toast.error('Failed to verify user');
    }
  };

  return (
    <div>
      <h1 className="text-2xl font-semibold text-gray-900">User Verification</h1>

      <div className="mt-6 bg-white shadow overflow-hidden sm:rounded-md">
        <ul role="list" className="divide-y divide-gray-200">
          {users.map((user) => (
            <li key={user.verification_id}>
              <div className="px-4 py-4 sm:px-6">
                <div className="flex items-center justify-between">
                  <div className="flex items-center">
                    <img
                      className="h-12 w-12 rounded-full"
                      src={user.photo}
                      alt={user.name}
                    />
                    <div className="ml-4">
                      <p className="text-sm font-medium text-gray-900">{user.name}</p>
                      <p className="text-sm text-gray-500">{user.email}</p>
                    </div>
                  </div>
                  <div className="flex space-x-2">
                    <button
                      onClick={() => handleVerify(user.verification_id)}
                      className="inline-flex items-center px-3 py-2 border border-transparent text-sm leading-4 font-medium rounded-md text-white bg-green-600 hover:bg-green-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-green-500"
                    >
                      <Check className="h-4 w-4 mr-2" />
                      Verify
                    </button>
                    <button
                      className="inline-flex items-center px-3 py-2 border border-transparent text-sm leading-4 font-medium rounded-md text-white bg-red-600 hover:bg-red-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-red-500"
                    >
                      <X className="h-4 w-4 mr-2" />
                      Reject
                    </button>
                  </div>
                </div>
              </div>
            </li>
          ))}
        </ul>
      </div>
    </div>
  );
}
