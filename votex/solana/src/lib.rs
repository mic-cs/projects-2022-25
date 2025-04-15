use solana_program::{
    account_info::{next_account_info, AccountInfo},
    entrypoint,
    entrypoint::ProgramResult,
    msg,
    program_error::ProgramError,
    pubkey::Pubkey,
};
pub enum VotingInstruction {
    UpdateTally { tally: u64 },
}
impl VotingInstruction {
    pub fn unpack(input: &[u8]) -> Result<Self, ProgramError> {
        let (&tag, rest) = input
            .split_first()
            .ok_or(ProgramError::InvalidInstructionData)?;
        match tag {
            0 => {
                if rest.len() != 8 {
                    return Err(ProgramError::InvalidInstructionData);
                }
                let tally = rest
                    .get(..8)
                    .and_then(|slice| slice.try_into().ok())
                    .map(u64::from_le_bytes)
                    .ok_or(ProgramError::InvalidInstructionData)?;
                Ok(Self::UpdateTally { tally })
            }
            _ => Err(ProgramError::InvalidInstructionData),
        }
    }
}
entrypoint!(process_instruction);
pub fn process_instruction(
    program_id: &Pubkey,
    accounts: &[AccountInfo],
    instruction_data: &[u8],
) -> ProgramResult {
    let instruction = VotingInstruction::unpack(instruction_data)?;
    match instruction {
        VotingInstruction::UpdateTally { tally } => {
            process_update_tally(program_id, accounts, tally)
        }
    }
}
pub fn process_update_tally(
    program_id: &Pubkey,
    accounts: &[AccountInfo],
    tally: u64,
) -> ProgramResult {
    let account_info_iter = &mut accounts.iter();
    let tally_account = next_account_info(account_info_iter)?;
    if tally_account.owner != program_id {
        msg!("Tally account is not owned by the program");
        return Err(ProgramError::IncorrectProgramId);
    }
    let mut data = tally_account.try_borrow_mut_data()?;
    if data.len() < 8 {
        return Err(ProgramError::AccountDataTooSmall);
    }
    data[..8].copy_from_slice(&tally.to_le_bytes());
    msg!("Tally updated to {}", tally);
    Ok(())
}
