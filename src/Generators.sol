// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @dev Library to generate evenly spaced arrays between the specified start and
 * stop values, inclusive. If start is greater than stop, the array will be in
 * ascending order. If stop is greater than start, the array will be in
 * descending order. If the start and stop values are the same, the array will
 * contain a single element of that value.
 *
 * Generating the array by specifying number of elements is the typical API
 * used in other languages, so this is the default. However, there are also
 * methods that let you specify the step size between elements instead.
 *
 * Although the start and stop values are inclusive, the stop value is not
 * guaranteed to be in the array depending on the specified parameters. For
 * example, `linspace(1, 10, 3)` will return `[1, 5, 9]`.
 *
 * Both signed and unsigned integers are supported for linearly spaced arrays.
 * Logarithmically spaced arrays are not yet supported.
 */

// ==========================
// ======== Linspace ========
// ==========================
// Linear spacing, by number of elements.

function linspace(uint start, uint stop) pure returns (uint[] memory arr) {
  arr = linspace(start, stop, 50);
}

function linspace(int start, int stop) pure returns (int[] memory arr) {
  arr = linspace(start, stop, 50);
}

function linspace(uint start, uint stop, uint num)
  pure
  returns (uint[] memory arr)
{
  // Flip start and stop if generating a descending array.
  bool desc = start > stop;
  if (desc) (start, stop) = (stop, start);

  // Compute step size.
  uint size = stop - start;
  if (size == 0) num = 1;
  require(num - 1 <= size, "num larger than range"); // Prevent step size of 0 when num > 1
  uint step = num == 1 ? 0 : size / (num - 1);

  // Generate array.
  arr = new uint256[](num);
  for (uint i = 0; i < num; i++) {
    arr[i] = desc ? stop - i * step : start + i * step;
  }
}

function linspace(int start, int stop, uint num)
  pure
  returns (int[] memory arr)
{
  // Flip start and stop if generating a descending array.
  bool desc = start > stop;
  if (desc) (start, stop) = (stop, start);

  // Compute step size.
  uint size = range(start, stop);
  if (size == 0) num = 1;
  require(num - 1 <= size, "num larger than range"); // Prevent step size of 0 when num > 1.
  uint step = num == 1 ? 0 : size / (num - 1);

  // Generate array.
  arr = new int256[](num);
  for (uint i = 0; i < num; i++) {
    // Unlike the unsigned case, the signed case requires that we add `step`
    // to the prior array value instead of simply using `start + i * step`.
    // This is because `i * step` may be larger than type(int256).max for
    // ranges such as `linspace(type(int256).min, 1, 100)`, and we can't
    // represent that gap as a uint256 and add the uint256 to an int256.
    if (i == 0) arr[0] = desc ? stop : start;
    else arr[i] = desc ? arr[i - 1] - int(step) : arr[i - 1] + int(step);
  }
}

// ========================
// ======== Arange ========
// ========================
// Linear spacing, by step size.

// Default to a step size of 1.
function arange(uint start, uint stop) pure returns (uint[] memory arr) {
  arr = arange(start, stop, 1);
}

function arange(int start, int stop) pure returns (int[] memory arr) {
  arr = arange(start, stop, 1);
}

// Specify the step size.
function arange(uint start, uint stop, uint step)
  pure
  returns (uint[] memory arr)
{
  uint num = (range(start, stop) / step) + 1;
  arr = linspace(start, stop, num);
}

function arange(int start, int stop, uint step) pure returns (int[] memory arr) {
  uint num = (range(start, stop) / step) + 1;
  arr = linspace(start, stop, num);
}

// ==========================
// ======== Logspace ========
// ==========================
// Logarithmic Spacing.

// Default to 100 elements.
function logspace(uint start, uint stop) pure returns (uint[] memory arr) {
  arr = logspace(start, stop, 50);
}

// Specify the number of elements.
function logspace(uint start, uint stop, uint num)
  pure
  returns (uint[] memory arr)
{
  arr = logspace(start, stop, num, 10);
}

// Specify the number of elements and the exponent base.
function logspace(uint start, uint stop, uint num, uint base)
  pure
  returns (uint[] memory arr)
{
  // TODO Improve robustness so `linspace(2, 3, 4, 10)` returns `[100, 215, 464, 1000]` instead of reverting.
  arr = linspace(start, stop, num);
  for (uint i = 0; i < arr.length; i++) {
    arr[i] = base ** arr[i];
  }
}

// =======================
// ======== Utils ========
// =======================

function range(uint a, uint b) pure returns (uint c) {
  c = a > b ? a - b : b - a;
}

function range(int a, int b) pure returns (uint c) {
  bool sameSign = a >= 0 && b >= 0 || a < 0 && b < 0;
  c = sameSign ? range(abs(a), abs(b)) : abs(a) + abs(b);
}

function abs(int a) pure returns (uint b) {
  // Unchecked is required to handle the case when n = type(int256).min
  unchecked {
    b = uint(a >= 0 ? a : -a);
  }
}
