/**
// @dev
*/
// SPDX-License-Identifier: MIT
pragma solidity ^0.4.26;


interface ITOKEN20 {
    function transfer(address to, uint256 value) external returns (bool);
    function transferFrom(address from, address to, uint256 value) external returns (bool);
}


contract YieldDistribution {
    function distributeNativeToken(address[] recipients, uint256[] values) external payable {
        for (uint256 i = 0; i < recipients.length; i++)
            recipients[i].transfer(values[i]);
        uint256 balance = address(this).balance;
        if (balance > 0)
            msg.sender.transfer(balance);
    }

    function distributeToken20(ITOKEN20 token, address[] recipients, uint256[] values) external {
        uint256 total = 0;
        for (uint256 i = 0; i < recipients.length; i++)
            total += values[i];
        require(token.transferFrom(msg.sender, address(this), total));
        for (i = 0; i < recipients.length; i++)
            require(token.transfer(recipients[i], values[i]));
    }
}