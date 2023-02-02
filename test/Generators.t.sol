// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import {linspace, arange, logspace, range} from "../src/Generators.sol";

// =======================
// ======== Setup ========
// =======================
contract GeneratorsTest is Test {
  // Test vectors.
  uint[] unsignedExpectedAscending = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
  uint[] unsignedExpectedDescending = [10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0];

  int[] signedExpectedAscending = [int(-5), -4, -3, -2, -1, 0, 1, 2, 3, 4, 5];
  int[] signedExpectedDescending = [int(5), 4, 3, 2, 1, 0, -1, -2, -3, -4, -5];

  int[] signedExpectedAscending2 = [int(0), 1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
  int[] signedExpectedDescending2 = [int(10), 9, 8, 7, 6, 5, 4, 3, 2, 1, 0];

  uint[] logspaceAscending = [1, 1e1, 1e2, 1e3, 1e4, 1e5, 1e6];
  uint[] logspaceDescending = [1e6, 1e5, 1e4, 1e3, 1e2, 1e1, 1];

  uint[] logspaceAscending2 = [4, 8, 16, 32, 64, 128, 256, 512, 1024];
  uint[] logspaceDescending2 = [1024, 512, 256, 128, 64, 32, 16, 8, 4];
}

// ==========================
// ======== Linspace ========
// ==========================

contract LinspaceUnsigned is GeneratorsTest {
  function test_Ascending() public {
    uint[] memory array = linspace(uint(0), 10, 11);
    assertEq(array, unsignedExpectedAscending);
  }

  function test_Descending() public {
    uint[] memory array = linspace(uint(10), 0, 11);
    assertEq(array, unsignedExpectedDescending);
  }

  function test_StartEqualsStop() public {
    uint[] memory array = linspace(uint(25), 25);
    assertEq(array.length, 1);
    assertEq(array[0], 25);
  }

  function testFuzz_Overloads(uint start, uint stop) public {
    // Bound minimum difference to avoid reverting from num - 1 <= size.
    vm.assume(range(start, stop) >= 49); // Using 49 since default size is 50.

    uint[] memory a = linspace(start, stop);
    uint[] memory b = linspace(start, stop, 50);
    assertEq(a, b);
  }
}

contract LinspaceSigned is GeneratorsTest {
  function test_Ascending() public {
    int[] memory array = linspace(-5, 5, 11);
    assertEq(array, signedExpectedAscending);

    int[] memory array2 = linspace(int(0), 10, 11);
    assertEq(array2, signedExpectedAscending2);
  }

  function test_Descending() public {
    int[] memory array = linspace(5, -5, 11);
    assertEq(array, signedExpectedDescending);

    int[] memory array2 = linspace(int(10), 0, 11);
    assertEq(array2, signedExpectedDescending2);
  }

  function test_StartEqualsStop() public {
    int[] memory array = linspace(int(25), 25);
    assertEq(array.length, 1);
    assertEq(array[0], 25);

    int[] memory array2 = linspace(-20, -20);
    assertEq(array2.length, 1);
    assertEq(array2[0], -20);
  }

  function testFuzz_Overloads(int start, int stop) public {
    // Bound minimum difference to avoid reverting from num - 1 <= size.
    vm.assume(range(start, stop) >= 49); // Using 49 since default size is 50.

    int[] memory a = linspace(start, stop);
    int[] memory b = linspace(start, stop, 50);
    assertEq(a, b);
  }
}

// =======================
// ======== Arange ========
// =======================

contract ArangeUnsigned is GeneratorsTest {
  function test_Ascending() public {
    uint[] memory array = arange(uint(0), 10, 1);
    assertEq(array, unsignedExpectedAscending);
  }

  function test_Descending() public {
    uint[] memory array = arange(uint(10), 0, 1);
    assertEq(array, unsignedExpectedDescending);
  }

  function test_StartEqualsStop() public {
    uint[] memory array = arange(uint(25), 25);
    assertEq(array.length, 1);
    assertEq(array[0], 25);
  }

  function testFuzz_Overloads(uint start, uint stop) public {
    // Bound max difference to avoid unrealistic/long-running test cases.
    if (stop > start && stop - start > 1000) start = stop - 1000;
    if (stop < start && start - stop > 1000) stop = start - 1000;

    uint[] memory a = arange(start, stop);
    uint[] memory b = arange(start, stop, 1);
    assertEq(a, b);
  }
}

contract ArangeSigned is GeneratorsTest {
  function test_Ascending() public {
    int[] memory array = arange(-5, 5, 1);
    assertEq(array, signedExpectedAscending);
  }

  function test_Descending() public {
    int[] memory array = arange(5, -5, 1);
    assertEq(array, signedExpectedDescending);
  }

  function test_StartEqualsStop() public {
    int[] memory array = arange(int(25), 25);
    assertEq(array.length, 1);
    assertEq(array[0], 25);

    int[] memory array2 = arange(-20, -20);
    assertEq(array2.length, 1);
    assertEq(array2[0], -20);
  }

  function testFuzz_Overloads(int start, int stop) public {
    // Bound max difference to avoid unrealistic/long-running test cases.
    if (stop > start && range(start, stop) > 1000) start = stop - 1000;
    if (stop < start && range(start, stop) > 1000) stop = start - 1000;

    int[] memory a = arange(start, stop);
    int[] memory b = arange(start, stop, 1);
    assertEq(a, b);
  }
}

// ==========================
// ======== Logspace ========
// ==========================

contract Logspace is GeneratorsTest {
  function test_Ascending() public {
    uint[] memory array = logspace(0, 6, 7); // Base 10.
    assertEq(array, logspaceAscending);

    uint[] memory array2 = logspace(2, 10, 10 - 2 + 1, 2); // Base 2.
    assertEq(array2, logspaceAscending2);
  }

  function test_Descending() public {
    uint[] memory array = logspace(6, 0, 7); // Base 10.
    assertEq(array, logspaceDescending);

    uint[] memory array2 = logspace(10, 2, 10 - 2 + 1, 2); // Base 2.
    assertEq(array2, logspaceDescending2);
  }

  function testFuzz_Overloads(uint start, uint stop) public {
    // Bound numbers to prevent overflow.
    start = bound(start, 0, 10);
    stop = bound(stop, start + 49, start + 49 + 20); // Ensure we don't revert due to zero step size.

    uint[] memory a = logspace(start, stop);
    uint[] memory b = logspace(start, stop, 50, 10);
    assertEq(a, b);
  }
}
