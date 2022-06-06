# Solidity Array Generators

Solidity library offering `linspace` and `arange` (and soon `logspace`) methods to generate evenly spaced arrays.
Both signed and unsigned integers are supported.
Logarithmically spaced arrays are not yet supported.

*This library has not been heavily tested and may contain bugs.*

## Installation

To use this in a [Foundry](https://github.com/foundry-rs/foundry) project, install it with:

```sh
forge install https://github.com/mds1/solidity-generators
```

There is currently no npm package, so for projects using npm for package management, such as [Hardhat](https://hardhat.org/) projects, use:

```sh
yarn add https://github.com/mds1/solidity-generators.git
```

## Usage

This library generates evenly spaced arrays between the specified start and stop values, inclusive.
Function names and signatures are similar to those of [numpy](https://numpy.org/).
They behaves as follows:

- If start is smaller than stop, the array will be in ascending order.
- If start is larger than stop, the array will be in descending order.
- If the start and stop values are the same, the array will contain a single element of that value.

Arrays default to a length of 50 and step size of 1 unless specified otherwise.
Note that although the start and stop values are inclusive, the stop value is not guaranteed to be in the array depending on the specified parameters.
See the examples below for more info.

```solidity
uint256 ustart = 0;
uint256 ustop  = 1000;
int256 istart = -1000;
int256 istop = 1000;

// ---------------------------------------
// -------- By number of elements --------
// ---------------------------------------

Generators.linspace(ustart, ustop);
// Returns [0, 20, 40, ..., 940, 960, 980]

Generators.linspace(ustart, ustop, 50);
// Returns [0, 20, 40, ..., 940, 960, 980] 

Generators.linspace(ustart, ustop, 51);
// Returns [0, 20, 40, ..., 940, 960, 980, 1000]


Generators.linspace(istart, istop);
// Returns [-1000, -960, -920, ..., 880, 920, 960]

Generators.linspace(istart, istop, 50);
// Returns [-1000, -960, -920, ..., 880, 920, 960]

Generators.linspace(istart, istop, 51);
// Returns [-1000, -960, -920, ..., 880, 920, 960, 1000]

// ------------------------------
// -------- By step size --------
// ------------------------------

Generators.arange(ustart, ustop);
// Returns [0, 1, 2, ..., 998, 999, 1000]

Generators.arange(ustart, ustop, 250);
// Returns [0, 250, 500, 750, 1000]


Generators.arange(istart, istop, 500);
// Returns [-1000, -500, 0, 500, 1000]

Generators.arange(istart, istop);
// Returns [-1000, -999, -998, ..., 998, 999, 1000]

// --------------------------------
// -------- Other examples --------
// --------------------------------

// We can flip the order for a descending array.
Generators.arange(istop, istart);
// Returns [1000, 999, 998, ..., -998, -999, -1000]

// Bounds are not guaranteed to be exclusive if not cleanly divisible.
Generators.linspace(ustart, 10, 4);
// Returns [0, 3, 6, 9]

Generators.arange(ustart, 10, 3);
// Returns [0, 3, 6, 9]
```
