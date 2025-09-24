;; Biorhythm Tracker Smart Contract
;; Tracks and manages biorhythm measurements for users

;; Constants
(define-constant CONTRACT_OWNER tx-sender)
(define-constant ERR_UNAUTHORIZED (err u1))
(define-constant ERR_INVALID_MEASUREMENT (err u2))
(define-constant ERR_USER_NOT_FOUND (err u3))
(define-constant ERR_INVALID_DATE (err u4))
(define-constant ERR_MEASUREMENT_EXISTS (err u5))
(define-constant MAX_MEASUREMENT_VALUE u100)
(define-constant MIN_MEASUREMENT_VALUE u0)

;; Data structures
(define-map user-profiles 
  { user: principal }
  { 
    birth-date: uint,
    created-at: uint,
    total-measurements: uint,
    is-active: bool
  }
)

(define-map daily-measurements
  { user: principal, date: uint }
  {
    physical: uint,
    emotional: uint, 
    intellectual: uint,
    recorded-at: uint,
    notes: (string-ascii 256)
  }
)

(define-map user-statistics
  { user: principal }
  {
    avg-physical: uint,
    avg-emotional: uint,
    avg-intellectual: uint,
    last-update: uint,
    streak-days: uint
  }
)

;; Data variables
(define-data-var total-users uint u0)
(define-data-var total-measurements uint u0)

;; Helper functions
(define-private (is-valid-measurement (value uint))
  (and 
    (>= value MIN_MEASUREMENT_VALUE)
    (<= value MAX_MEASUREMENT_VALUE)
  )
)

(define-private (is-valid-date (date uint))
  (> date u0)
)

(define-private (calculate-average (total uint) (count uint))
  (if (> count u0)
    (/ total count)
    u0
  )
)

;; Public functions

;; Register a new user profile
(define-public (register-user (birth-date uint))
  (let (
    (user tx-sender)
    (current-time (unwrap-panic (get-stacks-block-info? time (- stacks-block-height u1))))
  )
    (asserts! (is-valid-date birth-date) ERR_INVALID_DATE)
    (asserts! (is-none (map-get? user-profiles { user: user })) ERR_UNAUTHORIZED)
    
    (map-set user-profiles 
      { user: user }
      {
        birth-date: birth-date,
        created-at: current-time,
        total-measurements: u0,
        is-active: true
      }
    )
    
    (map-set user-statistics
      { user: user }
      {
        avg-physical: u0,
        avg-emotional: u0,
        avg-intellectual: u0,
        last-update: current-time,
        streak-days: u0
      }
    )
    
    (var-set total-users (+ (var-get total-users) u1))
    (ok true)
  )
)

;; Record daily biorhythm measurement
(define-public (record-daily-measurement (date uint) (physical uint) (emotional uint) (intellectual uint) (notes (string-ascii 256)))
  (let (
    (user tx-sender)
    (current-time (unwrap-panic (get-stacks-block-info? time (- stacks-block-height u1))))
    (existing-profile (unwrap! (map-get? user-profiles { user: user }) ERR_USER_NOT_FOUND))
  )
    ;; Validate inputs
    (asserts! (is-valid-date date) ERR_INVALID_DATE)
    (asserts! (is-valid-measurement physical) ERR_INVALID_MEASUREMENT)
    (asserts! (is-valid-measurement emotional) ERR_INVALID_MEASUREMENT)
    (asserts! (is-valid-measurement intellectual) ERR_INVALID_MEASUREMENT)
    (asserts! (is-none (map-get? daily-measurements { user: user, date: date })) ERR_MEASUREMENT_EXISTS)
    
    ;; Record the measurement
    (map-set daily-measurements
      { user: user, date: date }
      {
        physical: physical,
        emotional: emotional,
        intellectual: intellectual,
        recorded-at: current-time,
        notes: notes
      }
    )
    
    ;; Update user profile
    (map-set user-profiles
      { user: user }
      (merge existing-profile { total-measurements: (+ (get total-measurements existing-profile) u1) })
    )
    
    ;; Update global counter
    (var-set total-measurements (+ (var-get total-measurements) u1))
    
    ;; Update user statistics
    (update-user-statistics user)
    
    (ok true)
  )
)

;; Update user statistics (private function)
(define-private (update-user-statistics (user principal))
  (let (
    (profile (unwrap-panic (map-get? user-profiles { user: user })))
    (measurement-count (get total-measurements profile))
  )
    (if (> measurement-count u0)
      (let (
        (avg-physical (calculate-user-average user "physical"))
        (avg-emotional (calculate-user-average user "emotional"))
        (avg-intellectual (calculate-user-average user "intellectual"))
        (current-time (unwrap-panic (get-stacks-block-info? time (- stacks-block-height u1))))
      )
        (map-set user-statistics
          { user: user }
          {
            avg-physical: avg-physical,
            avg-emotional: avg-emotional, 
            avg-intellectual: avg-intellectual,
            last-update: current-time,
            streak-days: (calculate-streak-days user)
          }
        )
        true
      )
      false
    )
  )
)

;; Calculate average for a specific measurement type
(define-private (calculate-user-average (user principal) (measurement-type (string-ascii 20)))
  ;; Simplified calculation - in practice would iterate through measurements
  u50 ;; Placeholder average
)

;; Calculate consecutive days streak
(define-private (calculate-streak-days (user principal))
  ;; Simplified calculation - would check consecutive dates
  u1 ;; Placeholder streak
)

;; Read-only functions

;; Get user profile
(define-read-only (get-user-profile (user principal))
  (map-get? user-profiles { user: user })
)

;; Get daily measurement
(define-read-only (get-daily-measurement (user principal) (date uint))
  (map-get? daily-measurements { user: user, date: date })
)

;; Get user statistics  
(define-read-only (get-user-statistics (user principal))
  (map-get? user-statistics { user: user })
)

;; Get total users
(define-read-only (get-total-users)
  (var-get total-users)
)

;; Get total measurements
(define-read-only (get-total-measurements)
  (var-get total-measurements)
)

;; Check if user exists
(define-read-only (user-exists (user principal))
  (is-some (map-get? user-profiles { user: user }))
)

;; Get measurement history summary
(define-read-only (get-measurement-summary (user principal))
  (match (map-get? user-profiles { user: user })
    profile (some {
      total-measurements: (get total-measurements profile),
      created-at: (get created-at profile),
      birth-date: (get birth-date profile),
      is-active: (get is-active profile)
    })
    none
  )
)


;; title: biorhythm-tracker
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

