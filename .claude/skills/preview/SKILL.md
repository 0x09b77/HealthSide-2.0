---
name: preview
description: Render a SwiftUI #Preview through the Xcode MCP (RenderPreview) and compare it with the Figma design — a static picture, no app launch, no taps. Use only when the user asks (`/preview`); never on your own initiative.
argument-hint: <Swift file with #Preview> [Figma link] [variant, e.g. "Dynamic Type: XXX Large"]
---

Render and check the preview: $ARGUMENTS

1. Xcode must be open with `HealthSide.xcodeproj`. Get the workspace id with `XcodeListWorkspaces`; if none is open, stop and ask the user to open the project.
2. `RenderPreview` with `sourceFilePath` as Xcode's project organization sees it: app files as `HealthSide/…`, package files as `HealthSideKit/Sources/…`. Several `#Preview`s in a file → `previewDefinitionIndexInFile`. A requested variant (Dynamic Type, color scheme, orientation) → `previewVariantOverrides` with a value from `supportedPreviewVariantOverrides`.
3. Open the snapshot (`previewSnapshotPath`) — one image, ~2k tokens.
4. If a Figma link was given: `get_screenshot` of that node and compare side by side — layout, sizes, colors, typography, icons, states present.
5. Report in ≤10 lines: what was rendered, `Matches` / `Mismatches` (each with the concrete difference), anything the preview can't show (behavior, focus, taps — that's `/verify`). Don't edit code; mismatches go to the user, who decides whether `coder` fixes them.

Never launch the app, start a device-interaction session or touch the simulator here — rendering a preview is the whole job.
