package main

import (
	"crypto/sha256"
	"encoding/hex"
	"encoding/json"
	"fmt"
	"time"

	"github.com/hyperledger/fabric-contract-api-go/contractapi"
)

type SmartContract struct {
	contractapi.Contract
}

type Election struct {
	ID          string            `json:"id"`
	Name        string            `json:"name"`
	Candidates  []string          `json:"candidates"`
	VoteCounts  map[string]int    `json:"voteCounts"`
	VoterStatus map[string]string `json:"voterStatus"`
}

func (s *SmartContract) CreateElection(ctx contractapi.TransactionContextInterface, electionID string, name string) error {
	exists, err := s.ElectionExists(ctx, electionID)
	if err != nil {
		return err
	}
	if exists {
		return fmt.Errorf("election %s already exists", electionID)
	}

	election := Election{
		ID:          electionID,
		Name:        name,
		Candidates:  []string{},
		VoteCounts:  make(map[string]int),
		VoterStatus: make(map[string]string),
	}

	electionJSON, err := json.Marshal(election)
	if err != nil {
		return err
	}

	return ctx.GetStub().PutState(electionID, electionJSON)
}

func (s *SmartContract) ElectionExists(ctx contractapi.TransactionContextInterface, electionID string) (bool, error) {
	data, err := ctx.GetStub().GetState(electionID)
	if err != nil {
		return false, err
	}
	return data != nil, nil
}

func (s *SmartContract) AddCandidate(ctx contractapi.TransactionContextInterface, electionID string, candidateID string) error {
	election, err := s.GetElection(ctx, electionID)
	if err != nil {
		return err
	}

	for _, c := range election.Candidates {
		if c == candidateID {
			return fmt.Errorf("candidate %s already exists in election %s", candidateID, electionID)
		}
	}

	election.Candidates = append(election.Candidates, candidateID)

	election.VoteCounts[candidateID] = 0

	electionJSON, err := json.Marshal(election)
	if err != nil {
		return err
	}

	return ctx.GetStub().PutState(electionID, electionJSON)
}

func (s *SmartContract) AssignVoter(ctx contractapi.TransactionContextInterface, electionID string, voterID string) error {
	election, err := s.GetElection(ctx, electionID)
	if err != nil {
		return err
	}

	if _, exists := election.VoterStatus[voterID]; exists {
		return fmt.Errorf("voter %s is already registered (or has voted) in election %s", voterID, electionID)
	}

	election.VoterStatus[voterID] = ""

	electionJSON, err := json.Marshal(election)
	if err != nil {
		return err
	}

	return ctx.GetStub().PutState(electionID, electionJSON)
}

func (s *SmartContract) CastVote(ctx contractapi.TransactionContextInterface, electionID string, voterID string, candidateID string) (string, error) {
	election, err := s.GetElection(ctx, electionID)
	if err != nil {
		return "", err
	}

	receipt, exists := election.VoterStatus[voterID]
	if !exists {
		return "", fmt.Errorf("voter %s is not registered for election %s", voterID, electionID)
	}

	if receipt != "" {
		return "", fmt.Errorf("voter %s has already voted", voterID)
	}

	validCandidate := false
	for _, c := range election.Candidates {
		if c == candidateID {
			validCandidate = true
			break
		}
	}
	if !validCandidate {
		return "", fmt.Errorf("candidate %s is not valid for election %s", candidateID, electionID)
	}

	election.VoteCounts[candidateID]++

	txTime, err := ctx.GetStub().GetTxTimestamp()
	if err != nil {
		return "", err
	}

	timestamp := time.Unix(txTime.Seconds, int64(txTime.Nanos)).Unix()
	data := fmt.Sprintf("%s:%s:%s:%d", electionID, voterID, candidateID, timestamp)
	hash := sha256.Sum256([]byte(data))
	voteReceipt := hex.EncodeToString(hash[:])

	election.VoterStatus[voterID] = voteReceipt

	electionJSON, err := json.Marshal(election)
	if err != nil {
		return "", err
	}
	if err = ctx.GetStub().PutState(electionID, electionJSON); err != nil {
		return "", err
	}

	return voteReceipt, nil
}

func (s *SmartContract) VerifyVote(ctx contractapi.TransactionContextInterface, electionID string, voterID string) (string, error) {
	election, err := s.GetElection(ctx, electionID)
	if err != nil {
		return "", err
	}

	receipt, exists := election.VoterStatus[voterID]
	if !exists || receipt == "" {
		return "", fmt.Errorf("no vote recorded for voter %s in election %s", voterID, electionID)
	}
	return receipt, nil
}

func (s *SmartContract) GetElection(ctx contractapi.TransactionContextInterface, electionID string) (*Election, error) {
	electionJSON, err := ctx.GetStub().GetState(electionID)
	if err != nil {
		return nil, err
	}
	if electionJSON == nil {
		return nil, fmt.Errorf("election %s does not exist", electionID)
	}
	var election Election
	if err = json.Unmarshal(electionJSON, &election); err != nil {
		return nil, err
	}
	return &election, nil
}

func main() {
	chaincode, err := contractapi.NewChaincode(new(SmartContract))
	if err != nil {
		fmt.Printf("Error creating chaincode: %s", err.Error())
		return
	}
	if err = chaincode.Start(); err != nil {
		fmt.Printf("Error starting chaincode: %s", err.Error())
	}
}
