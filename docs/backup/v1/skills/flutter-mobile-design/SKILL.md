---
name: flutter-mobile-design
description: Create distinctive, production-grade Flutter mobile interfaces with exceptional design quality. Use this skill when the user asks to build Flutter apps, screens, widgets, or mobile interfaces. Applies to mobile app design, Flutter UI, custom widgets, app aesthetics, screen design, animations, and theming. Generates creative, polished Dart/Flutter code that avoids generic Material/Cupertino defaults and creates memorable, custom design systems.
---

This skill guides creation of distinctive, production-grade Flutter mobile interfaces that avoid generic "Flutter slop" aesthetics. Implement real working code with exceptional attention to aesthetic details, fluid animations, haptic feedback, and creative visual choices.

The user provides mobile app requirements: a screen, widget, component, or complete application to build. They may include context about the purpose, audience, or technical constraints.

## Design Thinking

Before coding, understand the context and commit to a BOLD aesthetic direction:

- **Purpose**: What problem does this app solve? Who uses it? What emotions should it evoke?
- **Aesthetic Direction**: Pick a strong direction and execute with precision:
  - **Neo-Brutalism**: Raw, honest, anti-corporate. Hard shadows (offset without blur), thick black borders (3-4px), vibrant flat colors, asymmetric layouts, bold oversized typography. Best for: creator tools, Gen Z apps, portfolios, dev tools.
  - **Liquid Glass / Glassmorphism 2.0**: Ethereal, premium, futuristic. `BackdropFilter` with blur, semi-transparent surfaces, specular reflections, chromatic aberration on edges. Best for: fintech, dashboards, premium lifestyle, crypto.
  - **Claymorphism**: Friendly, playful, approachable. Puffy rounded shapes, dual shadows (inner + outer), pastel colors, organic feel. Best for: wellness, education, kids apps, habit trackers.
  - **Dopamine Design**: Energetic, rewarding, gamified. Vibrant saturated colors, celebration animations (confetti, particles), haptic rewards, progress visualizations. Best for: fintech, fitness, productivity, social.
  - **Editorial/Magazine**: Sophisticated, content-focused. Strong typography hierarchy, generous whitespace, asymmetric grids, photography-first. Best for: news, luxury brands, content apps.
- **Signature Element**: What single detail will users remember? A unique transition? A satisfying haptic pattern? An unexpected color choice?

**CRITICAL**: Choose ONE clear direction and execute with full commitment. Half-measures create forgettable interfaces.

## Flutter Mobile Aesthetics Guidelines

### Typography

Typography defines personality. Use `google_fonts` package for distinctive choices.

- **NEVER use**: Roboto alone, system defaults, generic sans-serifs without character
- **Strong choices by mood**:
  - Technical/Modern: Space Grotesk, JetBrains Mono, IBM Plex Sans
  - Editorial/Luxury: Playfair Display, Cormorant, Libre Baskerville
  - Friendly/Approachable: Nunito, Quicksand, Baloo 2
  - Bold/Impactful: Clash Display, Lexend Mega, Bebas Neue
- **Hierarchy**: Use extreme contrast. Display at 800-900 weight vs body at 400. Size jumps of 2-3x between levels, not timid 1.2x increments.
- **One hero font** with a complementary body font. Never more than two families.

### Color & Theme

Build a complete custom `ThemeData`. Never rely on Material defaults.

- **Commit to a palette**: 1 dominant, 1-2 accents, semantic colors. Avoid evenly-distributed "safe" palettes.
- **Define everything in ThemeData**: `colorScheme`, `textTheme`, `elevatedButtonTheme`, `cardTheme`, `inputDecorationTheme`. Leave nothing to defaults.
- **Use `ThemeExtension`** for semantic colors beyond Material's colorScheme. Define custom extensions for `success`, `warning`, `info`, surface variants, and brand-specific colors. Access via `Theme.of(context).extension<CustomColors>()`.
- **Dark mode implementation**:
  - Background: Use dark gray (#121212 to #1E1E1E), never pure black (#000000)
  - Text opacity hierarchy: Primary text 87%, secondary 60%, disabled 38%
  - Desaturate accent colors by 10-20% to reduce visual vibration against dark backgrounds
  - Surfaces: Elevate with lighter grays (#1E1E1E → #2C2C2C → #383838) rather than shadows
  - Maintain 4.5:1 contrast ratio for text readability

### Motion & Animation

Movement creates life. Static interfaces feel dead.

- **Package**: Use `flutter_animate` for declarative, chainable animations. Avoid verbose `AnimationController` boilerplate for standard UI.
- **Timing**: 200-300ms for micro-interactions. 400-600ms for screen transitions. Never exceed 800ms for UI elements.
- **Curves**: 
  - `Curves.easeOutCubic` for entrances (fast start, gentle stop)
  - `Curves.easeInCubic` for exits
  - `Curves.elasticOut` sparingly for playful bounce
  - `Curves.fastOutSlowIn` for Material-like polish
- **Staggered reveals**: Animate list items with 50-100ms delays. One orchestrated entrance creates more impact than scattered animations.
- **Interactive animations**: Elements should respond to touch immediately. Scale down slightly on press (0.95-0.98), spring back on release.

### Haptic Feedback

Touch must feel physical. Haptics transform digital interactions into tactile experiences.

- **Use `HapticFeedback` class**: `lightImpact()` for selections, `mediumImpact()` for confirmations, `heavyImpact()` for significant actions, `selectionClick()` for pickers/sliders.
- **Pair with visuals**: Every haptic needs corresponding visual feedback. They reinforce each other.
- **Key moments**: Button presses, toggle switches, pull-to-refresh threshold, swipe-to-delete confirmation, success states, errors.
- **Restraint**: Not every tap needs haptics. Reserve for meaningful moments to maintain impact.

### Touch Targets & Interaction

Mobile is fingers, not pointers. Design for imprecision.

- **Minimum touch target: 66x66 logical pixels**. Prefer larger (72-80px) for primary actions.
- **Expand hit areas**: If an element has margin/padding around it, make that area tappable too. Use `GestureDetector` or `InkWell` with generous padding.
- **Gesture affordances**: Swipeable items should hint at swipeability. Draggable elements need visual lift on pickup.
- **Feedback on every touch**: Ripples, color shifts, scale changes. The user must know the app heard them.

### Visual Effects & Depth

Create atmosphere and dimension.

- **Glassmorphism**: `BackdropFilter` + `ImageFilter.blur(sigmaX: 10-20, sigmaY: 10-20)` + `ClipRRect`. Semi-transparent container (10-20% opacity white/black). Thin border (1px, 10-20% opacity). Always have colorful content behind the glass.
- **Neo-Brutal shadows**: `BoxShadow(offset: Offset(4, 4), blurRadius: 0, color: Colors.black)`. Shadow disappears on press (element "sinks").
- **Claymorphism** (manual implementation): Apply two `BoxShadow` on same container—light shadow from top-left (offset: -4,-4, color: white with 50-70% opacity), dark shadow from bottom-right (offset: 4,4, color: black with 15-25% opacity). Use low blur radius (8-12). Background must match parent color for seamless effect. Add large border radius (20-30+).
- **Gradients**: Mesh gradients for backgrounds, linear for buttons. Avoid the cliché purple-to-pink unless intentional.
- **Advanced effects**: Fragment shaders (GLSL) via `FragmentProgram` for Liquid Glass refractions, noise textures, animated backgrounds. Requires Impeller.

### Spatial Composition

Break free from rigid vertical lists.

- **Bento grids**: Varied card sizes in asymmetric arrangements. Use `SliverGrid` with custom `SliverGridDelegate`, or `Wrap` widget with varied-width children, or `StaggeredGrid` from `flutter_staggered_grid_view` package.
- **Negative space**: Generous padding (24-32px horizontal, 16-24px between sections). Premium apps breathe.
- **Asymmetry**: Off-center hero elements, text overlapping images with `Stack` and negative margins, elements breaking container boundaries.
- **Z-depth**: Layer elements with `Stack`. Cards floating over backgrounds. Overlapping avatars. Depth through shadows and blur.

### Responsive Layout

Adapt to screen sizes using `LayoutBuilder` only. Avoid `MediaQuery` which causes unnecessary rebuilds and edge-case issues.

- **Use `LayoutBuilder`** to get parent constraints and adapt layout accordingly.
- **Breakpoint pattern**: Check `constraints.maxWidth` for layout decisions (compact < 600, medium < 840, expanded).
- **Fluid sizing**: Combine `LayoutBuilder` with `FractionallySizedBox` or percentage-based widths.

### Screen Transitions

Navigation should feel spatial, not teleporting.

- **Hero animations**: Use `Hero` widget with matching tags for seamless element morphing between screens.
- **Custom `PageRouteBuilder`**: Build with `transitionsBuilder` using `FadeTransition`, `SlideTransition`, `ScaleTransition`, or combine multiple. Use `CurvedAnimation` for polish.
- **Predictive back**: Support Android 14+ gesture with `PopScope` and `PredictiveBackPageTransitionsBuilder`.
- **Continuity**: The user should always understand where they came from and where they're going.

### Performance (Non-Negotiable)

Beautiful means nothing at 30fps.

- **Impeller**: Required for advanced effects. Default on iOS, enable explicitly on Android for shader-heavy designs.
- **`RepaintBoundary`**: Wrap frequently-animating widgets (spinners, progress indicators, animated icons) to isolate repaints.
- **`const` constructors**: Use everywhere possible. Dramatic impact on rebuild performance.
- **Limit `BackdropFilter`**: Never nest multiple blur layers. Restrict blur area with `ClipRect`. One blur per visible screen area.
- **List optimization**: Use `itemExtent` when items are fixed height. Set `cacheExtent` appropriately. Use `ListView.builder`, never `ListView` with all children.

## Context Integration: MANDATORY

**Every screen MUST use project-specific content:**

1. **App Name**: Read from `IDEA.md` → use in Welcome screen, headers, branding
2. **Tagline/Subtitle**: Read from `IDEA.md` → use in Welcome, onboarding
3. **User Name**: Read from `CLAUDE.md` (section "Dane użytkownika" → "Imię") → use in greetings like "Witaj [Imię]!"
4. **Design Tokens**: If Design System was created (Faza 3 of /12apps-build), use those:
   - Colors from `ThemeData`/`ColorScheme` (NOT generic green, blue, etc.)
   - Typography from `TextTheme` (NOT default Roboto)
   - Spacing/sizing from design tokens

5. **Welcome Screen Animation** (REQUIRED!): Every Welcome screen MUST have:
   - Entry animation: scale (0.5→1.0) + fade (0→1)
   - Duration: 600-800ms
   - Curve: `Curves.elasticOut` for logo, `Curves.easeIn` for text/buttons
   - Real icon from Design System (NOT generic colored circle)

   ```dart
   // Example animation setup
   _controller = AnimationController(duration: Duration(milliseconds: 800), vsync: this);
   _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
     CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
   );
   _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
     CurvedAnimation(parent: _controller, curve: Interval(0.0, 0.5, curve: Curves.easeIn)),
   );
   ```

**NEVER leave placeholders:**
- `[APP NAME]` → Replace with real name from IDEA.md
- `[TAGLINE]` → Replace with real subtitle from IDEA.md
- `[Imię]` or `[Name]` → Replace with real name from CLAUDE.md
- Generic green circle logo → Create themed logo/icon matching app aesthetic
- Default Material colors → Use custom palette from Design System

**Before finishing ANY screen, verify:**
- [ ] No placeholder text visible
- [ ] Colors match Design System
- [ ] Fonts match Design System
- [ ] Logo/icons are themed (not generic shapes)
- [ ] User's name displayed correctly (if applicable)
- [ ] Screen looks like part of final app, NOT wireframe

## Anti-Patterns: NEVER Do This

- **Placeholder text** like `[APP NAME]`, `[TAGLINE]`, `Lorem ipsum`
- **Raw MaterialApp/CupertinoApp** without custom `ThemeData`
- **Default ElevatedButton/TextButton** without theme customization
- **AppBar with default styling**—either customize completely or build custom navigation
- **Colors.blue, Colors.purple, Colors.grey**—define your own palette
- **Static UI without any animation or feedback**
- **Touch targets under 66px**
- **Ignoring haptics entirely**
- **Using Cupertino widgets on Android or Material on iOS** without intentional cross-platform design decisions
- **Roboto as the only font**
- **Purple-to-blue gradients** (the calling card of generic AI output)
- **Nested BackdropFilters** or blur over blur
- **Skeleton screens with grey boxes**—style them to match your design language
- **Pure black (#000000) in dark mode**—use dark grays instead
- **MediaQuery for layout decisions**—use LayoutBuilder
- **Generic colored circle as logo** on Welcome screen—use themed icon from Design System
- **Static Welcome screen** without entry animation—always animate logo (scale+fade) + text
- **Text-heavy PROBLEM/SOLUTION screens** in onboarding—use visual widgets instead of paragraphs

## Essential Packages

- `google_fonts`: Typography with character
- `flutter_animate`: Declarative animation chains
- `flutter_staggered_grid_view`: Bento/masonry grid layouts

## Remember

Flutter gives you pixel-level control. Every widget can be anything. The framework imposes no style—only defaults that most developers never override. Your job is to override everything, intentionally, creating an interface that could only exist in THIS app. The AI Agent is capable of extraordinary creative work. Show what's possible when defaults are rejected and every detail serves the vision.