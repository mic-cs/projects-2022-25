import React, { useEffect, useState } from 'react';
import { useParams, Link } from 'react-router-dom';
import { Users, Calendar, CheckCircle, XCircle, BarChart3 } from 'lucide-react';
import { format } from 'date-fns';
import toast from 'react-hot-toast';
import type { Election, ElectionReport } from '../types';
import { mockElections, mockReport } from '../mockData';

export default function ElectionDetails() {
  const { id } = useParams<{ id: string }>();
  const [election, setElection] = useState<Election | null>(null);
  const [report, setReport] = useState<ElectionReport | null>(null);

  useEffect(() => {
    if (!id) return;

    // Use mock data instead of API call
    const mockElection = mockElections.find(e => e.id === id);
    if (mockElection) {
      setElection(mockElection);
      if (mockElection.status === 'completed') {
        setReport(mockReport);
      }
    }
  }, [id]);

  const handleStartElection = async () => {
    if (!id || !election) return;
    
    // Simulate API call with mock data
    const updatedElection = { ...election, status: 'active' as const };
    setElection(updatedElection);
    toast.success('Election started successfully');
  };

  const handleStopElection = async () => {
    if (!id || !election) return;
    
    // Simulate API call with mock data
    const updatedElection = { ...election, status: 'completed' as const };
    setElection(updatedElection);
    setReport(mockReport);
    toast.success('Election stopped successfully');
  };

  if (!election) {
    return <div>Loading...</div>;
  }

  return (
    <div>
      <div className="bg-white shadow overflow-hidden sm:rounded-lg">
        <div className="px-4 py-5 sm:px-6">
          <h3 className="text-lg leading-6 font-medium text-gray-900">
            {election.title}
          </h3>
          <p className="mt-1 max-w-2xl text-sm text-gray-500">
            {election.description}
          </p>
        </div>
        <div className="border-t border-gray-200 px-4 py-5 sm:px-6">
          <dl className="grid grid-cols-1 gap-x-4 gap-y-8 sm:grid-cols-2">
            <div className="sm:col-span-1">
              <dt className="text-sm font-medium text-gray-500">Status</dt>
              <dd className="mt-1 text-sm text-gray-900">
                <span className={`px-2 inline-flex text-xs leading-5 font-semibold rounded-full
                  ${election.status === 'active' ? 'bg-green-100 text-green-800' : 
                    election.status === 'completed' ? 'bg-gray-100 text-gray-800' : 
                    'bg-yellow-100 text-yellow-800'}`}>
                  {election.status.charAt(0).toUpperCase() + election.status.slice(1)}
                </span>
              </dd>
            </div>
            <div className="sm:col-span-1">
              <dt className="text-sm font-medium text-gray-500">Start Date</dt>
              <dd className="mt-1 text-sm text-gray-900">
                {format(new Date(election.startDate), 'PPP')}
              </dd>
            </div>
            <div className="sm:col-span-2">
              <dt className="text-sm font-medium text-gray-500">Candidates</dt>
              <dd className="mt-1 text-sm text-gray-900">
                <ul role="list" className="border border-gray-200 rounded-md divide-y divide-gray-200">
                  {election.candidates.map((candidate) => (
                    <li key={candidate.id} className="pl-3 pr-4 py-3 flex items-center justify-between text-sm">
                      <div className="flex items-center">
                        <img
                          className="h-8 w-8 rounded-full"
                          src={candidate.photoUrl}
                          alt={candidate.name}
                        />
                        <span className="ml-2 truncate">{candidate.name}</span>
                      </div>
                      <span className="text-gray-500">{candidate.party}</span>
                    </li>
                  ))}
                </ul>
              </dd>
            </div>
          </dl>
        </div>
        <div className="bg-gray-50 px-4 py-5 sm:px-6">
          <div className="flex space-x-3">
            {election.status === 'draft' && (
              <button
                onClick={handleStartElection}
                className="inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md shadow-sm text-white bg-green-600 hover:bg-green-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-green-500"
              >
                <CheckCircle className="h-5 w-5 mr-2" />
                Start Election
              </button>
            )}
            {election.status === 'active' && (
              <button
                onClick={handleStopElection}
                className="inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md shadow-sm text-white bg-red-600 hover:bg-red-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-red-500"
              >
                <XCircle className="h-5 w-5 mr-2" />
                Stop Election
              </button>
            )}
            {election.status === 'completed' && (
              <Link
                to={`/elections/${election.id}/report`}
                className="inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md shadow-sm text-white bg-blue-600 hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500"
              >
                <BarChart3 className="h-5 w-5 mr-2" />
                View Full Report
              </Link>
            )}
          </div>
        </div>
      </div>

      {report && (
        <div className="mt-8 bg-white shadow overflow-hidden sm:rounded-lg">
          <div className="px-4 py-5 sm:px-6">
            <h3 className="text-lg leading-6 font-medium text-gray-900">
              Election Report Summary
            </h3>
            <p className="mt-1 max-w-2xl text-sm text-gray-500">
              Quick overview of the results
            </p>
          </div>
          <div className="border-t border-gray-200">
            <dl>
              <div className="bg-gray-50 px-4 py-5 sm:grid sm:grid-cols-3 sm:gap-4 sm:px-6">
                <dt className="text-sm font-medium text-gray-500">Total Votes</dt>
                <dd className="mt-1 text-sm text-gray-900 sm:mt-0 sm:col-span-2">
                  {report.totalVotes}
                </dd>
              </div>
              {report.results.map((result, index) => (
                <div key={result.candidateId} className={`${
                  index % 2 === 0 ? 'bg-white' : 'bg-gray-50'
                } px-4 py-5 sm:grid sm:grid-cols-3 sm:gap-4 sm:px-6`}>
                  <dt className="text-sm font-medium text-gray-500">{result.candidateName}</dt>
                  <dd className="mt-1 text-sm text-gray-900 sm:mt-0 sm:col-span-2">
                    {result.votes} votes ({result.percentage.toFixed(2)}%)
                  </dd>
                </div>
              ))}
            </dl>
          </div>
        </div>
      )}
    </div>
  );
}