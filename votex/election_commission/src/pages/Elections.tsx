import React, { useEffect, useState } from 'react';
import { Link } from 'react-router-dom';
import { PlusCircle, Calendar, Users } from 'lucide-react';
import { format } from 'date-fns';
import type { Election } from '../types';
import { mockElections } from '../mockData';

export default function Elections() {
  const [elections, setElections] = useState<Election[]>([]);

  useEffect(() => {
    // Use mock data instead of API call
    setElections(mockElections);
  }, []);

  return (
    <div>
      <div className="flex justify-between items-center">
        <h1 className="text-2xl font-semibold text-gray-900">Elections</h1>
        <Link
          to="/elections/new"
          className="inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md shadow-sm text-white bg-blue-600 hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500"
        >
          <PlusCircle className="h-5 w-5 mr-2" />
          Create Election
        </Link>
      </div>

      <div className="mt-6 bg-white shadow overflow-hidden sm:rounded-md">
        <ul role="list" className="divide-y divide-gray-200">
          {elections.map((election) => (
            <li key={election.id}>
              <Link to={`/elections/${election.id}`} className="block hover:bg-gray-50">
                <div className="px-4 py-4 sm:px-6">
                  <div className="flex items-center justify-between">
                    <div>
                      <p className="text-sm font-medium text-blue-600 truncate">
                        {election.title}
                      </p>
                      <p className="mt-1 text-sm text-gray-500">
                        {election.description}
                      </p>
                    </div>
                    <div className="ml-2 flex-shrink-0 flex">
                      <p className={`px-2 inline-flex text-xs leading-5 font-semibold rounded-full
                        ${election.status === 'active' ? 'bg-green-100 text-green-800' : 
                          election.status === 'completed' ? 'bg-gray-100 text-gray-800' : 
                          'bg-yellow-100 text-yellow-800'}`}>
                        {election.status.charAt(0).toUpperCase() + election.status.slice(1)}
                      </p>
                    </div>
                  </div>
                  <div className="mt-2 sm:flex sm:justify-between">
                    <div className="sm:flex">
                      <p className="flex items-center text-sm text-gray-500">
                        <Users className="flex-shrink-0 mr-1.5 h-5 w-5 text-gray-400" />
                        {election.voters.length} voters
                      </p>
                    </div>
                    <div className="mt-2 flex items-center text-sm text-gray-500 sm:mt-0">
                      <Calendar className="flex-shrink-0 mr-1.5 h-5 w-5 text-gray-400" />
                      <p>
                        Starts <time dateTime={election.startDate}>{format(new Date(election.startDate), 'PPP')}</time>
                      </p>
                    </div>
                  </div>
                </div>
              </Link>
            </li>
          ))}
        </ul>
      </div>
    </div>
  );
}