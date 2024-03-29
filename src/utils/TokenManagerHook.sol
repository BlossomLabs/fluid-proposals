/*
 * SPDX-License-Identitifer:    MIT
 */

pragma solidity ^0.8.0;

import "./ReentrancyGuard.sol";

/**
 * @dev When creating a subcontract, we recommend overriding the _internal_ functions that you want to hook.
 */
contract TokenManagerHook is ReentrancyGuard {
    using UnstructuredStorage for bytes32;

    /* Hardcoded constants to save gas
    bytes32 public constant TOKEN_MANAGER_POSITION = keccak256("hookedTokenManager.tokenManagerHook.tokenManager");
    */
    bytes32 private constant TOKEN_MANAGER_POSITION = 0x5c513b2347f66d33af9d68f4a0ed7fbb73ce364889b2af7f3ee5764440da6a8a;

    modifier onlyTokenManager() {
        require(getTokenManager() == msg.sender, "Hooks must be called from Token Manager");
        _;
    }

    function getTokenManager() public view returns (address) {
        return TOKEN_MANAGER_POSITION.getStorageAddress();
    }

    /*
     * @dev Called when this contract has been included as a Token Manager hook
     * @param _hookId The position in which the hook is going to be called
     * @param _token The token controlled by the Token Manager
     */
    function onRegisterAsHook(uint256 _hookId, address _token) external nonReentrant {
        require(getTokenManager() == address(0), "Hook already registered by Token Manager");
        TOKEN_MANAGER_POSITION.setStorageAddress(msg.sender);
        _onRegisterAsHook(msg.sender, _hookId, _token);
    }

    /*
     * @dev Called when this hook is being removed from the Token Manager
     * @param _hookId The position in which the hook is going to be called
     * @param _token The token controlled by the Token Manager
     */
    function onRevokeAsHook(uint256 _hookId, address _token) external onlyTokenManager nonReentrant {
        _onRevokeAsHook(msg.sender, _hookId, _token);
    }

    /*
     * @dev Notifies the hook about a token transfer allowing the hook to react if desired. It should return
     * true if left unimplemented, otherwise it will prevent some functions in the TokenManager from
     * executing successfully.
     * @param _from The origin of the transfer
     * @param _to The destination of the transfer
     * @param _amount The amount of the transfer
     */
    function onTransfer(address _from, address _to, uint256 _amount)
        external
        onlyTokenManager
        nonReentrant
        returns (bool)
    {
        return _onTransfer(_from, _to, _amount);
    }

    /*
     * @dev Notifies the hook about an approval allowing the hook to react if desired. It should return
     * true if left unimplemented, otherwise it will prevent some functions in the TokenManager from
     * executing successfully.
     * @param _holder The account that is allowing to spend
     * @param _spender The account that is allowed to spend
     * @param _amount The amount being allowed
     */
    function onApprove(address _holder, address _spender, uint256 _amount)
        external
        onlyTokenManager
        nonReentrant
        returns (bool)
    {
        return _onApprove(_holder, _spender, _amount);
    }

    // Function to override if necessary:

    function _onRegisterAsHook(address, uint256, address) internal virtual {
        return;
    }

    function _onRevokeAsHook(address, uint256, address) internal virtual {
        return;
    }

    function _onTransfer(address, address, uint256) internal virtual returns (bool) {
        return true;
    }

    function _onApprove(address, address, uint256) internal virtual returns (bool) {
        return true;
    }
}
