;; Biorhythm Analyzer Smart Contract
;; Analyzes biorhythm patterns and calculates cycle positions

;; Constants
(define-constant ERR_UNAUTHORIZED (err u1))
(define-constant ERR_INVALID_DATE (err u2))
(define-constant ERR_USER_NOT_FOUND (err u3))
(define-constant ERR_INSUFFICIENT_DATA (err u4))
(define-constant ERR_CALCULATION_FAILED (err u5))

;; Biorhythm cycle constants (in days)
(define-constant PHYSICAL_CYCLE u23)
(define-constant EMOTIONAL_CYCLE u28) 
(define-constant INTELLECTUAL_CYCLE u33)

;; Mathematical constants
(define-constant PI_MULTIPLIED u31416) ;; Pi * 10000 for precision
(define-constant SINE_PRECISION u10000)
(define-constant DAYS_IN_YEAR u365)
(define-constant MAX_PREDICTION_DAYS u90)

;; Data structures
(define-map cycle-analysis
  { user: principal, analysis-date: uint }
  {
    physical-position: uint,
    emotional-position: uint,
    intellectual-position: uint,
    physical-phase: (string-ascii 20),
    emotional-phase: (string-ascii 20), 
    intellectual-phase: (string-ascii 20),
    overall-score: uint,
    calculated-at: uint
  }
)

(define-map biorhythm-predictions
  { user: principal, prediction-date: uint }
  {
    predicted-physical: uint,
    predicted-emotional: uint,
    predicted-intellectual: uint,
    confidence-score: uint,
    generated-at: uint
  }
)

(define-map pattern-analysis
  { user: principal }
  {
    dominant-cycle: (string-ascii 20),
    best-days-pattern: (string-ascii 50),
    worst-days-pattern: (string-ascii 50),
    trend-direction: (string-ascii 20),
    last-analysis: uint,
    data-quality: uint
  }
)

;; Data variables
(define-data-var total-analyses uint u0)
(define-data-var total-predictions uint u0)

;; Helper functions

;; Calculate days since birth
(define-private (calculate-days-since-birth (birth-date uint) (current-date uint))
  (if (>= current-date birth-date)
    (/ (- current-date birth-date) u86400) ;; Convert seconds to days
    u0
  )
)

;; Calculate cycle position (0-100 representing percentage through cycle)
(define-private (calculate-cycle-position (days-lived uint) (cycle-length uint))
  (let (
    (cycle-position (mod days-lived cycle-length))
    (percentage (/ (* cycle-position u100) cycle-length))
  )
    percentage
  )
)

;; Determine cycle phase based on position
(define-private (get-cycle-phase (position uint))
  (if (<= position u25)
    "rising"
    (if (<= position u50)
      "high"
      (if (<= position u75)
        "falling"
        "low"
      )
    )
  )
)

;; Calculate biorhythm value using sine approximation
(define-private (calculate-biorhythm-value (position uint))
  ;; Simplified sine calculation - in practice would use more accurate approximation
  (let (
    (angle (/ (* position u360) u100)) ;; Convert to degrees
  )
    (if (<= angle u90)
      (+ u50 (/ (* position u50) u100))
      (if (<= angle u180)
        (+ u50 (/ (* (- u100 position) u50) u100))
        (if (<= angle u270)
          (- u50 (/ (* (- position u50) u50) u50))
          (- u50 (/ (* (- u100 position) u50) u50))
        )
      )
    )
  )
)

;; Calculate overall biorhythm score
(define-private (calculate-overall-score (physical uint) (emotional uint) (intellectual uint))
  (/ (+ physical emotional intellectual) u3)
)

;; Public functions

;; Analyze current biorhythm cycles for a user
(define-public (analyze-biorhythm-cycles (user principal) (birth-date uint) (analysis-date uint))
  (let (
    (days-lived (calculate-days-since-birth birth-date analysis-date))
    (physical-pos (calculate-cycle-position days-lived PHYSICAL_CYCLE))
    (emotional-pos (calculate-cycle-position days-lived EMOTIONAL_CYCLE))
    (intellectual-pos (calculate-cycle-position days-lived INTELLECTUAL_CYCLE))
    (physical-phase (get-cycle-phase physical-pos))
    (emotional-phase (get-cycle-phase emotional-pos))
    (intellectual-phase (get-cycle-phase intellectual-pos))
    (physical-value (calculate-biorhythm-value physical-pos))
    (emotional-value (calculate-biorhythm-value emotional-pos))
    (intellectual-value (calculate-biorhythm-value intellectual-pos))
    (overall (calculate-overall-score physical-value emotional-value intellectual-value))
    (current-time (unwrap-panic (get-stacks-block-info? time (- stacks-block-height u1))))
  )
    (asserts! (> analysis-date u0) ERR_INVALID_DATE)
    (asserts! (>= analysis-date birth-date) ERR_INVALID_DATE)
    
    (map-set cycle-analysis
      { user: user, analysis-date: analysis-date }
      {
        physical-position: physical-pos,
        emotional-position: emotional-pos,
        intellectual-position: intellectual-pos,
        physical-phase: physical-phase,
        emotional-phase: emotional-phase,
        intellectual-phase: intellectual-phase,
        overall-score: overall,
        calculated-at: current-time
      }
    )
    
    (var-set total-analyses (+ (var-get total-analyses) u1))
    
    (ok {
      physical: physical-value,
      emotional: emotional-value,
      intellectual: intellectual-value,
      overall: overall
    })
  )
)

;; Generate biorhythm predictions for future dates
(define-public (generate-predictions (user principal) (birth-date uint) (target-date uint) (days-ahead uint))
  (let (
    (days-lived (calculate-days-since-birth birth-date target-date))
    (future-days (+ days-lived days-ahead))
    (pred-physical-pos (calculate-cycle-position future-days PHYSICAL_CYCLE))
    (pred-emotional-pos (calculate-cycle-position future-days EMOTIONAL_CYCLE)) 
    (pred-intellectual-pos (calculate-cycle-position future-days INTELLECTUAL_CYCLE))
    (pred-physical (calculate-biorhythm-value pred-physical-pos))
    (pred-emotional (calculate-biorhythm-value pred-emotional-pos))
    (pred-intellectual (calculate-biorhythm-value pred-intellectual-pos))
    (confidence (calculate-confidence-score days-ahead))
    (current-time (unwrap-panic (get-stacks-block-info? time (- stacks-block-height u1))))
    (prediction-date (+ target-date (* days-ahead u86400)))
  )
    (asserts! (<= days-ahead MAX_PREDICTION_DAYS) ERR_INVALID_DATE)
    (asserts! (> target-date u0) ERR_INVALID_DATE)
    
    (map-set biorhythm-predictions
      { user: user, prediction-date: prediction-date }
      {
        predicted-physical: pred-physical,
        predicted-emotional: pred-emotional,
        predicted-intellectual: pred-intellectual,
        confidence-score: confidence,
        generated-at: current-time
      }
    )
    
    (var-set total-predictions (+ (var-get total-predictions) u1))
    
    (ok {
      date: prediction-date,
      physical: pred-physical,
      emotional: pred-emotional,
      intellectual: pred-intellectual,
      confidence: confidence
    })
  )
)

;; Analyze long-term patterns for a user
(define-public (analyze-patterns (user principal) (birth-date uint))
  (let (
    (current-time (unwrap-panic (get-stacks-block-info? time (- stacks-block-height u1))))
    (days-lived (calculate-days-since-birth birth-date current-time))
    (dominant (determine-dominant-cycle days-lived))
    (trend (analyze-trend-direction user))
    (data-quality (assess-data-quality user))
  )
    (map-set pattern-analysis
      { user: user }
      {
        dominant-cycle: dominant,
        best-days-pattern: "high-energy-peaks",
        worst-days-pattern: "low-energy-valleys", 
        trend-direction: trend,
        last-analysis: current-time,
        data-quality: data-quality
      }
    )
    
    (ok {
      dominant-cycle: dominant,
      trend: trend,
      quality: data-quality
    })
  )
)

;; Helper functions for analysis

(define-private (calculate-confidence-score (days-ahead uint))
  (if (<= days-ahead u7)
    u95
    (if (<= days-ahead u30)
      u80
      (if (<= days-ahead u60)
        u65
        u50
      )
    )
  )
)

(define-private (determine-dominant-cycle (days-lived uint))
  (let (
    (physical-strength (mod days-lived PHYSICAL_CYCLE))
    (emotional-strength (mod days-lived EMOTIONAL_CYCLE))
    (intellectual-strength (mod days-lived INTELLECTUAL_CYCLE))
  )
    (if (and (>= physical-strength emotional-strength) (>= physical-strength intellectual-strength))
      "physical"
      (if (>= emotional-strength intellectual-strength)
        "emotional"
        "intellectual"
      )
    )
  )
)

(define-private (analyze-trend-direction (user principal))
  ;; Simplified trend analysis
  "stable"
)

(define-private (assess-data-quality (user principal))
  ;; Simplified data quality assessment
  u75
)

;; Read-only functions

;; Get cycle analysis for a specific date
(define-read-only (get-cycle-analysis (user principal) (analysis-date uint))
  (map-get? cycle-analysis { user: user, analysis-date: analysis-date })
)

;; Get biorhythm predictions
(define-read-only (get-predictions (user principal) (prediction-date uint))
  (map-get? biorhythm-predictions { user: user, prediction-date: prediction-date })
)

;; Get pattern analysis
(define-read-only (get-pattern-analysis (user principal))
  (map-get? pattern-analysis { user: user })
)

;; Calculate current cycle positions
(define-read-only (get-current-cycle-positions (birth-date uint) (current-date uint))
  (let (
    (days-lived (calculate-days-since-birth birth-date current-date))
  )
    {
      days-lived: days-lived,
      physical-position: (calculate-cycle-position days-lived PHYSICAL_CYCLE),
      emotional-position: (calculate-cycle-position days-lived EMOTIONAL_CYCLE),
      intellectual-position: (calculate-cycle-position days-lived INTELLECTUAL_CYCLE)
    }
  )
)

;; Get optimal timing recommendations
(define-read-only (get-timing-recommendations (user principal) (birth-date uint) (target-date uint))
  (let (
    (cycle-positions (get-current-cycle-positions birth-date target-date))
    (physical-pos (get physical-position cycle-positions))
    (emotional-pos (get emotional-position cycle-positions))
    (intellectual-pos (get intellectual-position cycle-positions))
  )
    {
      best-for-physical: (>= physical-pos u75),
      best-for-creative: (>= emotional-pos u75),
      best-for-mental: (>= intellectual-pos u75),
      overall-favorable: (>= (+ physical-pos emotional-pos intellectual-pos) u180)
    }
  )
)

;; Get total statistics
(define-read-only (get-analysis-stats)
  {
    total-analyses: (var-get total-analyses),
    total-predictions: (var-get total-predictions)
  }
)


;; title: biorhythm-analyzer
;; version:
;; summary:
;; description:

;; traits
;;

;; token definitions
;;

;; constants
;;

;; data vars
;;

;; data maps
;;

;; public functions
;;

;; read only functions
;;

;; private functions
;;

