# 01 — RoundedViewLab

Interactive playground for exploring `CALayer` styling in UIKit: corner radius, border, and fill color — all configurable at runtime.

## What it does

A custom `RoundedView: UIView` sits in the center of the screen. Controls below it let you tweak its appearance live:

- **Corner Radius slider** (0–100) — updates `layer.cornerRadius`
- **Border Width slider** (0–10) — updates `layer.borderWidth`
- **Color segmented control** — switches between Yellow / Cyan / Pink themes (fill + matching border color)
- **Bug Mode switch** — demonstrates the `layoutSubviews` pitfall (see below)

## Key concepts practiced

**`layoutSubviews` is the right place for `layer` configuration.** Layer properties depend on the view's final bounds. Setting them before layout (e.g. in `init` or `viewDidLoad`) can produce stale or zero values. In `RoundedView`, the normal path applies all layer changes inside `layoutSubviews`, which is called after every bounds update.

**Bug mode** shows what breaks when you skip this: `applyInBugMode()` sets layer properties outside of `layoutSubviews`. Toggle the switch to see the difference in behavior when the view hasn't finished laying out yet.

**`setNeedsLayout()`** is called from the controller after changing any property on `RoundedView`, triggering a `layoutSubviews` pass on the next render cycle.

**Programmatic AutoLayout** — all layout uses `NSLayoutConstraint.activate`, no Storyboard constraints.

## Files

```
RoundedView.swift       # custom UIView subclass with layer styling
ViewController.swift    # all controls + layout + event handling
```

## Layout approach

All views are pinned with `translatesAutoresizingMaskIntoConstraints = false` and positioned via `NSLayoutConstraint.activate`. No Storyboard, no XIB.
