import React from 'react';
import { useParams } from 'react-router-dom';
import { Mail, Download, Share2 } from 'lucide-react';
import { format } from 'date-fns';
import toast from 'react-hot-toast';
import {
  Chart as ChartJS,
  ArcElement,
  CategoryScale,
  LinearScale,
  BarElement,
  Title,
  Tooltip,
  Legend
} from 'chart.js';
import { Pie, Bar } from 'react-chartjs-2';
import { mockElections, mockReport } from '../mockData';

ChartJS.register(
  ArcElement,
  CategoryScale,
  LinearScale,
  BarElement,
  Title,
  Tooltip,
  Legend
);

export default function ElectionReport() {
  const { id } = useParams<{ id: string }>();
  const election = mockElections.find(e => e.id === id);
  const report = mockReport;

  if (!election || !report) {
    return <div>Election not found</div>;
  }

  const pieData = {
    labels: report.results.map(r => r.candidateName),
    datasets: [
      {
        data: report.results.map(r => r.votes),
        backgroundColor: [
          'rgba(54, 162, 235, 0.8)',
          'rgba(255, 99, 132, 0.8)',
          'rgba(255, 206, 86, 0.8)',
          'rgba(75, 192, 192, 0.8)',
        ],
      },
    ],
  };

  const barData = {
    labels: report.results.map(r => r.candidateName),
    datasets: [
      {
        label: 'Votes',
        data: report.results.map(r => r.votes),
        backgroundColor: 'rgba(54, 162, 235, 0.8)',
      },
    ],
  };

  const handleEmailReport = () => {
    // Mock email sending
    toast.success('Report sent to all voters');
  };

  const handleDownloadReport = () => {
    // Mock download
    toast.success('Report downloaded');
  };

  const handleShareReport = () => {
    // Mock share functionality
    navigator.clipboard.writeText(window.location.href);
    toast.success('Report link copied to clipboard');
  };

  return (
    <div className="space-y-8">
      <div className="bg-white shadow sm:rounded-lg">
        <div className="px-4 py-5 sm:p-6">
          <h3 className="text-2xl font-bold text-gray-900 mb-8">
            Election Results: {election.title}
          </h3>

          <div className="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
            <div className="bg-blue-50 p-6 rounded-lg">
              <h4 className="text-lg font-semibold text-blue-900">Total Votes</h4>
              <p className="text-3xl font-bold text-blue-600">{report.totalVotes}</p>
            </div>
            <div className="bg-green-50 p-6 rounded-lg">
              <h4 className="text-lg font-semibold text-green-900">Voter Turnout</h4>
              <p className="text-3xl font-bold text-green-600">
                {((report.totalVotes / election.voters.length) * 100).toFixed(1)}%
              </p>
            </div>
            <div className="bg-purple-50 p-6 rounded-lg">
              <h4 className="text-lg font-semibold text-purple-900">Winner</h4>
              <p className="text-3xl font-bold text-purple-600">
                {report.results[0].candidateName}
              </p>
            </div>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-2 gap-8 mb-8">
            <div className="bg-gray-50 p-6 rounded-lg">
              <h4 className="text-lg font-semibold text-gray-900 mb-4">Vote Distribution</h4>
              <Pie data={pieData} />
            </div>
            <div className="bg-gray-50 p-6 rounded-lg">
              <h4 className="text-lg font-semibold text-gray-900 mb-4">Vote Comparison</h4>
              <Bar 
                data={barData}
                options={{
                  scales: {
                    y: {
                      beginAtZero: true
                    }
                  }
                }}
              />
            </div>
          </div>

          <div className="bg-gray-50 p-6 rounded-lg mb-8">
            <h4 className="text-lg font-semibold text-gray-900 mb-4">Detailed Results</h4>
            <div className="overflow-hidden shadow ring-1 ring-black ring-opacity-5 md:rounded-lg">
              <table className="min-w-full divide-y divide-gray-300">
                <thead className="bg-gray-50">
                  <tr>
                    <th className="py-3.5 pl-4 pr-3 text-left text-sm font-semibold text-gray-900">Candidate</th>
                    <th className="px-3 py-3.5 text-left text-sm font-semibold text-gray-900">Party</th>
                    <th className="px-3 py-3.5 text-left text-sm font-semibold text-gray-900">Votes</th>
                    <th className="px-3 py-3.5 text-left text-sm font-semibold text-gray-900">Percentage</th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-gray-200 bg-white">
                  {report.results.map((result) => {
                    const candidate = election.candidates.find(c => c.id === result.candidateId);
                    return (
                      <tr key={result.candidateId}>
                        <td className="whitespace-nowrap py-4 pl-4 pr-3 text-sm font-medium text-gray-900">
                          {result.candidateName}
                        </td>
                        <td className="whitespace-nowrap px-3 py-4 text-sm text-gray-500">
                          {candidate?.party}
                        </td>
                        <td className="whitespace-nowrap px-3 py-4 text-sm text-gray-500">
                          {result.votes}
                        </td>
                        <td className="whitespace-nowrap px-3 py-4 text-sm text-gray-500">
                          {result.percentage.toFixed(2)}%
                        </td>
                      </tr>
                    );
                  })}
                </tbody>
              </table>
            </div>
          </div>

          <div className="flex space-x-4">
            <button
              onClick={handleEmailReport}
              className="inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md shadow-sm text-white bg-blue-600 hover:bg-blue-700"
            >
              <Mail className="h-5 w-5 mr-2" />
              Email Report
            </button>
            <button
              onClick={handleDownloadReport}
              className="inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md shadow-sm text-white bg-green-600 hover:bg-green-700"
            >
              <Download className="h-5 w-5 mr-2" />
              Download Report
            </button>
            <button
              onClick={handleShareReport}
              className="inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md shadow-sm text-white bg-purple-600 hover:bg-purple-700"
            >
              <Share2 className="h-5 w-5 mr-2" />
              Share Report
            </button>
          </div>
        </div>
      </div>
    </div>
  );
}