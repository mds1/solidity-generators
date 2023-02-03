# Solidity Array Generators

Solidity library offering `linspace`, `arrange`, and `logspace` methods to generate evenly spaced arrays.
Both signed and unsigned integers are supported.

This library was written for use in development/testing:

- It is not designed to be gas efficient.
- It has not been heavily tested and may contain bugs.

Also, it's not a library in the Solidity sense, it's really just a file full of [free functions](https://docs.soliditylang.org/en/latest/contracts.html#functions).

## Installation

To use this in a [Foundry](https://github.com/foundry-rs/foundry) project, install it with:

```sh
forge install https://github.com/mds1/solidity-generators
```

There is no npm package, so for projects using npm for package management, such as [Hardhat](https://hardhat.org/) projects, use:

```sh
yarn add https://github.com/mds1/solidity-generators.git
```

## Usage

This library generates evenly spaced arrays between the specified start and stop values, inclusive.
Function names and signatures are similar to those of [numpy](https://numpy.org/), and this library currently supports:

- `linspace`: Returns linearly spaced numbers over a specified interval, specifying the length of the array. Defaults to 50 elements in the array if not specified.
- `arrange`: Returns linearly spaced numbers over a specified interval, specifying the step size. Defaults to a step size of 1 if not specified.
- `logspace`: Returns numbers spaced evenly on a log scale. Unlike `linspace` and `arrange`, you don't enter the start and stop values directly, but their exponents. Start and stop values are then calculated as `base ** start` and `base ** stop`. Defaults to 50 elements in the array and a base of 10 if not specified.

Each method behaves as follows:

- If start is smaller than stop, the array will be in ascending order.
- If start is larger than stop, the array will be in descending order.
- If the start and stop values are the same, the array will contain a single element of that value.

Arrays default to a length of 50 and step size of 1 unless specified otherwise.

Although the start and stop values are inclusive, the stop value is not guaranteed to be in the array depending on the specified parameters.
See the examples below for more info.

Note that current implementation of `logspace` is naive, and therefore will revert if the parameters passed are not valid `linspace` args.
If there is demand for it, a future version may remove this restriction.

## Examples

```solidity
import {linspace, arrange, logspace} from "solidity-generators/Generators.sol";

uint256 ustart = 0;
uint256 ustop  = 1000;

int256 istart = -1000;
int256 istop = 1000;

// ==========================
// ======== Linspace ========
// ==========================
// Linear spacing, by number of elements.

linspace(ustart, ustop);
// Returns [0, 20, 40, ..., 940, 960, 980]

linspace(ustart, ustop, 50);
// Returns [0, 20, 40, ..., 940, 960, 980]

linspace(ustart, ustop, 51);
// Returns [0, 20, 40, ..., 940, 960, 980, 1000]


linspace(istart, istop);
// Returns [-1000, -960, -920, ..., 880, 920, 960]

linspace(istart, istop, 50);
// Returns [-1000, -960, -920, ..., 880, 920, 960]

linspace(istart, istop, 51);
// Returns [-1000, -960, -920, ..., 880, 920, 960, 1000]

// ========================
// ======== Arrange ========
// ========================
// Linear spacing, by step size.

arrange(ustart, ustop);
// Returns [0, 1, 2, ..., 998, 999, 1000]

arrange(ustart, ustop, 250);
// Returns [0, 250, 500, 750, 1000]


arrange(istart, istop, 500);
// Returns [-1000, -500, 0, 500, 1000]

arrange(istart, istop);
// Returns [-1000, -999, -998, ..., 998, 999, 1000]

// ==========================
// ======== Logspace ========
// ==========================
// Logarithmic Spacing.

logspace(0, 6, 7); // Base 10.
// Returns [1, 10, 100, 1000, 10_000, 100_000, 1_000_000]

logspace(2, 10, 9, 2); // Base 2.
// Returns [4, 8, 16, 32, 64, 128, 256, 512, 1024]

// ================================
// ======== Other Examples ========
// ================================

// We can flip the order for a descending array.
arrange(istop, istart);
// Returns [1000, 999, 998, ..., -998, -999, -1000]

logspace(6, 0, 7); // Base 10.
// Returns [1_000_000, 100_000, 10_000, 1000, 100, 10, 1]


// Bounds are not guaranteed to be exclusive if not cleanly divisible.
linspace(ustart, 10, 4);
// Returns [0, 3, 6, 9]

arrange(ustart, 10, 3);
// Returns [0, 3, 6, 9]
```
