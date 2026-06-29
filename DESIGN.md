---
name: Cinematic Immersive
colors:
  surface: '#131313'
  surface-dim: '#131313'
  surface-bright: '#3a3939'
  surface-container-lowest: '#0e0e0e'
  surface-container-low: '#1c1b1b'
  surface-container: '#201f1f'
  surface-container-high: '#2a2a2a'
  surface-container-highest: '#353534'
  on-surface: '#e5e2e1'
  on-surface-variant: '#d3c5ac'
  inverse-surface: '#e5e2e1'
  inverse-on-surface: '#313030'
  outline: '#9b8f79'
  outline-variant: '#4f4633'
  surface-tint: '#f7be1d'
  primary: '#ffd165'
  on-primary: '#3f2e00'
  primary-container: '#eab308'
  on-primary-container: '#604700'
  inverse-primary: '#785a00'
  secondary: '#ddb7ff'
  on-secondary: '#490080'
  secondary-container: '#6f00be'
  on-secondary-container: '#d6a9ff'
  tertiary: '#7ee5ff'
  on-tertiary: '#003640'
  tertiary-container: '#3bcbea'
  on-tertiary-container: '#005261'
  error: '#ffb4ab'
  on-error: '#690005'
  error-container: '#93000a'
  on-error-container: '#ffdad6'
  primary-fixed: '#ffdf9a'
  primary-fixed-dim: '#f7be1d'
  on-primary-fixed: '#251a00'
  on-primary-fixed-variant: '#5a4300'
  secondary-fixed: '#f0dbff'
  secondary-fixed-dim: '#ddb7ff'
  on-secondary-fixed: '#2c0051'
  on-secondary-fixed-variant: '#6900b3'
  tertiary-fixed: '#acedff'
  tertiary-fixed-dim: '#4cd7f6'
  on-tertiary-fixed: '#001f26'
  on-tertiary-fixed-variant: '#004e5c'
  background: '#131313'
  on-background: '#e5e2e1'
  surface-variant: '#353534'
typography:
  display-lg:
    fontFamily: Sora
    fontSize: 48px
    fontWeight: '800'
    lineHeight: 56px
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: Sora
    fontSize: 32px
    fontWeight: '700'
    lineHeight: 40px
    letterSpacing: -0.01em
  headline-lg-mobile:
    fontFamily: Sora
    fontSize: 24px
    fontWeight: '700'
    lineHeight: 32px
  headline-md:
    fontFamily: Sora
    fontSize: 24px
    fontWeight: '600'
    lineHeight: 32px
  title-lg:
    fontFamily: Manrope
    fontSize: 20px
    fontWeight: '600'
    lineHeight: 28px
  body-lg:
    fontFamily: Manrope
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  body-md:
    fontFamily: Manrope
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
  label-md:
    fontFamily: Manrope
    fontSize: 12px
    fontWeight: '600'
    lineHeight: 16px
    letterSpacing: 0.05em
  label-sm:
    fontFamily: Manrope
    fontSize: 10px
    fontWeight: '700'
    lineHeight: 12px
    letterSpacing: 0.08em
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  base: 8px
  xs: 4px
  sm: 12px
  md: 24px
  lg: 40px
  xl: 64px
  container-margin: 20px
  gutter: 16px
---

## Brand & Style

This design system is built for a premium, high-end cinema experience. It prioritizes immersion, treating the mobile interface as a digital extension of the theater itself. The personality is sophisticated, atmospheric, and cinematic, targeting film enthusiasts who value a curated and high-fidelity aesthetic.

The visual style is a blend of **Minimalism** and **Glassmorphism**. By using deep, dark backgrounds, movie posters are allowed to "bleed" into the interface, while interactive elements sit on frosted, translucent layers. This creates a sense of depth and focus, ensuring the content (the film) is always the hero, while the UI remains a sleek, unobtrusive guide.

## Colors

The palette is rooted in a "Deep Cinema" dark mode. The primary background is nearly pitch-black to maximize OLED contrast and minimize distraction. 

- **Primary (Gold):** Used for primary CTAs (e.g., "Buy Tickets"), gold signifies a "premium" or "VIP" status.
- **Neutrals:** A range of charcoal grays are used to create structural hierarchy without breaking the dark immersion.
- **Accents:** Neon secondary and tertiary colors are used sparingly for status indicators (e.g., genre tags, IMDB ratings).
- **Glass:** Surface layers use low-opacity whites with high background blur (20px+) to create the glassmorphic effect seen in the reference.

## Typography

The typography system utilizes **Sora** for headlines to provide a modern, geometric, and slightly futuristic feel that echoes high-tech cinema displays. **Manrope** is used for body text and UI labels due to its exceptional legibility and balanced proportions, ensuring that movie synopses and showtimes are easy to read.

Key titles should use high-contrast weights (ExtraBold/Bold) against the dark background. Tracking is tightened on large displays for a compact, professional look, while labels use expanded tracking and uppercase styling to differentiate UI controls from content.

## Layout & Spacing

The layout follows a **fluid grid** approach for mobile, with a focus on edge-to-edge imagery. Content is padded with a standard 20px container margin to allow the "glass" containers to feel floating.

- **Vertical Rhythm:** Built on an 8px baseline. 
- **Movie Posters:** Use an aspect ratio of 2:3. In the "Now Playing" view, posters should have a subtle perspective transform or overlap to create a physical "carousel" feel.
- **Reflow:** On larger devices (tablets), the layout shifts to a multi-column grid where movie details appear side-by-side with the seating chart rather than stacked.

## Elevation & Depth

Hierarchy is established through **Glassmorphism** and background manipulation rather than traditional shadows.

1.  **Backdrop Level:** The primary movie poster or a blurred version of it acts as the furthest layer.
2.  **Base Level:** The deep charcoal background (#0A0A0A).
3.  **Floating Level:** UI panels use `rgba(255, 255, 255, 0.08)` with a `backdrop-filter: blur(24px)`.
4.  **Accent Level:** Interaction states (buttons, selected seats) use vibrant solid colors or high-intensity glows to sit "above" the glass.

Borders on glass elements should be 1px wide, using a semi-transparent white-to-transparent gradient to simulate a "light catch" on the edge of the glass.

## Shapes

The shape language is consistently **Rounded**, reflecting the soft, premium feel of modern high-end electronics. 

- **Standard Elements:** 0.5rem (8px) for small chips and input fields.
- **Cards & Panels:** 1rem (16px) for movie cards and bottom sheets.
- **Large Containers:** 1.5rem (24px) for the main immersive "movie stage" containers.
- **Seat Selection:** Seats should be slightly rounded squares, while the "Screen" indicator is a wide, sweeping arc.

## Components

### Buttons
- **Primary:** Solid Gold (#EAB308) with black text. High-contrast, rounded-full (pill).
- **Secondary:** Glassmorphic background with white border and white text.
- **Icon Buttons:** Circular glass containers with centered icons.

### Chips / Tags
- Use for genres and technical specs (e.g., IMAX, 4K). 
- Styling: Small, uppercase labels inside a low-opacity glass container with a subtle 1px border.

### Seating Chart
- **Available:** Low-opacity gray outline.
- **Selected:** Solid primary gold with a soft outer glow.
- **Occupied:** Solid dark gray, reduced opacity.
- **Screen:** A top-aligned, curved gradient line to represent the cinema screen.

### Input Fields
- Underlined or fully glassmorphic. For search, use a glassmorphic pill shape with a search icon prefix.

### Cards (Movie)
- Posters should have rounded corners (16px).
- Information overlays should use a bottom-to-top black gradient to ensure typography is legible over the movie art.