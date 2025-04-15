export interface User {
  verification_id: string;
  name: string;
  dob: string;
  email: string;
  phone: string;
  photo: string;
  verified: boolean;
  registeredAt: string;
}

export interface Candidate {
  id: string;
  name: string;
  party: string;
  photoUrl: string;
}

export interface Election {
  id: string;
  title: string;
  description: string;
  startDate: string;
  endDate: string;
  status: 'draft' | 'active' | 'completed';
  candidates: Candidate[];
  voters: string[];
}

export interface ElectionReport {
  electionId: string;
  totalVotes: number;
  results: {
    candidateId: string;
    candidateName: string;
    votes: number;
    percentage: number;
  }[];
  timestamp: string;
}
