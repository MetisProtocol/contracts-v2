import { expect } from '../../setup'

/* External Imports */
import { ethers } from 'hardhat'
import { Signer, ContractFactory, Contract, BigNumber, providers } from 'ethers'
import { TransactionResponse } from '@ethersproject/abstract-provider'
import { smockit, MockContract } from '@eth-optimism/smock'
import _ from 'lodash'

/* Internal Imports */
import {
  makeAddressManager,
  setProxyTarget,
  FORCE_INCLUSION_PERIOD_SECONDS,
  FORCE_INCLUSION_PERIOD_BLOCKS,
  setEthTime,
  NON_ZERO_ADDRESS,
  remove0x,
  getEthTime,
  getNextBlockNumber,
  increaseEthTime,
  getBlockTime,
  ZERO_ADDRESS,
} from '../../helpers'
import { defaultAbiCoder, keccak256 } from 'ethers/lib/utils'

const ELEMENT_TEST_SIZES = [1, 2, 4, 8, 16]
const DECOMPRESSION_ADDRESS = '0x4200000000000000000000000000000000000008'
const MAX_GAS_LIMIT = 8_000_000

const encodeApplyL2ChainIdTransaction = (
  sender: string,
  target: string,
  gasLimit: number,
  data: string
): string => {
  return defaultAbiCoder.encode(
    ['address', 'address', 'uint256', 'bytes'],
    [sender, target, gasLimit, data]
  )
}

const applyL2ChainId = async (contact) => {
    const methodId = keccak256(Buffer.from('applyL2ChainId()')).slice(2, 10);
    return contact.signer.sendTransaction({
        to: contact.address,
        data: '0x' + methodId,
    });
};

describe('MVM_L2ChainManagerOnL1', () => {
  let signer: Signer
  let sequencer: Signer
  before(async () => {
    ;[signer, sequencer] = await ethers.getSigners()
  })

  let AddressManager: Contract
  before(async () => {
    AddressManager = await makeAddressManager()
  })

  let Factory__MVM_L2ChainManagerOnL1: ContractFactory
  before(async () => {
    Factory__MVM_L2ChainManagerOnL1 = await ethers.getContractFactory(
      'MVM_L2ChainManagerOnL1'
    )
  })

  let MVM_L2ChainManagerOnL1: Contract
  beforeEach(async () => {
    MVM_L2ChainManagerOnL1 = await Factory__MVM_L2ChainManagerOnL1.deploy(
      AddressManager.address,
      AddressManager.address
    )
  })

  var l2ChainId 
  describe('applyL2ChainId', () => {
    const target = NON_ZERO_ADDRESS
    const gasLimit = 500_000
    const data = '0x' + '12'.repeat(1234)
    
    it('should return the new chain id which incresed by one', async () => {
      const t=await applyL2ChainId(MVM_L2ChainManagerOnL1);
      await t.wait();
      const id=await MVM_L2ChainManagerOnL1.l2chainIds(MVM_L2ChainManagerOnL1.signer.getAddress())
      console.log(id)
      expect(
       id
      ).to.gte(1)
    })
  })
})
