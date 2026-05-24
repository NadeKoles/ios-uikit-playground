# UIKit Playground

A series of small focused screens, each built around a specific UIKit topic. No Storyboards, no XIBs, everything is programmatic. The goal is to get comfortable with the building blocks of real iOS apps: layout, components, data flow, and the patterns that make code maintainable.

Each project is self-contained and comes with a README explaining the key decisions behind it.

## Projects

| # | Project | Topics covered |
|---|---------|---------------|
| 01 | [RoundedViewLab](01-RoundedViewLab/) | `CALayer`, `layoutSubviews`, `UISlider`, `UISegmentedControl`, `UISwitch` |
| 02 | [Profile Card](02-ProfileCard/) | Programmatic layout, `NSLayoutConstraint` sets, `UIAlertController`, `UserDefaults`, closures, memory safety |
| 03 | [Users Feed](03-UsersFeed/) | `UITableView`, `UICollectionView`, `UISearchBar`, protocol extensions, delegation, image caching with `NSCache` |

## What this repo is for

UIKit has a lot of surface area. The only way to actually learn it is to build things and run into real problems — wrong place to set `cornerRadius`, constraint conflicts, cells reusing stale images, retain cycles in alert closures. This repo is where those problems get solved, understood, and documented.

Each screen is small enough to finish in one session and focused enough to go deep on one or two patterns. Complexity grows across projects: from a single custom view to a multi-layout feed with async networking.
