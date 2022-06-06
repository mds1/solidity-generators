// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "src/Generators.sol";

contract GeneratorsTest is Test {
  event log_named_array(string key, uint256[] val);
  event log_named_array(string key, int256[] val);

  // Test vectors.
  uint256[] unsignedExpectedAscending = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
  uint256[] unsignedExpectedDescending = [10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0];

  int256[] signedExpectedAscending = [int256(-5), -4, -3, -2, -1, 0, 1, 2, 3, 4, 5];
  int256[] signedExpectedDescending = [int256(5), 4, 3, 2, 1, 0, -1, -2, -3, -4, -5];

  int256[] signedExpectedAscending2 = [int256(0), 1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
  int256[] signedExpectedDescending2 = [int256(10), 9, 8, 7, 6, 5, 4, 3, 2, 1, 0];

  function assertEq(uint256[] memory a, uint256[] memory b) internal {
    if (keccak256(abi.encode(a)) != keccak256(abi.encode(b))) {
      emit log("Error: a == b not satisfied [string]");
      emit log_named_array("  Expected", b);
      emit log_named_array("    Actual", a);
      fail();
    }
  }

  function assertEq(int256[] memory a, int256[] memory b) internal {
    if (keccak256(abi.encode(a)) != keccak256(abi.encode(b))) {
      emit log("Error: a == b not satisfied [string]");
      emit log_named_array("  Expected", b);
      emit log_named_array("    Actual", a);
      fail();
    }
  }
}

contract UnsignedLinspaceByNumel is GeneratorsTest {
  function test_UnsignedLinspaceByNumel_Ascending() public {
    uint256[] memory array = Generators.linspace(uint256(0), 10, 11);
    assertEq(array, unsignedExpectedAscending);
  }

  function test_UnsignedLinspaceByNumel_Descending() public {
    uint256[] memory array = Generators.linspace(uint256(10), 0, 11);
    assertEq(array, unsignedExpectedDescending);
  }

  function test_UnsignedStartEqualsStop() public {
    uint256[] memory array = Generators.linspace(uint256(25), 25);
    assertEq(array.length, 1);
    assertEq(array[0], 25);
  }

  function testFuzz_UnsignedLinspaceByNumel_Overloads(uint256 start, uint256 stop) public {
    uint256[] memory a = Generators.linspace(start, stop);
    uint256[] memory b = Generators.linspace(start, stop, 50);
    uint256[] memory c = Generators.linspaceByNumel(start, stop, 50);
    assertEq(a, b);
    assertEq(a, c);
  }
}

contract UnsignedLinspaceByStep is GeneratorsTest {
  function test_UnsignedLinspaceByStep_Ascending() public {
    uint256[] memory array = Generators.linspaceByStep(uint256(0), 10, 1);
    assertEq(array, unsignedExpectedAscending);
  }

  function test_UnsignedLinspaceByStep_Descending() public {
    uint256[] memory array = Generators.linspaceByStep(uint256(10), 0, 1);
    assertEq(array, unsignedExpectedDescending);
  }

  function testFuzz_UnsignedLinspaceByStep_Overloads(uint256 start, uint256 stop) public {
    // Bound max difference to avoid unrealistic/long-running test cases.
    if (stop > start && stop - start > 1000) start = stop - 1000;
    if (stop < start && start - stop > 1000) stop = start - 1000;

    uint256[] memory a = Generators.linspaceByStep(start, stop);
    uint256[] memory b = Generators.linspaceByStep(start, stop, 1);
    assertEq(a, b);
  }
}

contract SignedLinspaceByNumel is GeneratorsTest {
  function test_SignedLinspaceByNumel_Ascending() public {
    int256[] memory array = Generators.linspace(-5, 5, 11);
    assertEq(array, signedExpectedAscending);

    int256[] memory array2 = Generators.linspace(int256(0), 10, 11);
    assertEq(array2, signedExpectedAscending2);
  }

  function test_SignedLinspaceByNumel_Descending() public {
    int256[] memory array = Generators.linspace(5, -5, 11);
    assertEq(array, signedExpectedDescending);

    int256[] memory array2 = Generators.linspace(int256(10), 0, 11);
    assertEq(array2, signedExpectedDescending2);
  }

  function test_SignedStartEqualsStop() public {
    int256[] memory array = Generators.linspace(int256(25), 25);
    assertEq(array.length, 1);
    assertEq(array[0], 25);

    int256[] memory array2 = Generators.linspace(-20, -20);
    assertEq(array2.length, 1);
    assertEq(array2[0], -20);
  }

  function testFuzz_SignedLinspaceByNumel_Overloads(int256 start, int256 stop) public {
    int256[] memory a = Generators.linspace(start, stop);
    int256[] memory b = Generators.linspace(start, stop, 50);
    int256[] memory c = Generators.linspaceByNumel(start, stop, 50);
    assertEq(a, b);
    assertEq(a, c);
  }
}

contract SignedLinspaceByStep is GeneratorsTest {
  function test_SignedLinspaceByStep_Ascending() public {
    int256[] memory array = Generators.linspaceByStep(-5, 5, 1);
    assertEq(array, signedExpectedAscending);
  }

  function test_SignedLinspaceByStep_Descending() public {
    int256[] memory array = Generators.linspaceByStep(5, -5, 1);
    assertEq(array, signedExpectedDescending);
  }

  function testFuzz_SignedLinspaceByStep_Overloads(int256 start, int256 stop) public {
    // Bound max difference to avoid unrealistic/long-running test cases.
    if (stop > start && Generators.range(start, stop) > 1000) start = stop - 1000;
    if (stop < start && Generators.range(start, stop) > 1000) stop = start - 1000;

    int256[] memory a = Generators.linspaceByStep(start, stop);
    int256[] memory b = Generators.linspaceByStep(start, stop, 1);
    assertEq(a, b);
  }
}
