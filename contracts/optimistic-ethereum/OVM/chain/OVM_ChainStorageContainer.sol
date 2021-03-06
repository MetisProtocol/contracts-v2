// SPDX-License-Identifier: MIT
pragma solidity >0.5.0 <0.8.0;

/* Library Imports */
import { Lib_RingBuffer } from "../../libraries/utils/Lib_RingBuffer.sol";
import { Lib_AddressResolver } from "../../libraries/resolver/Lib_AddressResolver.sol";

/* Interface Imports */
import { iOVM_ChainStorageContainer } from "../../iOVM/chain/iOVM_ChainStorageContainer.sol";

/**
 * @title OVM_ChainStorageContainer
 * @dev The Chain Storage Container provides its owner contract with read, write and delete functionality.
 * This provides gas efficiency gains by enabling it to overwrite storage slots which can no longer be used
 * in a fraud proof due to the fraud window having passed, and the associated chain state or
 * transactions being finalized.
 * Three disctint Chain Storage Containers will be deployed on Layer 1:
 * 1. Stores transaction batches for the Canonical Transaction Chain
 * 2. Stores queued transactions for the Canonical Transaction Chain
 * 3. Stores chain state batches for the State Commitment Chain
 *
 * Compiler used: solc
 * Runtime target: EVM
 */
contract OVM_ChainStorageContainer is iOVM_ChainStorageContainer, Lib_AddressResolver {

    /*************
     * Libraries *
     *************/

    using Lib_RingBuffer for Lib_RingBuffer.RingBuffer;

    /**************
     *  constant  *
     **************/
    uint256 constant public DEFAULT_CHAINID = 0;

    /*************
     * Variables *
     *************/

    string public owner;
    mapping(uint256=>Lib_RingBuffer.RingBuffer) internal buffers;


    /***************
     * Constructor *
     ***************/

    /**
     * @param _libAddressManager Address of the Address Manager.
     * @param _owner Name of the contract that owns this container (will be resolved later).
     */
    constructor(
        address _libAddressManager,
        string memory _owner
    )
        public
        Lib_AddressResolver(_libAddressManager)
    {
        owner = _owner;
    }


    /**********************
     * Function Modifiers *
     **********************/

    modifier onlyOwner() {
        require(
            msg.sender == resolve(owner),
            "OVM_ChainStorageContainer: Function can only be called by the owner."
        );
        _;
    }


    /********************
     * Public Functions *
     ********************/

    /**
     * @inheritdoc iOVM_ChainStorageContainer
     */
    function setGlobalMetadata(
        bytes27 _globalMetadata
    )
        override
        public
        onlyOwner
    {
        return setGlobalMetadata(DEFAULT_CHAINID,_globalMetadata);
    }
    
    /**
     * @inheritdoc iOVM_ChainStorageContainer
     */
    function setGlobalMetadata(
        uint256 _chainId,
        bytes27 _globalMetadata
    )
        override
        public
        onlyOwner
    {
        return buffers[_chainId].setExtraData(_globalMetadata);
    }

    /**
     * @inheritdoc iOVM_ChainStorageContainer
     */
    function getGlobalMetadata()
        override
        public
        view
        returns (
            bytes27
        )
    {
        return getGlobalMetadata(DEFAULT_CHAINID);
    }
    
    /**
     * @inheritdoc iOVM_ChainStorageContainer
     */
    function getGlobalMetadata(uint256 _chainId)
        override
        public
        view
        returns (
            bytes27
        )
    {
        return buffers[_chainId].getExtraData();
    }

    /**
     * @inheritdoc iOVM_ChainStorageContainer
     */
    function length()
        override
        public
        view
        returns (
            uint256
        )
    {
        return length(DEFAULT_CHAINID);
    }
    
        /**
     * @inheritdoc iOVM_ChainStorageContainer
     */
    function length(uint256 _chainId)
        override
        public
        view
        returns (
            uint256
        )
    {
        return uint256(buffers[_chainId].getLength());
    }

    /**
     * @inheritdoc iOVM_ChainStorageContainer
     */
    function push(
        bytes32 _object
    )
        override
        public
        onlyOwner
    {
        push(DEFAULT_CHAINID,_object);
    }
    /**
     * @inheritdoc iOVM_ChainStorageContainer
     */
    function push(
        uint256 _chainId,
        bytes32 _object
    )
        override
        public
        onlyOwner
    {
        buffers[_chainId].push(_object);
    }
    
    /**
     * @inheritdoc iOVM_ChainStorageContainer
     */
    function push(
        bytes32 _object,
        bytes27 _globalMetadata
    )
        override
        public
        onlyOwner
    {
        push(DEFAULT_CHAINID,_object,_globalMetadata);
    }
    /**
     * @inheritdoc iOVM_ChainStorageContainer
     */
    function push(
        uint256 _chainId,
        bytes32 _object,
        bytes27 _globalMetadata
    )
        override
        public
        onlyOwner
    {
        buffers[_chainId].push(_object, _globalMetadata);
    }

    /**
     * @inheritdoc iOVM_ChainStorageContainer
     */
    function push2(
        bytes32 _objectA,
        bytes32 _objectB
    )
        override
        public
        onlyOwner
    {
        push2(DEFAULT_CHAINID,_objectA, _objectB);
    }
    /**
     * @inheritdoc iOVM_ChainStorageContainer
     */
    function push2(
        uint256 _chainId,
        bytes32 _objectA,
        bytes32 _objectB
    )
        override
        public
        onlyOwner
    {
        buffers[_chainId].push2(_objectA, _objectB);
    }
    /**
     * @inheritdoc iOVM_ChainStorageContainer
     */
    function push2(
        bytes32 _objectA,
        bytes32 _objectB,
        bytes27 _globalMetadata
    )
        override
        public
        onlyOwner
    {
        push2(DEFAULT_CHAINID,_objectA, _objectB, _globalMetadata);
    }
    /**
     * @inheritdoc iOVM_ChainStorageContainer
     */
    function push2(
        uint256 _chainId,
        bytes32 _objectA,
        bytes32 _objectB,
        bytes27 _globalMetadata
    )
        override
        public
        onlyOwner
    {
        buffers[_chainId].push2(_objectA, _objectB, _globalMetadata);
    }
    /**
     * @inheritdoc iOVM_ChainStorageContainer
     */
    function get(
        uint256 _index
    )
        override
        public
        view
        returns (
            bytes32
        )
    {
        return get(DEFAULT_CHAINID,_index);
    }
    /**
     * @inheritdoc iOVM_ChainStorageContainer
     */
    function get(
        uint256 _chainId,
        uint256 _index
    )
        override
        public
        view
        returns (
            bytes32
        )
    {
        return buffers[_chainId].get(uint40(_index));
    }
    /**
     * @inheritdoc iOVM_ChainStorageContainer
     */
    function deleteElementsAfterInclusive(
        uint256 _index
    )
        override
        public
        onlyOwner
    {
       deleteElementsAfterInclusive(DEFAULT_CHAINID,_index);
    }
    
        /**
     * @inheritdoc iOVM_ChainStorageContainer
     */
    function deleteElementsAfterInclusive(
        uint256 _chainId,
        uint256 _index
    )
        override
        public
        onlyOwner
    {
        buffers[_chainId].deleteElementsAfterInclusive(
            uint40(_index)
        );
    }

    /**
     * @inheritdoc iOVM_ChainStorageContainer
     */
    function deleteElementsAfterInclusive(
        uint256 _index,
        bytes27 _globalMetadata
    )
        override
        public
        onlyOwner
    {
        deleteElementsAfterInclusive(_index,_globalMetadata);
    }
    
    /**
     * @inheritdoc iOVM_ChainStorageContainer
     */
    function deleteElementsAfterInclusive(
        uint256 _chainId,
        uint256 _index,
        bytes27 _globalMetadata
    )
        override
        public
        onlyOwner
    {
        buffers[_chainId].deleteElementsAfterInclusive(
            uint40(_index),
            _globalMetadata
        );
    }

    /**
     * @inheritdoc iOVM_ChainStorageContainer
     */
    function setNextOverwritableIndex(
        uint256 _index
    )
        override
        public
        onlyOwner
    {
        setNextOverwritableIndex(DEFAULT_CHAINID,_index);
    }
        
    /**
     * @inheritdoc iOVM_ChainStorageContainer
     */
    function setNextOverwritableIndex(
        uint256 _chainId,
        uint256 _index
    )
        override
        public
        onlyOwner
    {
        buffers[_chainId].nextOverwritableIndex = _index;
    }
}
