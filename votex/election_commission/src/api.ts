import { Candidate, Election } from "./types";

const API_BASE_URL = 'http://localhost:8000/api';

export const api = {
  // User verification
  getUnverifiedUsers: () =>
    fetch(`${API_BASE_URL}/users/unverified`).then(res => res.json()),

  verifyUser: (userId: string) =>
    fetch(`${API_BASE_URL}/users/${userId}/verify`, { method: 'POST' }),

  rejectUser: (userId: string, reason: string) =>
    fetch(`${API_BASE_URL}/users/${userId}/reject`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ reason })
    }),

  // Elections
  getElections: () =>
    fetch(`${API_BASE_URL}/elections`).then(res => res.json()),

  getElectionById: (id: string) =>
    fetch(`${API_BASE_URL}/elections/${id}`).then(res => res.json()),

  createElection: (data: Partial<Election>) =>
    fetch(`${API_BASE_URL}/elections`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(data)
    }).then(res => res.json()),

  updateElection: (id: string, data: Partial<Election>) =>
    fetch(`${API_BASE_URL}/elections/${id}`, {
      method: 'PUT',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(data)
    }).then(res => res.json()),

  deleteElection: (id: string) =>
    fetch(`${API_BASE_URL}/elections/${id}`, { method: 'DELETE' }),

  // Election candidates
  addCandidateToElection: (electionId: string, candidate: Partial<Candidate>) =>
    fetch(`${API_BASE_URL}/elections/${electionId}/candidates`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(candidate)
    }),

  removeCandidateFromElection: (electionId: string, candidateId: string) =>
    fetch(`${API_BASE_URL}/elections/${electionId}/candidates/${candidateId}`, {
      method: 'DELETE'
    }),

  // Election voters
  addVoterToElection: (electionId: string, voterId: string) =>
    fetch(`${API_BASE_URL}/elections/${electionId}/voters`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ voterId })
    }),

  removeVoterFromElection: (electionId: string, voterId: string) =>
    fetch(`${API_BASE_URL}/elections/${electionId}/voters/${voterId}`, {
      method: 'DELETE'
    }),

  // Election control
  startElection: (electionId: string) =>
    fetch(`${API_BASE_URL}/elections/${electionId}/start`, { method: 'POST' }),

  stopElection: (electionId: string) =>
    fetch(`${API_BASE_URL}/elections/${electionId}/stop`, { method: 'POST' }),

  // Reports
  getElectionReport: (electionId: string) =>
    fetch(`${API_BASE_URL}/elections/${electionId}/report`).then(res => res.json()),

  emailElectionReport: (electionId: string, recipients: string[]) =>
    fetch(`${API_BASE_URL}/elections/${electionId}/report/email`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ recipients })
    }),

  downloadElectionReport: (electionId: string, format: 'pdf' | 'csv') =>
    fetch(`${API_BASE_URL}/elections/${electionId}/report/download?format=${format}`),

  // Blockchain
  getBlockchainStatus: (electionId: string) =>
    fetch(`${API_BASE_URL}/elections/${electionId}/blockchain/status`).then(res => res.json()),

  getBlockchainConfig: (electionId: string) =>
    fetch(`${API_BASE_URL}/elections/${electionId}/blockchain/config`).then(res => res.json()),
};
