// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @dev Library to generate evenly spaced arrays between the specified start and stop values,
 * inclusive. If start is greater than stop, the array will be in ascending order. If stop is
 * greater than start, the array will be in descending order. If the start and stop values are the
 * same, the array will contain a single element of that value.
 *
 * Generating the array by specifying number of elements is the typical API used in other
 * languages, so this is the default. However, there are also methods that let you specify the
 * step size between elements instead.
 *
 * Although the start and stop values are inclusive, the stop value is not guaranteed to be in the
 * array depending on the specified parameters. For example, `linspace(1, 10, 3)` will return `[1, 5, 9]`.
 *
 * Both signed and unsigned integers are supported for linearly spaced arrays. Logarithmically
 * spaced arrays are not yet supported.
 */
library Generators {
  // --------------------------------
  // -------- Linear Spacing --------
  // --------------------------------

  // -------- By number of elements --------

  function linspace(uint256 start, uint256 stop) internal pure returns (uint256[] memory result) {
    result = linspaceByNumel(start, stop, 50);
  }

  function linspace(int256 start, int256 stop) internal pure returns (int256[] memory result) {
    result = linspaceByNumel(start, stop, 50);
  }

  function linspace(uint256 start, uint256 stop, uint256 numel) internal pure returns (uint256[] memory result) {
    result = linspaceByNumel(start, stop, numel);
  }

  function linspace(int256 start, int256 stop, uint256 numel) internal pure returns (int256[] memory result) {
    result = linspaceByNumel(start, stop, numel);
  }

  function linspaceByNumel(uint256 start, uint256 stop, uint256 numel) internal pure returns (uint256[] memory result) {
    bool descending = start > stop;
    if (descending) (start, stop) = (stop, start);

    if (start == stop) numel = 1;
    uint256 step = numel == 1 ? 0 : (stop - start) / (numel - 1);

    result = new uint256[](numel);
    for (uint256 i = 0; i < numel; i++) {
      result[i] = descending ? stop - i * step : start + i * step;
    }
  }

  function linspaceByNumel(int256 start, int256 stop, uint256 numel) internal pure returns (int256[] memory result) {
    bool descending = start > stop;
    if (descending) (start, stop) = (stop, start);

    if (start == stop) numel = 1;
    uint256 step = numel == 1 ? 0 : range(start, stop) / (numel - 1);

    result = new int256[](numel);
    for (uint256 i = 0; i < numel; i++) {
      // Unlike the unsigned case, the signed case requires that we add `step` to the prior array value instead of
      // simply using `start + i * step`. This is because `i * step` may be larger than type(int256).max for
      // ranges such as `linspace(type(int256).min, 1, 100)`, and we can't represent that gap as a uint256 and
      // add the uint256 to an int256.
      if (i == 0) {
        result[0] = descending ? stop : start;
      } else {
        result[i] = descending ? result[i-1] - int256(step)  : result[i-1] + int256(step);
      }
    }
  }

  // -------- By step size --------

  // Default to a step size of 1.
  function linspaceByStep(uint256 start, uint256 stop) internal pure returns (uint256[] memory result) {
    result = linspaceByStep(start, stop, 1);
  }

  function linspaceByStep(int256 start, int256 stop) internal pure returns (int256[] memory result) {
    result = linspaceByStep(start, stop, 1);
  }

  // Specify the step size.
  function linspaceByStep(uint256 start, uint256 stop, uint256 step) internal pure returns (uint256[] memory result) {
    uint256 num = (range(start, stop) / step) + 1; // Number of elements for the specified step size.
    result = linspaceByNumel(start, stop, num);
  }

  function linspaceByStep(int256 start, int256 stop, uint256 step) internal pure returns (int256[] memory result) {
    uint256 num = (range(start, stop) / step) + 1; // Number of elements for the specified step size.
    result = linspaceByNumel(start, stop, num);
  }

  // -------------------------------------
  // -------- Logarithmic Spacing --------
  // -------------------------------------

  // Default to 100 elements.
  function logspace(uint256 start, uint256 stop) internal pure returns (uint256[] memory result) {
    result = logspace(start, stop, 100);
  }

  // Specify the number of elements.
  function logspace(uint256 start, uint256 stop, uint256 n) internal pure returns (uint256[] memory result) {
    start; stop; n; result; // Silence compiler warnings.
    revert("not implemented"); // TODO Implement logarithmic spacing.
  }

  // -----------------------
  // -------- Utils --------
  // -----------------------

  function range(uint256 a, uint256 b) internal pure returns (uint256 c) {
    c = a > b ? a - b : b - a;
  }

  function range(int256 a, int256 b) internal pure returns (uint256 c) {
    bool sameSign = a >= 0 && b >= 0 || a < 0 && b < 0;
    c = sameSign ? range(abs(a), abs(b)) : abs(a) + abs(b);
  }

  function abs(int256 a) internal pure returns (uint256 b) {
    // Unchecked is required to handle the case when n = type(int256).min
    unchecked {
      b = uint256(a >= 0 ? a : -a);
    }
  }
}
