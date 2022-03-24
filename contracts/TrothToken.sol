// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
// import "@openzeppelin/contracts/access/roles/MinterRole.sol";

contract TrothToken is ERC20 {

    string private _name;
    string private _symbol;
    uint8 private _decimals;
    uint256 private _derivedAmount;

    // Map address to merchants
    mapping (address => string) public merchants;

    // wallet balance of customers mapped to merchants
    mapping (address => mapping(address => uint256)) public walletBalance;

    constructor(
        string memory name,
        string memory symbol,
        uint8 decimals
    ) public {
        _name = name;
        _symbol = symbol;
        _decimals = decimals;
    }

    /**
     * @dev Returns the name of the token.
     */
    function name() public view returns (string memory) {
        return _name;
    }

    /**
     * @dev Returns the symbol of the token, usually a shorter version of the
     * name.
     */
    function symbol() public view returns (string memory) {
        return _symbol;
    }

    function decimals() public view returns (uint8) {
        return _decimals;
    }

    function mint(address account, uint256 amount, address merchant) public returns (bool) {
        // require that merchant exist
        require(merchants[merchant] != false, "Onboarding: merchant does not exist");
        _derivedAmount = amount * (uint256(10) ** _decimals);
        _mint(account, _derivedAmount);
        _updateWalletBalance(merchant, account, amount, 'add');
        return true;
    }

    function spend(address account, uint256 amount, address merchant) public returns (bool) {
        _derivedAmount = amount * (uint256(10) ** _decimals);
        _burn(account, _derivedAmount);
        _updateWalletBalance(merchant, account, amount, 'sub');
        return true;
    }

    function getBalance(address account, address merchant) public view returns (uint256) {
        return walletBalance[merchant][account];
    }

    // Onboard new merchant
    function onboardMerchant(string name) {
        _addMerchant(msg.sender, name);
    }

    //get merchants
    function getMerchants() public view returns (string[]) {
        return merchants;
    }

    // add new merchant
    function _addMerchant(address merchant, string name) public {
        require(merchants[merchant] == false, "Onboarding: merchant already exists");
        require(name != "", "Merchant: name is empty");
        merchants[merchant] = name;
    }

    // update customer wallet balance
    function _updateWalletBalance(address merchant, address customer, uint256 amount, string operation) public {
        require(merchants[merchant] != false, "Merchant not found");
        require(customer != 0x0, "Customer address is empty");
        require(amount != 0, "Amount is empty");

        if(operation == "add") {
            walletBalance[merchant][customer] += amount;
        } else if(operation == "sub") {
            walletBalance[merchant][customer] -= amount;
        } else {
            require(false, "Operation is not valid");
        }
    }
}