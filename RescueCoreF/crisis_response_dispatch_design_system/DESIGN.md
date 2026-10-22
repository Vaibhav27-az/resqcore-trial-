---
name: Crisis Response & Dispatch Design System
colors:
  surface: '#0c1421'
  surface-dim: '#0c1421'
  surface-bright: '#323948'
  surface-container-lowest: '#070e1b'
  surface-container-low: '#141c29'
  surface-container: '#18202d'
  surface-container-high: '#222a38'
  surface-container-highest: '#2d3543'
  on-surface: '#dbe2f5'
  on-surface-variant: '#c3c6d7'
  inverse-surface: '#dbe2f5'
  inverse-on-surface: '#29313f'
  outline: '#8d90a0'
  outline-variant: '#434655'
  surface-tint: '#b4c5ff'
  primary: '#b4c5ff'
  on-primary: '#002a78'
  primary-container: '#2563eb'
  on-primary-container: '#eeefff'
  inverse-primary: '#0053db'
  secondary: '#adc6ff'
  on-secondary: '#002e6a'
  secondary-container: '#0566d9'
  on-secondary-container: '#e6ecff'
  tertiary: '#ffb95f'
  on-tertiary: '#472a00'
  tertiary-container: '#996100'
  on-tertiary-container: '#ffeedd'
  error: '#ffb4ab'
  on-error: '#690005'
  error-container: '#93000a'
  on-error-container: '#ffdad6'
  primary-fixed: '#dbe1ff'
  primary-fixed-dim: '#b4c5ff'
  on-primary-fixed: '#00174b'
  on-primary-fixed-variant: '#003ea8'
  secondary-fixed: '#d8e2ff'
  secondary-fixed-dim: '#adc6ff'
  on-secondary-fixed: '#001a42'
  on-secondary-fixed-variant: '#004395'
  tertiary-fixed: '#ffddb8'
  tertiary-fixed-dim: '#ffb95f'
  on-tertiary-fixed: '#2a1700'
  on-tertiary-fixed-variant: '#653e00'
  background: '#0c1421'
  on-background: '#dbe2f5'
  surface-variant: '#2d3543'
typography:
  headline-xl:
    fontFamily: Plus Jakarta Sans
    fontSize: 32px
    fontWeight: '700'
    lineHeight: 40px
    letterSpacing: -0.02em
  headline-xl-mobile:
    fontFamily: Plus Jakarta Sans
    fontSize: 26px
    fontWeight: '700'
    lineHeight: 34px
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 24px
    fontWeight: '700'
    lineHeight: 32px
    letterSpacing: -0.015em
  headline-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 20px
    fontWeight: '600'
    lineHeight: 28px
    letterSpacing: -0.01em
  headline-sm:
    fontFamily: Plus Jakarta Sans
    fontSize: 18px
    fontWeight: '600'
    lineHeight: 24px
    letterSpacing: 0em
  body-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
    letterSpacing: 0em
  body-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
    letterSpacing: 0em
  body-sm:
    fontFamily: Plus Jakarta Sans
    fontSize: 12px
    fontWeight: '400'
    lineHeight: 16px
    letterSpacing: 0.01em
  label-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 15px
    fontWeight: '600'
    lineHeight: 20px
    letterSpacing: -0.005em
  label-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 13px
    fontWeight: '600'
    lineHeight: 18px
    letterSpacing: 0.01em
  label-sm:
    fontFamily: Plus Jakarta Sans
    fontSize: 11px
    fontWeight: '600'
    lineHeight: 14px
    letterSpacing: 0.04em
  code-num:
    fontFamily: Plus Jakarta Sans
    fontSize: 24px
    fontWeight: '700'
    lineHeight: 28px
    letterSpacing: 0.05em
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
  space-lg: 1.5rem
  space-xl: 2rem
---

## Brand & Style

This design system is tailored for high-stakes emergency situations, citizen rescue coordination, and incident management. The interface instills calm, absolute clarity, and swift decisiveness under pressure. It bridges citizens in distress with emergency command centers, demanding zero ambiguity, high glanceability, and accessible contrast in low-light and adverse field conditions.

### Design Movement
The visual language blends **Tactical Modernism** with **Disciplined Utilitarianism**:
- **Tactical Foundations:** A deep nocturnal base layer minimizing glare, conserving battery during critical scenarios, and framing urgent signals cleanly.
- **Signal-Forward Hierarchy:** Emergency blue interactive triggers, high-visibility amber advisory banners, vibrant green verification confirmations, and crimson red incident tags stand out instantly against slate surfaces.
- **Clarity Under Stress:** Generous touch targets, high contrast borders, clear status chips, and readable sans-serif typography built for trembling hands and rapid decisions.

## Colors

The palette uses a deliberate hierarchy where color strictly conveys actionability, severity, and confirmation. Non-interactive chrome remains muted in deep navy-slate tones so critical status indicators immediately capture attention.

### Core Canvas & Surface Tokens
- **Background (`#0B1320`):** Ultra-deep slate foundation for full-screen immersive contrast.
- **Surface Container Base (`#0E1726`):** Primary canvas tier for list views and general layouts.
- **Surface Container Low (`#162238`):** Card modules, input containers, and tactical panels.
- **Surface Container High (`#1E293B`):** Hovered controls, segmented tab backdrops, and active item highlights.
- **Surface Stroke / Border (`#1E293B` to `#334155`):** Subtle boundaries separating high-density data.

### Functional & Signal Accents
- **Primary Action Electric Blue (`#2563EB` / `#3B82F6`):** Dedicated to critical primary actions ("Report Emergency", "Continue", "Verify Code").
- **Warning & Advisory Amber (`#F59E0B` / `#D97706`):** Dedicated to proximity hazards, flood alerts, and pending assignment statuses. Paired with dark warm amber containers (`rgba(245, 158, 11, 0.12)`).
- **Life Safety & Danger Crimson (`#EF4444` / `#DC2626`):** Dedicated to high-risk warnings, critical emergency types, and field validation errors. Paired with dark crimson backdrops (`rgba(239, 68, 68, 0.12)`).
- **Resolution & Verified Emerald (`#10B981` / `#059669`):** Dedicated to dispatched milestones, successful submissions, and active GPS locks.

### Content & Typography Contrast
- **Text Primary (`#F8FAFC`):** Pure readability for headlines, key values, and critical instructions.
- **Text Secondary (`#94A3B8`):** Supporting metadata, time stamps, and field subtext.
- **Text Tertiary (`#64748B`):** Placeholder labels, inactive icons, and structural breadcrumb indicators.

## Typography

The design system standardizes on **Plus Jakarta Sans** across all tiers to provide crisp legibility, open apertures, and modern warmth without sacrificing geometric balance. 

### Typographic Principles
- **Direct Tone:** Headlines are concise, bold, and authoritative, directly communicating the immediate action required ("Let's keep you safe", "Where is help needed?").
- **High-Distress Legibility:** Letter tracking stays neutral or slightly tightened for titles, while status indicators and data codes use expanded letter spacing for quick scanning.
- **Tabular Numerics:** Incident identifiers (e.g. `RQ-261010-0842`), time codes, OTP digits, and coordinates maintain consistent horizontal visual alignment.

## Layout & Spacing

Layouts adhere to an 8pt spatial grid with a primary focus on mobile hand reach, thumb accessibility, and fast downward scanning.

### Layout Rhythm & Grids
- **Mobile Foundation:** 4-column fluid mobile grid with 16px margins (`1rem`) and 16px gutters (`1rem`). On compact screens under 360px width, outer margins flex down to 12px.
- **Safe Areas & Action Zone:** Critical emergency CTAs ("Report Emergency", "Submit emergency report") sit anchored within the persistent thumb action zone at the bottom edge, elevated above system home indicators.
- **Section Rhythm:** Group related incident steps using `space-md` (16px) or `space-sm` (8px). Use `space-lg` (24px) to separate disparate tactical sections (e.g., separating the active warning banner from latest status cards).
- **Responsive Stacking:** On larger viewports (tablets or dispatch dashboards), the single mobile stream splits into a dual-pane master-detail configuration with a 12-column layout, 24px gutters, and 32px margins.

## Elevation & Depth

To avoid visual distortion during emergency situations, elevation uses **tonal layer stepping** paired with **crisp low-contrast outlines** rather than heavy drop shadows.

### Surface Tiers
- **Canvas (Level 0):** `#0B1320` base background layer.
- **Inset Wells (Level 0.5):** `#090E17` with subtle inner border, used for inactive segmented track holders, search inputs, and OTP boxes.
- **Contained Modules (Level 1):** `#162238` with a 1px continuous stroke of `#1E293B`. Used for alert cards, incident reports, and prompt groups.
- **Floating Overlays & Sheets (Level 2):** `#162238` background with an ambient glow (`box-shadow: 0 12px 32px rgba(0, 0, 0, 0.45)`), accompanied by a border stroke of `#334155`.
- **Emergency Priority Nodes (Level 3):** `#2563EB` button triggers incorporate a subtle matching blue radial edge (`box-shadow: 0 4px 20px rgba(37, 99, 235, 0.35)`), guiding immediate focus.

## Shapes

The interface balances soft technical contours with approachable geometry to keep dense operational data comfortable to scan.

### Corner Radius System
- **Pills / Fully Rounded (`rounded-full`):** Filter tags, status badges (`In progress`, `Pending`, `Resolved`), step indicator chips, and small avatar nodes.
- **Primary Buttons & Field Inputs (`rounded-lg` / 12px–16px):** Action triggers, OTP entry boxes, and text inputs use confident 12px corners for clear tap targets.
- **Cards & Banners (`rounded-xl` / 16px–20px):** Information modules, emergency warnings, and live map view containers use 16px to 20px radii, creating clear visual groups.

## Components

### Buttons
- **Primary CTA:** Solid Electric Blue (`#2563EB` to `#3B82F6`), full-width on mobile (height 52px), featuring white medium-weight typography with leading or trailing iconography (e.g., `+`, `->`). Provides a subtle electric aura on tap.
- **Secondary / Ghost:** Transparent surface with a 1px border (`#334155`), filled with slate background on hover/press. White or light slate text.
- **Destructive / Emergency Direct:** High-contrast crimson container (`rgba(239, 68, 68, 0.15)`) with crimson border (`#EF4444`) and text for calling local emergency dispatch (112 / 911).

### Status Badges & Chips
- **Status Tags:** Pill-shaped capsules with an 8px circular dot and `label-sm` text.
  - *In Progress / Active:* Navy background (`rgba(59, 130, 246, 0.15)`), Electric Blue dot & text (`#60A5FA`).
  - *Pending / Queued:* Dark Amber background (`rgba(245, 158, 11, 0.15)`), Amber dot & text (`#FBBF24`).
  - *Resolved / Safe:* Dark Emerald background (`rgba(16, 185, 129, 0.15)`), Emerald dot & text (`#34D399`).
  - *High Risk / Hazard:* Crimson background (`rgba(239, 68, 68, 0.15)`), Crimson dot & text (`#F87171`).
- **Interactive Segmented Pills:** Track container in `#0E1726` with 4px inner padding. Selected segment sits on `#1E293B` or `#2563EB` with bold white text.

### Cards & Warning Banners
- **Incident Summary Cards:** `#162238` surface, 1px `#1E293B` border, 16px padding. Left-aligned title with right-aligned status chip; subtext includes tracking ID, location metadata, and a forward navigation chevron.
- **Warning Advisory Banners:** Amber accent bar or soft background (`rgba(245, 158, 11, 0.08)`), outlined with `#F59E0B` at 30% opacity. Displays warning hazard icon, alert title, concise safety instruction, and optional text chevron.

### Form Inputs & OTP Verification
- **Text Inputs:** Dark slate wells (`#0E1726`), 1px `#1E293B` border, 14px horizontal padding, 48px height. Focus transitions border to `#3B82F6` with a soft blue outer ring.
- **OTP Code Boxes:** High-contrast square cells (48px–56px wide) with centered `code-num` typography. Error state shifts the border to `#EF4444` and shows a crimson warning callout beneath.

### Navigation Bar
- **Bottom Navigation Bar:** Grounded in `#0B1320` with a top 1px border (`#1E293B`). Accommodates 4 primary hubs: **Home**, **Requests**, **Alerts**, and **Inbox**.
- **Active State:** Active icon and text highlight in vibrant Electric Blue (`#3B82F6`). Inactive icons rest in muted slate (`#64748B`). Unread counts appear as small numeric badges or dots.