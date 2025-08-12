# ERCS - Ethereum Request for Comment

This project demonstrates Ethereum smart contract development using Hardhat. It includes ERC20 token implementation with comprehensive testing and CI/CD pipeline.

## Features

- ERC20 token implementation
- Comprehensive test suite
- Automated CI/CD pipeline with GitHub Actions
- TypeScript support
- Test coverage reporting

## Getting Started

### Prerequisites

- Node.js (v18 or higher)
- npm or yarn

### Installation

```shell
npm install
```

### Available Scripts

```shell
# Compile contracts
npm run compile

# Run tests
npm run test

# Run tests with verbose output
npm run test:verbose

# Generate test coverage
npm run test:coverage

# Run tests with gas reporting
npm run test:gas

# Clean artifacts
npm run clean
```

### Manual Hardhat Commands

```shell
npx hardhat help
npx hardhat test
REPORT_GAS=true npx hardhat test
npx hardhat node
npx hardhat ignition deploy ./ignition/modules/Lock.ts
```

## CI/CD Pipeline

This project includes automated GitHub Actions workflows:

### 1. Simple Test Runner (`hardhat-test.yml`)

- Runs on push/PR to master/main branches
- Compiles contracts and runs all tests

### 2. Basic Test Workflow (`test.yml`)

- Tests on multiple Node.js versions (18.x, 20.x)
- Includes test coverage reporting
- Uploads coverage to Codecov

### 3. Comprehensive CI/CD (`ci-cd.yml`)

- Linting and formatting checks
- Multi-version testing
- Security audits
- Artifact building and storage

The workflows automatically run when you:

- Push to master/main/develop branches
- Create pull requests to master/main/develop branches

## Project Structure

```text
contracts/          # Smart contracts
├── Lock.sol
└── Token/
    ├── ERC20.sol    # ERC20 implementation
    └── IERC20.sol   # ERC20 interface

test/               # Test files
├── Lock.ts
└── Token/
    └── ERC20.test.ts

ignition/modules/   # Deployment scripts
typechain-types/    # Generated TypeScript types
```

## Testing

All tests are located in the `test/` directory and follow the structure:

- `test/Lock.ts` - Tests for Lock contract
- `test/Token/ERC20.test.ts` - Tests for ERC20 token

Tests are written using Mocha and Chai with Hardhat's testing environment.
