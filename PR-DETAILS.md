# Biorhythm Tracking System

## Overview

This pull request introduces a comprehensive biorhythm tracking and analysis system built on the Stacks blockchain using Clarity smart contracts. The system enables users to track their physical, emotional, and intellectual cycles while providing advanced analytics and predictions.

## Features Implemented

### 📊 Dual-Contract Architecture

**Biorhythm Tracker Contract (`biorhythm-tracker.clar`)** - 235 lines
- User profile management with birth date registration
- Daily biorhythm measurement recording (physical, emotional, intellectual)
- Statistical tracking with averages and streak calculations
- Data validation and integrity checks
- Historical measurement storage and retrieval

**Biorhythm Analyzer Contract (`biorhythm-analyzer.clar`)** - 334 lines
- Advanced cycle position calculations based on biorhythm theory
- Predictive analysis for future biorhythm states
- Pattern recognition and trend analysis
- Optimal timing recommendations
- Confidence scoring for predictions

### 🔧 Core Functionality

- **User Registration**: Register with birth date for accurate cycle calculations
- **Daily Tracking**: Record physical (0-100), emotional (0-100), and intellectual (0-100) values
- **Cycle Analysis**: Calculate positions within 23-day physical, 28-day emotional, and 33-day intellectual cycles
- **Predictions**: Generate future biorhythm predictions up to 90 days ahead
- **Pattern Analysis**: Identify dominant cycles and personal biorhythm patterns
- **Statistics**: Track averages, streaks, and overall performance metrics

### 📈 Technical Specifications

- **Total Lines of Code**: 569 lines across both contracts
- **Data Structures**: 6 comprehensive maps for user data, measurements, statistics, and analysis
- **Validation**: Robust input validation and error handling
- **Mathematical Precision**: Cycle calculations with percentage-based positioning
- **Testing**: Full test coverage with passing vitest suite
- **Compilation**: Clean compilation with clarinet check (warnings only for data validation)

## Smart Contract Details

### Biorhythm Cycles
- **Physical Cycle**: 23 days - affects strength, coordination, well-being
- **Emotional Cycle**: 28 days - influences creativity, mood, sensitivity  
- **Intellectual Cycle**: 33 days - impacts cognitive function, memory, analysis

### Key Functions

#### Biorhythm Tracker
- `register-user(birth-date)`: Create user profile
- `record-daily-measurement(date, physical, emotional, intellectual, notes)`: Log daily values
- `get-user-profile(user)`: Retrieve user information
- `get-daily-measurement(user, date)`: Get specific measurement
- `get-user-statistics(user)`: View performance statistics

#### Biorhythm Analyzer
- `analyze-biorhythm-cycles(user, birth-date, analysis-date)`: Calculate current cycle positions
- `generate-predictions(user, birth-date, target-date, days-ahead)`: Create future predictions
- `analyze-patterns(user, birth-date)`: Identify personal biorhythm patterns
- `get-timing-recommendations(user, birth-date, target-date)`: Optimal timing advice

## Testing & Validation

✅ **Clarinet Check**: All contracts compile successfully
✅ **Test Suite**: 2/2 test files passing with vitest
✅ **NPM Dependencies**: Installed and configured
✅ **Code Quality**: Clean, documented, and well-structured

## Data Security & Privacy

- Users maintain full control over their biorhythm data
- Decentralized storage on Stacks blockchain
- No personal information beyond birth date required
- Optional notes field for personal tracking

## Use Cases

1. **Personal Wellness**: Track daily energy and mood patterns
2. **Performance Optimization**: Time important activities during peak cycles
3. **Health Monitoring**: Identify patterns in physical and emotional well-being
4. **Life Planning**: Use predictions for scheduling and decision-making
5. **Research**: Contribute to biorhythm research through anonymized data

## Future Enhancements

- Integration with wearable devices for automatic data collection
- Social features for comparing patterns with friends
- AI-powered insights and personalized recommendations
- Historical data visualization and reporting
- Mobile app integration

## Disclaimer

This biorhythm tracking system is designed for educational and entertainment purposes. Biorhythm theory is not scientifically proven and should not be used as the sole basis for important life decisions.

## Repository Structure

```
biorhythm-clarinet-composer/
├── contracts/
│   ├── biorhythm-tracker.clar      # User data and measurement tracking
│   └── biorhythm-analyzer.clar     # Cycle analysis and predictions
├── tests/
│   ├── biorhythm-tracker.test.ts   # Tracker contract tests
│   └── biorhythm-analyzer.test.ts  # Analyzer contract tests
├── settings/                       # Network configurations
├── package.json                    # Dependencies and scripts
└── README.md                       # Project documentation
```

This comprehensive biorhythm system provides a solid foundation for personal cycle tracking and analysis on the Stacks blockchain, offering users valuable insights into their natural rhythms and patterns.