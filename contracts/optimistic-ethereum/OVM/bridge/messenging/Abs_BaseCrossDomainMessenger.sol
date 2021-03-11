// SPDX-License-Identifier: MIT
pragma solidity >0.5.0 <0.8.0;
pragma experimental ABIEncoderV2;

/* Interface Imports */
import { iAbs_BaseCrossDomainMessenger } from "../../../iOVM/bridge/messenging/iAbs_BaseCrossDomainMessenger.sol";

/* Library Imports */
import { Lib_ReentrancyGuard } from "../../../libraries/utils/Lib_ReentrancyGuard.sol";

/**
 * @title Abs_BaseCrossDomainMessenger
 * @dev The Base Cross Domain Messenger is an abstract contract providing the interface and common functionality used in the
 * L1 and L2 Cross Domain Messengers. It can also serve as a template for developers wishing to implement a custom bridge 
 * contract to suit their needs.
 *
 * Compiler used: defined by child contract
 * Runtime target: defined by child contract
 */
abstract contract Abs_BaseCrossDomainMessenger is iAbs_BaseCrossDomainMessenger, Lib_ReentrancyGuard {

    /**********************
     * Contract Variables *
     **********************/

    mapping (bytes32 => bool) public relayedMessages;
    mapping (bytes32 => bool) public successfulMessages;
    mapping (bytes32 => bool) public sentMessages;
    uint256 public messageNonce;
    address override public xDomainMessageSender;

    /********************
     * Public Functions *
     ********************/

    constructor() Lib_ReentrancyGuard() internal {}

    /**
     * Sends a cross domain message to the target messenger.
     * @param _target Target contract address.
     * @param _message Message to send to the target.
     * @param _gasLimit Gas limit for the provided message.
     */
    function sendMessage(
        address _target,
        bytes memory _message,
        uint32 _gasLimit
    )
        override
        public
    {
        bytes memory xDomainCalldata = _getXDomainCalldata(
            _target,
            msg.sender,
            _message,
            messageNonce
        );

        messageNonce += 1;
        sentMessages[keccak256(xDomainCalldata)] = true;

        _sendXDomainMessage(xDomainCalldata, _gasLimit);
        emit SentMessage(xDomainCalldata);
    }

    /**
     * Sends a cross domain message to the target messenger.
     * @param _chainId L2 chain id.
     * @param _target Target contract address.
     * @param _message Message to send to the target.
     * @param _gasLimit Gas limit for the provided message.
     */
    function sendMessageViaChainId(
        uint256 _chainId,
        address _target,
        bytes memory _message,
        uint32 _gasLimit
    )
        override
        public
    {
        bytes memory xDomainCalldata = _getXDomainCalldataViaChainId(
            _chainId,
            _target,
            msg.sender,
            _message,
            messageNonce
        );

        bytes memory xDomainCalldataRaw = _getXDomainCalldata(
            _target,
            msg.sender,
            _message,
            messageNonce
        );

        messageNonce += 1;
        sentMessages[keccak256(xDomainCalldata)] = true;

        _sendXDomainMessageViaChainId(_chainId, xDomainCalldataRaw, _gasLimit);
        emit SentMessage(xDomainCalldataRaw);
    }

    /**********************
     * Internal Functions *
     **********************/

    /**
     * Generates the correct cross domain calldata for a message.
     * @param _target Target contract address.
     * @param _sender Message sender address.
     * @param _message Message to send to the target.
     * @param _messageNonce Nonce for the provided message.
     * @return ABI encoded cross domain calldata.
     */
    function _getXDomainCalldata(
        address _target,
        address _sender,
        bytes memory _message,
        uint256 _messageNonce
    )
        internal
        pure
        returns (
            bytes memory
        )
    {
        return abi.encodeWithSignature(
            "relayMessage(address,address,bytes,uint256)",
            _target,
            _sender,
            _message,
            _messageNonce
        );
    }

    /**
     * Generates the correct cross domain calldata for a message.
     * @param _chainId L2 chain id.
     * @param _target Target contract address.
     * @param _sender Message sender address.
     * @param _message Message to send to the target.
     * @param _messageNonce Nonce for the provided message.
     * @return ABI encoded cross domain calldata.
     */
    function _getXDomainCalldataViaChainId(
        uint256 _chainId,
        address _target,
        address _sender,
        bytes memory _message,
        uint256 _messageNonce
    )
        internal
        pure
        returns (
            bytes memory
        )
    {
        return abi.encodeWithSignature(
            "relayMessageViaChainId(chainId,address,address,bytes,uint256)",
            _chainId,
            _target,
            _sender,
            _message,
            _messageNonce
        );
    }

    /**
     * Sends a cross domain message.
     * @param _message Message to send.
     * @param _gasLimit Gas limit for the provided message.
     */
    function _sendXDomainMessage(
        bytes memory _message,
        uint256 _gasLimit
    )
        virtual
        internal
    {
        revert("Implement me in child contracts!");
    }

    /**
     * Sends a cross domain message.
     * @param _chainId L2 chain id.
     * @param _message Message to send.
     * @param _gasLimit Gas limit for the provided message.
     */
    function _sendXDomainMessageViaChainId(
        uint256 _chainId,
        bytes memory _message,
        uint256 _gasLimit
    )
        virtual
        internal
    {
        revert("Implement me in child contracts!");
    }
}
