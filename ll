Ivygo EV Charging App — Design Context
About the app

App name: Ivygo
Category: EV (Electric Vehicle) charging network app
Market: Australia & New Zealand (phone format uses 🇦🇺 +61)
Account types: Resident and Business

Brand

Logo: Ivygo — leaf/flower icon + wordmark (see uploaded logo)
Primary brand color: #02ad8d (teal-green)
Logo background: Black in the original logo file

Full color token system
Shared (both themes)

Primary: #02ad8d
Primary dark: #017a64
Primary darker: #015a4a
Amber accent (charging/cost): #F5A623
Danger/stop: #E84040

Light mode

Page bg: #f4f8f6 / #FAFAF8
Card bg: #ffffff
Surface: #f0f7f4
Teal surface: #eafaf7
Teal light tint: #d0f5ee
Text primary: #0f1f1a
Text muted: #5a7a70
Text hint: #9ab8ae
Border: rgba(0,0,0,0.08)
Border focus: #02ad8d

Dark mode

Page bg: #0d1210
Card bg: #1C1E1C
Surface: #1e2822
Surface 2: #243028
Teal surface: #1a3d35
Teal xlight: rgba(2,173,141,0.08)
Text primary: #f0f4f2
Text muted: #8fa89e
Text hint: #5a7069
Border: rgba(255,255,255,0.07)
Border focus: #02ad8d

Typography

Font: Roboto (Google Fonts)
Weights used: 300, 400, 500, 600
Scale:

Wordmark: 22–26px / 600 / color #02ad8d
Screen heading: 19px / 600 / letter-spacing -0.03em
Body: 14px / 400
Form labels: 11px / 500
Inputs: 11px / 400
Captions / section labels: 9–10px / 500 / uppercase / letter-spacing 0.08em

UI component rules

Border radius: 10–12px for inputs, 12–14px for buttons, 14px for cards, 36px for phone frame
Input style: Subtle border (rgba(0,0,0,0.08)) at rest → teal border + teal xlight bg when focused
Primary button: Full width, #02ad8d bg, white text, 600 weight, 12–13px
Outline button: Transparent bg, #02ad8d border and text
Danger button: #E84040 bg (used for Stop Charging)
Social buttons: Side by side (Google + Apple), bg2 surface, subtle border
Account type selector: Pill tabs (not dropdown) — active tab fills #02ad8d
Step progress: Horizontal dots/pills — active is wider (28px) and teal, inactive is narrow (18px) and border-colored
Nav bar: Back chevron in a small rounded square button, no heavy header bar
Status bar: Native-style, no colored background

Status badge system

Available: bg #d0f5ee / text #015a4a
Charging: bg #FEF3DC / text #9A6200
Busy: bg #FFE8E8 / text #C0392B
Charger type pill: bg #eafaf7 / text #02ad8d

Reference designs used for inspiration

Two reference sets shared: one dark mode, one light mode (from an EV charging UI kit)
Borrowed from reference:

Deep near-black surfaces (not pure black) for dark mode
Full-bleed map with floating bottom sheet
Circular ring progress for charging %
Icon-only bottom tab bar (4 tabs)
Bold % number on charging screen
Compact list rows for history

Improved vs reference:

Replaced generic neon green with Ivygo #02ad8d
Removed glow/neon effects — cleaner and more premium
Warmer off-white instead of stark white in light mode
Native-style status bar instead of colored bar

Screens completed so far
#ScreenStatus1Splash✅ Done (light + dark)2Sign in✅ Done (light + dark)3Create account✅ Done (light + dark)
Screens remaining (planned)
#Screen4Home / Map5Station detail6Connector select7QR scan8Active charging session9Session summary10Wallet11Top-up / Add money12Session history13Profile14Add vehicle15Notifications16Settings
Original screens shared by user

Sign in screen (current build) — teal status bar, logo centered, email + password form, remember email checkbox, sign in button, sign up link
Create account screen (current build) — teal header with logo, dropdown for account type (Resident/Business), full name, email, mobile with country code, password, confirm password

Design philosophy for Ivygo

Clean, premium, not overly "eco-branded"
Teal used as a functional accent, not decoration
Dark mode uses deep forest-tinted blacks (not gray)
Both themes feel like siblings — same layout structure, just different surface colors
Every screen should work in both light and dark — design both together

Tools / workflow

Designing in Claude chat using the Visualizer tool (HTML widget mockups)
Side-by-side light + dark for every screen
DM Sans loaded via Google Fonts CDN in each widget
User may continue in Antigravity or another tool — this context doc is the handoff



