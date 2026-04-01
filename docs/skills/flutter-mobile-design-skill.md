---
name: flutter-mobile-design
description: Create distinctive, production-grade Flutter mobile interfaces. Enforces restrained composition, cardless layouts, purposeful motion, and utility copy. Avoids generic Material defaults and UI clutter. Generates polished Dart/Flutter code.
---

This skill guides the creation of distinctive, production-grade Flutter mobile interfaces that avoid generic "Flutter slop" (predictable Material UI, default AppBars, card mosaics, and lifeless layouts). Ship interfaces that feel deliberate, premium, and current.

## 0. Working Model (CRITICAL: Do this BEFORE coding)

Before writing any Dart code, you MUST write a brief 3-point plan:
- **Visual Thesis**: One sentence describing the mood, material, aesthetic direction (e.g., Linear-style restraint, Neo-Brutalism, or Glassmorphism), and energy.
- **Content Plan**: The hierarchy of the screen (e.g., Floating Header, Main Workspace, Secondary Context, Bottom Action).
- **Interaction Thesis**: 2-3 specific motion/haptic ideas that change the feel of the screen (e.g., staggered list entrance, squish effect on cards, heavy haptic on the primary CTA).

## 1. Beautiful Defaults & Aesthetic Restraint

- Start with composition, not components. Default to **cardless layouts**. Use sections, columns, dividers, lists, and spacing instead of putting everything in a `Card` or `Container` with a border-radius and shadow.
- **Linear-style Restraint**: If you must use borders, use ultra-thin 1px borders with low opacity (10-15%). Rely on flawless typography and spacing over decorative elements.
- **Edge-to-Edge**: Treat the screen as a full canvas. Content should bleed under transparent system status bars and navigation bars.
- Build a complete custom `ThemeData`. Define `colorScheme` and `textTheme`. Never rely on default blue/purple Material aesthetics. 

## 2. Typography & Hierarchy

- Make the primary data or action the loudest text.
- **Limit the system**: Two typefaces max. Use `google_fonts`. Pair a distinctive display font (e.g., Space Grotesk, Clash Display, Playfair) with a readable body font (e.g., Inter, JetBrains Mono).
- Use extreme scale contrast (e.g., 32px headers vs 14px body).
- **Dark Mode**: Never use pure black (`#000000`). Use deep grays. Desaturate accent colors by 10-20% to reduce visual vibration.

## 3. Utility Copy & Content

When the work is a mobile app surface, dashboard, or operational workspace, default to **utility copy** over marketing copy.
- Prioritize orientation, status, and action over promise or mood.
- Good: "Selected KPIs", "Plan status", "Search metrics", "Last sync".
- Avoid aspirational hero lines like "Revolutionize your workflow" unless building an onboarding/landing screen.
- Cut repetition. If deleting 30% of the copy improves the screen, keep deleting.
- **NO PLACEHOLDERS**: Never use "Lorem ipsum" or generic "[App Name]". Write real, context-appropriate mock data.

## 4. Kinesiology (Motion & Haptics)

Use motion to create presence and hierarchy, not noise. Static UIs are dead UIs.
- Ship at least 2-3 intentional motions using `flutter_animate` (staggered reveals, scroll-linked transitions, entrance sequences).
- **Haptics**: Touch must feel physical. Use `HapticFeedback.lightImpact()` for selections/switches, `mediumImpact()` for buttons, and `heavyImpact()` for major actions.
- **Squish Effect**: Elements should respond to touch immediately. Scale down slightly on press (0.95), spring back on release.
- **Fast and restrained**: 200-300ms for micro-interactions. 400-600ms for screen transitions. Smooth on mobile.

## 5. Technical Execution

- **Touch Targets**: Minimum 66x66 logical pixels. Prefer larger (72-80px) for primary actions on mobile.
- **Layouts**: Use `LayoutBuilder` for widget-level constraints. Avoid `MediaQuery` for layout logic unless checking safe areas or keyboard height.
- **Slivers**: Use `CustomScrollView` and Slivers (`SliverAppBar`, `SliverList`) for scrolling screens instead of generic `AppBar` + `ListView` to create fluid, dynamic headers.

## Hard Rules & Reject These Failures

- **NO** generic Material `AppBar` with a centered title and solid color.
- **NO** dashboard-card mosaics. If a panel can become a plain layout without losing meaning, remove the card treatment.
- **NO** purple-to-pink generic AI gradients.
- **NO** decorative shadows behind routine product UI.
- **NO** multiple competing accent colors. One primary action color per screen.

## Litmus Checks (Verify before completing your response)

- Is the aesthetic unmistakable and cohesive?
- Can the screen be understood by scanning headings and numbers only?
- Are cards *actually* necessary, or can spacing do the job?
- Do the chosen animations improve hierarchy or just add noise?
- Would the design still feel premium if all decorative shadows and borders were removed?