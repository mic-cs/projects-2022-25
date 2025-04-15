import type { User, Election, ElectionReport } from './types';

export const mockUsers: User[] = [
  {
    id: '1',
    name: 'John Doe',
    email: 'john@example.com',
    photoUrl: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100&h=100&fit=crop',
    verified: false,
    registeredAt: '2024-01-01T00:00:00Z'
  },
  {
    id: '2',
    name: 'Jane Smith',
    email: 'jane@example.com',
    photoUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100&h=100&fit=crop',
    verified: false,
    registeredAt: '2024-01-02T00:00:00Z'
  }
];

export const mockElections: Election[] = [
  {
    id: '1',
    title: 'Class Election 2024',
    description: 'Class representative election for 2024',
    startDate: '2025-03-20T00:00:00Z',
    endDate: '2025-03-21T23:59:59Z',
    status: 'draft',
    candidates: [
      {
        id: '1',
        name: 'Anandhu J',
        party: 'Independant',
        photoUrl: 'https://res.cloudinary.com/demazndgq/image/upload/v1741851107/axklf8akmkohof1yqm6x.jpg'
      },
      {
        id: '2',
        name: 'Liya',
        party: 'Independant',
        photoUrl: 'https://res.cloudinary.com/demazndgq/image/upload/v1741851222/k4lncxv0hd8hlfnat32d.jpg'
      }
    ],
    voters: ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23', '24', '25', '26', '27', '28', '29', '30', '31', '32', '33', '34', '35', '36', '37', '38', '39', '40', '41', '42', '43', '44', '45', '46', '47', '48']
  }
];

export const mockReport: ElectionReport = {
  electionId: '1',
  totalVotes: 48,
  results: [
    {
      candidateId: '1',
      candidateName: 'Anandhu J',
      votes: 27,
      percentage: 56.25
    },
    {
      candidateId: '2',
      candidateName: 'Liya',
      votes: 21,
      percentage: 43.75
    }
  ],
  timestamp: '2024-11-03T23:59:59Z'
};
