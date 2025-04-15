# Election Commission Frontend

This frontend application provides an interface for managing elections, verifying users, and handling election-related operations.

## API Endpoints

### User Verification

#### Get Unverified Users
- **GET** `/api/users/unverified`
- Returns list of users pending verification
- Response: `User[]`

#### Verify User
- **POST** `/api/users/:userId/verify`
- Approves a user's verification request
- Response: `200 OK`

#### Reject User
- **POST** `/api/users/:userId/reject`
- Rejects a user's verification request
- Request Body: `{ reason: string }`
- Response: `200 OK`

### Elections Management

#### List Elections
- **GET** `/api/elections`
- Returns all elections
- Response: `Election[]`

#### Get Election
- **GET** `/api/elections/:id`
- Returns details of a specific election
- Response: `Election`

#### Create Election
- **POST** `/api/elections`
- Creates a new election
- Request Body: `Partial<Election>`
- Response: `Election`

#### Update Election
- **PUT** `/api/elections/:id`
- Updates an existing election
- Request Body: `Partial<Election>`
- Response: `Election`

#### Delete Election
- **DELETE** `/api/elections/:id`
- Deletes an election
- Response: `200 OK`

### Candidates Management

#### Add Candidate
- **POST** `/api/elections/:electionId/candidates`
- Adds a candidate to an election
- Request Body: `Partial<Candidate>`
- Response: `200 OK`

#### Remove Candidate
- **DELETE** `/api/elections/:electionId/candidates/:candidateId`
- Removes a candidate from an election
- Response: `200 OK`

### Voters Management

#### Add Voter
- **POST** `/api/elections/:electionId/voters`
- Adds a voter to an election
- Request Body: `{ voterId: string }`
- Response: `200 OK`

#### Remove Voter
- **DELETE** `/api/elections/:electionId/voters/:voterId`
- Removes a voter from an election
- Response: `200 OK`

### Election Control

#### Start Election
- **POST** `/api/elections/:electionId/start`
- Starts an election
- Response: `200 OK`
- Triggers blockchain configuration generation

#### Stop Election
- **POST** `/api/elections/:electionId/stop`
- Stops an election
- Response: `200 OK`
- Triggers result calculation and report generation

### Reports

#### Get Election Report
- **GET** `/api/elections/:electionId/report`
- Returns the election results and analytics
- Response: `ElectionReport`

#### Email Report
- **POST** `/api/elections/:electionId/report/email`
- Sends the election report to specified recipients
- Request Body: `{ recipients: string[] }`
- Response: `200 OK`

#### Download Report
- **GET** `/api/elections/:electionId/report/download`
- Downloads the election report
- Query Parameters: `format=pdf|csv`
- Response: File download

### Blockchain Operations

#### Get Blockchain Status
- **GET** `/api/elections/:electionId/blockchain/status`
- Returns the status of the blockchain network
- Response: `{ status: string, nodes: number, lastBlock: string }`

#### Get Blockchain Config
- **GET** `/api/elections/:electionId/blockchain/config`
- Returns the Hyperledger Fabric configuration
- Response: `{ config: object, microfab: object }`

## Data Types

### User
```typescript
interface User {
  id: string;
  name: string;
  email: string;
  photoUrl: string;
  verified: boolean;
  registeredAt: string;
}
```

### Candidate
```typescript
interface Candidate {
  id: string;
  name: string;
  party: string;
  photoUrl: string;
}
```

### Election
```typescript
interface Election {
  id: string;
  title: string;
  description: string;
  startDate: string;
  endDate: string;
  status: 'draft' | 'active' | 'completed';
  candidates: Candidate[];
  voters: string[];
}
```

### ElectionReport
```typescript
interface ElectionReport {
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
```

## Features

1. User Verification
   - View unverified users
   - Compare user photos with database records
   - Verify or reject users

2. Election Management
   - Create new elections
   - Add candidates to elections
   - Add voters to elections
   - Start/stop elections
   - View election reports

3. Dashboard
   - Overview of system statistics
   - Active elections count
   - Pending verifications
   - Completed elections

4. Reports
   - Generate election reports
   - Email reports to stakeholders
   - Download reports in multiple formats
   - Public access to election results

5. Blockchain Integration
   - Automatic Hyperledger Fabric configuration
   - Microfab setup for development
   - Secure vote recording
   - Transparent audit trail