import React, { useEffect, useState } from 'react';
import { Users, Vote, BarChart3 } from 'lucide-react';
import { api } from '../api';
import type { Election, User } from '../types';

export default function Dashboard() {
  const [stats, setStats] = useState({
    totalUsers: 0,
    pendingVerifications: 0,
    activeElections: 0,
    completedElections: 0
  });

  useEffect(() => {
    // Fetch dashboard stats
    Promise.all([
      api.getUnverifiedUsers(),
      api.getElections()
    ]).then(([users, elections]) => {
      setStats({
        totalUsers: users.length,
        pendingVerifications: users.filter((u: User) => !u.verified).length,
        activeElections: elections.filter((e: Election) => e.status === 'active').length,
        completedElections: elections.filter((e: Election) => e.status === 'completed').length
      });
    });
  }, []);

  return (
    <div>
      <h1 className="text-2xl font-semibold text-gray-900">Dashboard</h1>

      <div className="mt-6 grid grid-cols-1 gap-5 sm:grid-cols-2 lg:grid-cols-3">
        <div className="bg-white overflow-hidden shadow rounded-lg">
          <div className="p-5">
            <div className="flex items-center">
              <div className="flex-shrink-0">
                <Users className="h-6 w-6 text-gray-400" />
              </div>
              <div className="ml-5 w-0 flex-1">
                <dl>
                  <dt className="text-sm font-medium text-gray-500 truncate">
                    Pending Verifications
                  </dt>
                  <dd className="text-lg font-semibold text-gray-900">
                    {stats.pendingVerifications}
                  </dd>
                </dl>
              </div>
            </div>
          </div>
        </div>

        <div className="bg-white overflow-hidden shadow rounded-lg">
          <div className="p-5">
            <div className="flex items-center">
              <div className="flex-shrink-0">
                <Vote className="h-6 w-6 text-gray-400" />
              </div>
              <div className="ml-5 w-0 flex-1">
                <dl>
                  <dt className="text-sm font-medium text-gray-500 truncate">
                    Active Elections
                  </dt>
                  <dd className="text-lg font-semibold text-gray-900">
                    {stats.activeElections}
                  </dd>
                </dl>
              </div>
            </div>
          </div>
        </div>

        <div className="bg-white overflow-hidden shadow rounded-lg">
          <div className="p-5">
            <div className="flex items-center">
              <div className="flex-shrink-0">
                <BarChart3 className="h-6 w-6 text-gray-400" />
              </div>
              <div className="ml-5 w-0 flex-1">
                <dl>
                  <dt className="text-sm font-medium text-gray-500 truncate">
                    Completed Elections
                  </dt>
                  <dd className="text-lg font-semibold text-gray-900">
                    {stats.completedElections}
                  </dd>
                </dl>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
