// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "src/Generators.sol";

contract GeneratorsTest is Test {
  event log_named_array(string key, uint[] val);
  event log_named_array(string key, int[] val);

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

  function assertEq(uint[] memory a, uint[] memory b) internal {
    if (keccak256(abi.encode(a)) != keccak256(abi.encode(b))) {
      emit log("Error: a == b not satisfied [string]");
      emit log_named_array("  Expected", b);
      emit log_named_array("    Actual", a);
      fail();
    }
  }

  function assertEq(int[] memory a, int[] memory b) internal {
    if (keccak256(abi.encode(a)) != keccak256(abi.encode(b))) {
      emit log("Error: a == b not satisfied [string]");
      emit log_named_array("  Expected", b);
      emit log_named_array("    Actual", a);
      fail();
    }
  }
}

contract UnsignedLinspace is GeneratorsTest {
  function test_Ascending() public {
    uint[] memory array = Generators.linspace(uint(0), 10, 11);
    assertEq(array, unsignedExpectedAscending);
  }

  function test_Descending() public {
    uint[] memory array = Generators.linspace(uint(10), 0, 11);
    assertEq(array, unsignedExpectedDescending);
  }

  function test_StartEqualsStop() public {
    uint[] memory array = Generators.linspace(uint(25), 25);
    assertEq(array.length, 1);
    assertEq(array[0], 25);
  }

  function testFuzz_Overloads(uint start, uint stop) public {
    // Bound minimum difference to avoid reverting from num - 1 <= size.
    vm.assume(Generators.range(start, stop) >= 49); // Using 49 since default size is 50.

    uint[] memory a = Generators.linspace(start, stop);
    uint[] memory b = Generators.linspace(start, stop, 50);
    assertEq(a, b);
  }
}

contract UnsignedArange is GeneratorsTest {
  function test_Ascending() public {
    uint[] memory array = Generators.arange(uint(0), 10, 1);
    assertEq(array, unsignedExpectedAscending);
  }

  function test_Descending() public {
    uint[] memory array = Generators.arange(uint(10), 0, 1);
    assertEq(array, unsignedExpectedDescending);
  }

  function test_StartEqualsStop() public {
    uint[] memory array = Generators.arange(uint(25), 25);
    assertEq(array.length, 1);
    assertEq(array[0], 25);
  }

  function testFuzz_Overloads(uint start, uint stop) public {
    // Bound max difference to avoid unrealistic/long-running test cases.
    if (stop > start && stop - start > 1000) start = stop - 1000;
    if (stop < start && start - stop > 1000) stop = start - 1000;

    uint[] memory a = Generators.arange(start, stop);
    uint[] memory b = Generators.arange(start, stop, 1);
    assertEq(a, b);
  }
}

contract SignedLinspace is GeneratorsTest {
  function test_Ascending() public {
    int[] memory array = Generators.linspace(-5, 5, 11);
    assertEq(array, signedExpectedAscending);

    int[] memory array2 = Generators.linspace(int(0), 10, 11);
    assertEq(array2, signedExpectedAscending2);
  }

  function test_Descending() public {
    int[] memory array = Generators.linspace(5, -5, 11);
    assertEq(array, signedExpectedDescending);

    int[] memory array2 = Generators.linspace(int(10), 0, 11);
    assertEq(array2, signedExpectedDescending2);
  }

  function test_StartEqualsStop() public {
    int[] memory array = Generators.linspace(int(25), 25);
    assertEq(array.length, 1);
    assertEq(array[0], 25);

    int[] memory array2 = Generators.linspace(-20, -20);
    assertEq(array2.length, 1);
    assertEq(array2[0], -20);
  }

  function testFuzz_Overloads(int start, int stop) public {
    // Bound minimum difference to avoid reverting from num - 1 <= size.
    vm.assume(Generators.range(start, stop) >= 49); // Using 49 since default size is 50.

    int[] memory a = Generators.linspace(start, stop);
    int[] memory b = Generators.linspace(start, stop, 50);
    assertEq(a, b);
  }
}

contract SignedArange is GeneratorsTest {
  function test_Ascending() public {
    int[] memory array = Generators.arange(-5, 5, 1);
    assertEq(array, signedExpectedAscending);
  }

  function test_Descending() public {
    int[] memory array = Generators.arange(5, -5, 1);
    assertEq(array, signedExpectedDescending);
  }

  function test_StartEqualsStop() public {
    int[] memory array = Generators.arange(int(25), 25);
    assertEq(array.length, 1);
    assertEq(array[0], 25);

    int[] memory array2 = Generators.arange(-20, -20);
    assertEq(array2.length, 1);
    assertEq(array2[0], -20);
  }

  function testFuzz_Overloads(int start, int stop) public {
    // Bound max difference to avoid unrealistic/long-running test cases.
    if (stop > start && Generators.range(start, stop) > 1000) {
      start = stop - 1000;
    }
    if (stop < start && Generators.range(start, stop) > 1000) {
      stop = start - 1000;
    }

    int[] memory a = Generators.arange(start, stop);
    int[] memory b = Generators.arange(start, stop, 1);
    assertEq(a, b);
  }
}

contract Logspace is GeneratorsTest {
  function test_Ascending() public {
    uint[] memory array = Generators.logspace(0, 6, 7); // Base 10.
    assertEq(array, logspaceAscending);

    uint[] memory array2 = Generators.logspace(2, 10, 10 - 2 + 1, 2); // Base 2.
    assertEq(array2, logspaceAscending2);
  }

  function test_Descending() public {
    uint[] memory array = Generators.logspace(6, 0, 7); // Base 10.
    assertEq(array, logspaceDescending);

    uint[] memory array2 = Generators.logspace(10, 2, 10 - 2 + 1, 2); // Base 2.
    assertEq(array2, logspaceDescending2);
  }

  function testFuzz_Overloads(uint start, uint stop) public {
    // Bound numbers to prevent overflow.
    start = bound(start, 0, 10);
    stop = bound(stop, start + 49, start + 49 + 20); // Ensure we don't revert due to zero step size.

    uint[] memory a = Generators.logspace(start, stop);
    uint[] memory b = Generators.logspace(start, stop, 50, 10);
    assertEq(a, b);
  }
}
