# Biorhythm Clarinet Composer

A decentralized biorhythm tracking and analysis system built on the Stacks blockchain using Clarity smart contracts.

## Overview

The Biorhythm Clarinet Composer is a smart contract system that allows users to track and analyze their biorhythms - the theoretical cycles that describe the natural physiological, emotional, and intellectual states of a person. This system enables users to:

- Record daily biorhythm measurements
- Track physical, emotional, and intellectual cycles
- Analyze personal biorhythm patterns
- Generate insights based on historical data

## Biorhythm Theory

Biorhythm theory suggests that human life is affected by rhythmic biological cycles:

- **Physical Cycle (23 days)**: Relates to physical strength, coordination, and general well-being
- **Emotional Cycle (28 days)**: Affects creativity, sensitivity, mood, and emotional stability  
- **Intellectual Cycle (33 days)**: Influences cognitive functions, analytical thinking, and memory

## Smart Contract Architecture

The system consists of two main smart contracts:

### 1. Biorhythm Tracker (`biorhythm-tracker.clar`)
- Records daily biorhythm measurements for users
- Manages user profiles and measurement history
- Provides data validation and storage functions

### 2. Biorhythm Analyzer (`biorhythm-analyzer.clar`)
- Analyzes biorhythm patterns and trends
- Calculates cycle positions and predictions
- Generates insights and recommendations

## Features

- **Decentralized Data Storage**: All biorhythm data is stored securely on the Stacks blockchain
- **Privacy-Focused**: Users control their own biorhythm data
- **Historical Analysis**: Track long-term patterns and trends
- **Cycle Calculations**: Automatic calculation of biorhythm cycle positions
- **Data Validation**: Built-in validation to ensure data integrity

## Technical Stack

- **Blockchain**: Stacks
- **Smart Contract Language**: Clarity
- **Development Framework**: Clarinet
- **Testing**: Vitest
- **Version Control**: Git

## Getting Started

### Prerequisites
- Clarinet installed on your system
- Node.js and npm
- Git

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/sophieokafor06-maker/biorhythm-clarinet-composer.git
   cd biorhythm-clarinet-composer
   ```

2. Install dependencies:
   ```bash
   npm install
   ```

3. Run tests:
   ```bash
   npm test
   ```

4. Check contracts:
   ```bash
   clarinet check
   ```

## Usage

### Recording Biorhythm Data

Users can record their daily biorhythm measurements including physical energy, emotional state, and intellectual clarity levels.

### Analyzing Patterns

The system analyzes historical data to identify patterns, predict future cycle states, and provide insights for optimal timing of activities.

## Contract Functions

### Biorhythm Tracker
- `record-daily-measurement`: Record daily biorhythm values
- `get-user-profile`: Retrieve user biorhythm profile
- `get-measurement-history`: Get historical measurement data

### Biorhythm Analyzer  
- `calculate-cycle-position`: Calculate current position in biorhythm cycles
- `predict-future-state`: Predict biorhythm state for future dates
- `analyze-patterns`: Analyze long-term biorhythm patterns

## Development

### Running Tests
```bash
clarinet test
```

### Checking Contracts
```bash
clarinet check
```

### Local Development
```bash
clarinet console
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Ensure all tests pass
6. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Disclaimer

This biorhythm tracking system is for educational and entertainment purposes. Biorhythm theory is not scientifically proven and should not be used as the sole basis for important life decisions.

## Support

For questions, issues, or contributions, please open an issue on GitHub or contact the development team.

---

Built with ❤️ using Clarinet and the Stacks blockchain.