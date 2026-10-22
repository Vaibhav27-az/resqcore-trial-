---
name: Tactical Emergency Operations
colors:
  surface: '#0b1326'
  surface-dim: '#0b1326'
  surface-bright: '#31394d'
  surface-container-lowest: '#060e20'
  surface-container-low: '#131b2e'
  surface-container: '#171f33'
  surface-container-high: '#222a3d'
  surface-container-highest: '#2d3449'
  on-surface: '#dae2fd'
  on-surface-variant: '#c2c6d6'
  inverse-surface: '#dae2fd'
  inverse-on-surface: '#283044'
  outline: '#8c909f'
  outline-variant: '#424754'
  surface-tint: '#adc6ff'
  primary: '#adc6ff'
  on-primary: '#002e6a'
  primary-container: '#4d8eff'
  on-primary-container: '#00285d'
  inverse-primary: '#005ac2'
  secondary: '#ffb3ad'
  on-secondary: '#68000a'
  secondary-container: '#a40217'
  on-secondary-container: '#ffaea8'
  tertiary: '#4edea3'
  on-tertiary: '#003824'
  tertiary-container: '#00a572'
  on-tertiary-container: '#00311f'
  error: '#ffb4ab'
  on-error: '#690005'
  error-container: '#93000a'
  on-error-container: '#ffdad6'
  primary-fixed: '#d8e2ff'
  primary-fixed-dim: '#adc6ff'
  on-primary-fixed: '#001a42'
  on-primary-fixed-variant: '#004395'
  secondary-fixed: '#ffdad7'
  secondary-fixed-dim: '#ffb3ad'
  on-secondary-fixed: '#410004'
  on-secondary-fixed-variant: '#930013'
  tertiary-fixed: '#6ffbbe'
  tertiary-fixed-dim: '#4edea3'
  on-tertiary-fixed: '#002113'
  on-tertiary-fixed-variant: '#005236'
  background: '#0b1326'
  on-background: '#dae2fd'
  surface-variant: '#2d3449'
typography:
  display:
    fontFamily: Inter
    fontSize: 32px
    fontWeight: '700'
    lineHeight: 40px
  headline-lg:
    fontFamily: Inter
    fontSize: 24px
    fontWeight: '700'
    lineHeight: 32px
  headline-md:
    fontFamily: Inter
    fontSize: 20px
    fontWeight: '600'
    lineHeight: 28px
  headline-sm:
    fontFamily: Inter
    fontSize: 18px
    fontWeight: '600'
    lineHeight: 24px
  title-md:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '600'
    lineHeight: 22px
  body-lg:
    fontFamily: Inter
    fontSize: 15px
    fontWeight: '400'
    lineHeight: 22px
  body-md:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
  body-sm:
    fontFamily: Inter
    fontSize: 12px
    fontWeight: '400'
    lineHeight: 16px
  label-lg:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '600'
    lineHeight: 18px
  label-md:
    fontFamily: Inter
    fontSize: 12px
    fontWeight: '600'
    lineHeight: 16px
  label-sm:
    fontFamily: Inter
    fontSize: 11px
    fontWeight: '600'
    lineHeight: 14px
  metric-stat:
    fontFamily: Inter
    fontSize: 28px
    fontWeight: '700'
    lineHeight: 34px
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  gutter: 1rem
  margin: 1rem
  space-xs: 0.25rem
  space-sm: 0.5rem
  space-md: 1rem
  space-lg: 1.25rem
  space-xl: 1.5rem
---

## Brand & Style

The design system establishes a mission-critical, high-urgency operations interface crafted specifically for emergency response coordinators, volunteer search-and-rescue teams, and individuals in distress. The emotional mandate demands calm authority, split-second visual clarity, situational awareness, and uncompromised dependability under intense cognitive load.

The visual direction combines **Tactical Modernism** with purposeful **High-Contrast Dark Surface Architecture**. Rather than decorative styling, elements prioritize scanning velocity: deep light-absorbing navy and charcoal canvases prevent screen glare during nocturnal or alpine field missions, while calibrated signal colors—electric action blue, severe alert red, warning amber, and operational emerald—instantly communicate severity, triaging status, and deployment lifecycles.

## Colors

The palette operates in strict dark mode, anchored by deep slate-navy and midnight layers that absorb glare in field operations while rendering status lights and warnings with maximum visual contrast.

- **Primary Action (`#3b82f6`):** Electric Blue for verified assignments, standard CTA triggers, map vectors, and active navigation nodes.
- **Urgent / Emergency (`#ef4444`):** Emergency Crimson Red for SOS triggers, severe flood/landslide alerts, high-risk status tags, and emergency calling.
- **Operational Standby (`#10b981`):** Field Emerald Green for team verification badges, active on-route status, and live GPS connectivity indicators.
- **Warning / Medium Priority (`#f59e0b`):** Tactical Amber for moderate risk notices, unassigned escalations, and weather caution cards.
- **Canvases & Surfaces:**
  - Base canvas: `#0a1120` to `#0f172a`
  - Elevated tactical containers: `#151f32` and `#1e293b`
  - Subtle architectural borders: `#1e293b` to `#334155`
  - High-priority banner tints: Deep crimson (`rgba(239, 68, 68, 0.12)`) and deep amber (`rgba(245, 158, 11, 0.10)`)
- **Text & Foreground:**
  - Primary text: `#f8fafc` (high readability)
  - Secondary metadata: `#94a3b8`
  - Tertiary / disabled: `#64748b`

## Typography

The design system employs **Inter** exclusively across all scales to mirror military and aviation heads-up displays: ultra-clean glyph shapes, tabular numeric stability, and immediate clarity at small sizes.

- Numerical telemetry and field stats (`247`, `12`, `3`) utilize `metric-stat` with semi-tabular figures to avoid jitter in dynamic counters.
- Sub-labels and category trackers (`RATING`, `CONNECTED NEARBY`, `ACTIVE INCIDENTS`) are styled in `label-sm` or `body-sm` with slight uppercase tracking (`+0.04em`) when distinguishing auxiliary mission parameters.
- Text contrast must consistently exceed WCAG AAA standards for critical advisory bodies, maintaining crisp foreground white `#f8fafc` over dark background layers.

## Layout & Spacing

A compact, fluid layout rhythm optimized for single-handed mobile operational use (390px base width, scaling cleanly from 360px to 428px viewports).

- **Screen Margins:** Fixed `1rem` (16px) left/right margins maximize operational canvas while preventing edge clipping on ruggedized handheld casings.
- **Section Rhythm:** `1.25rem` to `1.5rem` between functional card groups; `0.75rem` between stacked tactical modules within identical domains.
- **Tactical Grid:** 2-column symmetric grids for KPI clusters (`Active Incidents`, `Rescue Teams`, `People in Need`, `Your Location`) separated by `gutter` (`1rem`). Quick action buttons sit across a 4-column balanced grid with `0.5rem` gap for quick thumb tapping.
- **Bottom Navigation Safe Zone:** Fixed 64px navigation height plus device safe area margin (`env(safe-area-inset-bottom)`), elevating actionable elements out of thumb-swipe interference.

## Elevation & Depth

Visual depth is achieved through **tonal container layering** and **tactical hairline boundaries** rather than standard drop shadows:

- **Base Field Layer (Z0):** Deepest canvas (`#0a1120` to `#0f172a`), completely flat.
- **Tactical Card Container (Z1):** Mid-tone fill (`#151f32` or `#131d2e`) with a 1px structural hairline border in `#1e293b` or `#27354a`.
- **Selected & Interactive Surface (Z2):** Highlights and inner cards (`#1e293b`), accented with high-contrast colored borders (e.g., `#10b981` 1px border for active team verification units).
- **Floating Modals & Sheets (Z3):** Dark charcoal surfaces supported by a controlled, tinted ambient glow (`0 8px 24px rgba(0, 0, 0, 0.45)`).
- **SOS Critical State:** High-visibility pulsing radial glow (`box-shadow: 0 0 40px rgba(239, 68, 68, 0.35)`) highlighting immediate emergency triggers.

## Shapes

The design system standardizes on a controlled, rounded corner profile (Level 2: `0.5rem` base, scaling to `1rem` for major cards and modals), balancing rugged equipment solidity with modern touch-screen ergonomical friendliness.

- **Standard Cards & Input Fields:** `rounded-lg` (`1rem` / 16px) to hold content securely and create distinct card silos.
- **Buttons & Control Tiles:** `0.75rem` (12px) for solid interactive grip.
- **Badges, Filters & Status Pills:** Full-pill roundness (`9999px` / capsule shape) for instant distinction between dynamic classification filters and rectangular cards.
- **Avatars & Critical Action Triggers:** Circles (`50%` radius) for responder avatars and concentric SOS alert buttons.

## Components

### Buttons
- **Primary Action Button:** Full-width `#3b82f6` with `#ffffff` text, 48px height for tactical gloves/one-handed touch, `rounded-lg` (12px), font weight 600.
- **Critical Action (SOS / Call 112):** Vibrant `#ef4444` solid fill with bright white text and active state darkening to `#dc2626`.
- **Secondary / Ghost Button:** Dark slate surface (`#1e293b`) with 1px border (`#334155`), text in `#f8fafc`.
- **SOS Pulse Orb:** Concentric rounded button with red target rings, large centered phone/SOS icon, and 3-second hold gesture feedback.

### Status Pills & Filter Chips
- **Urgent / High:** Dark crimson background (`rgba(239, 68, 68, 0.2)`), `#f87171` text, dot indicator (`#ef4444`).
- **Warning / Medium:** Deep amber background (`rgba(245, 158, 11, 0.2)`), `#fbbf24` text, amber dot indicator.
- **Verified / On Route:** Subtle emerald background (`rgba(16, 185, 129, 0.2)`), `#34d399` text, green check or dot.
- **Filter Segmented Control:** Full-width rounded container `#131d2e` housing pill segments that toggle between inactive transparent slate and active deep navy `#1e293b`.

### Tactical Cards
- **Telemetry KPI Tiles:** 2-column cards containing metric icon top-right, bold numerical readout (`28px`), and descriptive subtitle.
- **Alert Banners:** Top-level warning container with dark-red or dark-amber wash, alert triangle glyph, headline, and contextual navigation arrow.
- **Team Assignment Module:** Dark slate card encased in an emerald `1px` border, containing check icon, team name, ETA badge, and dismissal trigger.

### Input Fields & Search
- Integrated slate background (`#0f172a` inside `#151f32` wrappers) with a clear `1px` border in `#1e293b`.
- Search inputs include high-contrast search icons (`#64748b`), placeholder text in `#94a3b8`, and clear focus rings in `#3b82f6`.

### Bottom Navigation Bar
- High-contrast, dark navy fixed bottom bar (`#0b1322`) with hairline top divider (`#1e293b`).
- 5 fixed icon-and-label tabs (`Home`, `Map`, `Incidents`, `Teams`, `Profile`). Active item highlighted in electric `#3b82f6`; inactive items rendered in `#64748b`.