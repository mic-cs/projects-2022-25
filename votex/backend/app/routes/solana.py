import base64
import struct
from solana.rpc.async_api import AsyncClient
from solana.transaction import Transaction, TransactionInstruction
from solana.publickey import PublicKey
from solana.keypair import Keypair

# Update these constants based on your deployment.
SOLANA_RPC_URL = "https://api.devnet.solana.com"  # or your local validator URL
PROGRAM_ID = PublicKey(
    "4Nd1mJxZmLQ5zUzgLVX7qhZQUSex4eLWx5gd34ZWkPoH"
)  # Replace with your deployed program ID


async def update_tally(tally: int, tally_account_pubkey: str, payer: Keypair):
    """
    Update the tally on Solana.

    Args:
        tally: New tally value (u64)
        tally_account_pubkey: Public key of the account to update (as string)
        payer: A Keypair instance used to pay for the transaction fees.

    Returns:
        The RPC response from Solana.
    """
    async with AsyncClient(SOLANA_RPC_URL) as client:
        # Create the instruction data:
        # 1 byte for instruction tag (0) and 8 bytes for the tally (little-endian)
        data = bytes([0]) + struct.pack("<Q", tally)

        # Prepare the account metadata. We need the tally account to be writable.
        tally_account = PublicKey(tally_account_pubkey)
        instruction = TransactionInstruction(
            keys=[
                {"pubkey": tally_account, "is_signer": False, "is_writable": True},
            ],
            program_id=PROGRAM_ID,
            data=data,
        )

        txn = Transaction()
        txn.add(instruction)

        # Send the transaction.
        response = await client.send_transaction(txn, payer)
        return response
