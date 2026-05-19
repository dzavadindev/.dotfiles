pragma Singleton

import Quickshell
import QtQuick

import qs.config

Singleton {
    id: root

    property string pendingImagePath: ""

    // Schedules a palette extraction pass for a specific image path.
    // Stores the path for change correlation, then points ColorQuantizer to the file URL.
    function applyPaletteFromImage(path: string) {
        if (!path)
            return;

        pendingImagePath = path;
        quantizer.source = path.startsWith("file://") ? path : `file://${path}`;
    }

    // Converts gamma-encoded sRGB channel into linear-light space.
    // Needed before luminance/contrast math for perceptual correctness.
    function linearize(v: real): real {
        if (v <= 0.04045)
            return v / 12.92;
        return Math.pow((v + 0.055) / 1.055, 2.4);
    }

    // Computes relative luminance (WCAG-style) for an RGB color.
    // Uses linearized channels and Rec. 709 luminance coefficients.
    function luminance(rgb): real {
        const r = linearize(rgb.r);
        const g = linearize(rgb.g);
        const b = linearize(rgb.b);
        return 0.2126 * r + 0.7152 * g + 0.0722 * b;
    }

    // Computes contrast ratio between two RGB colors.
    // Returns (lighter+0.05)/(darker+0.05), where higher means more contrast.
    function contrastRatio(a, b): real {
        const l1 = luminance(a);
        const l2 = luminance(b);
        const light = Math.max(l1, l2);
        const dark = Math.min(l1, l2);
        return (light + 0.05) / (dark + 0.05);
    }

    // Computes shortest circular hue distance in degrees.
    // Handles wrap-around between 0 and 360 correctly.
    function hueDistance(a: real, b: real): real {
        const d = Math.abs(a - b);
        return Math.min(d, 360 - d);
    }

    // Maps quantized image colors into the runtime theme palette.
    // This implementation enforces a dark-base hierarchy:
    // - primary: dark base color
    // - primary_dark: darker variant of primary
    // - primary_light: lighter variant of primary
    // - secondary/accent: vibrant colors, separated by hue/contrast
    function applyFromQuantizedColors(colors) {
        if (!colors || colors.length === 0)
            return;

        const candidates = colors.map(c => {
            const rgb = {
                r: c.r,
                g: c.g,
                b: c.b
            };

            return {
                color: c,
                rgb: rgb,
                lum: luminance(rgb),
                sat: c.hsvSaturation,
                h: c.hsvHue < 0 ? 0 : c.hsvHue
            };
        });

        // ==== Select PRIMARY (dark base) ====
        // target dark luminance and penalize high saturation so primary remains
        // a stable background anchor instead of a vibrant foreground tone.
        const targetPrimaryLum = 0.11;
        const minPrimaryLum = 0.08;
        const maxPrimaryLum = 0.15;

        let primary = null;
        for (const c of candidates) {
            if (c.lum < minPrimaryLum || c.lum > maxPrimaryLum)
                continue;

            // Score math:
            // - lumCloseness: highest when luminance is near targetPrimaryLum
            // - satPenalty: subtracts points for vivid colors
            const lumCloseness = 1 - Math.abs(c.lum - targetPrimaryLum);
            const satPenalty = c.sat * 0.65;
            const score = lumCloseness - satPenalty;

            if (!primary || score > primary.score)
                primary = {
                    score,
                    entry: c
                };
        }

        // Fallback if no candidate fits the dark window: choose the darkest color.
        if (!primary) {
            primary = {
                score: 0,
                entry: candidates.reduce((acc, c) => c.lum < acc.lum ? c : acc, candidates[0])
            };
        }

        const primaryEntry = primary.entry;

        // ==== Select SECONDARY (first vibrant) ====
        // Prefer colors that strongly contrast with primary; saturation is a tie-breaker.
        const minSecondaryContrast = 3.0;
        let secondary = candidates[0];
        let bestSecondaryScore = -1;
        for (const c of candidates) {
            if (c === primaryEntry)
                continue;

            const ratio = contrastRatio(primaryEntry.rgb, c.rgb);

            if (ratio < minSecondaryContrast)
                continue;

            // Score math:
            // - contrast has primary weight for readability against dark base
            // - saturation adds vibrancy preference
            const score = ratio * 1.25 + c.sat * 0.9;
            if (score > bestSecondaryScore) {
                bestSecondaryScore = score;
                secondary = c;
            }
        }

        // Fallback if no candidate reaches min contrast: use best raw contrast.
        if (bestSecondaryScore < 0) {
            let bestContrast = -1;
            for (const c of candidates) {
                if (c === primaryEntry)
                    continue;

                const ratio = contrastRatio(primaryEntry.rgb, c.rgb);
                if (ratio > bestContrast) {
                    bestContrast = ratio;
                    secondary = c;
                }
            }
        }

        // ==== Select ACCENT (second vibrant) ====
        // Accent should pop, remain usable on primary, and be hue-distinct.
        let accent = null;
        let accentScore = -1;
        for (const c of candidates) {
            if (c === primaryEntry || c === secondary)
                continue;

            const contrastWithPrimary = contrastRatio(primaryEntry.rgb, c.rgb);
            if (contrastWithPrimary < 1.8)
                continue;

            const hueSep = Math.max(hueDistance(c.h, primaryEntry.h), hueDistance(c.h, secondary.h));
            // Score math:
            // - saturation is strongly weighted (accent should be energetic)
            // - hue separation avoids secondary/accent looking too similar
            // - small contrast bonus keeps visibility on dark surfaces
            const score = c.sat * 2.2 + hueSep / 360 + contrastWithPrimary * 0.2;
            if (score > accentScore) {
                accentScore = score;
                accent = c;
            }
        }

        if (!accent)
            accent = secondary;

        // ==== Assign selected colors to Appearance ====
        Appearance.colors.primary = primaryEntry.color;
        Appearance.colors.primary_light = Qt.lighter(primaryEntry.color, 0.9);
        Appearance.colors.primary_dark = Qt.darker(primaryEntry.color, 1.2);
        Appearance.colors.secondary = secondary.color;
        Appearance.colors.accent = accent.color;
    }

    ColorQuantizer {
        id: quantizer

        depth: 4
        rescaleSize: 64

        onColorsChanged: {
            if (!root.pendingImagePath)
                return;

            root.applyFromQuantizedColors(colors);
            root.pendingImagePath = "";
        }
    }
}
