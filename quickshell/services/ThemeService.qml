pragma Singleton

import Quickshell
import QtQuick

import qs.config

Singleton {
    id: root

    property string pendingImagePath: ""

    function applyPaletteFromImage(path: string) {
        if (!path)
            return;

        pendingImagePath = path;
        quantizer.source = path.startsWith("file://") ? path : `file://${path}`;
    }

    function fromColor(value): var {
        if (typeof value === "string") {
            let hex = value.trim();
            if (hex.startsWith("#"))
                hex = hex.slice(1);

            if (hex.length === 8)
                hex = hex.slice(2);

            if (hex.length === 3)
                hex = `${hex[0]}${hex[0]}${hex[1]}${hex[1]}${hex[2]}${hex[2]}`;

            if (hex.length !== 6)
                return {
                    r: 0,
                    g: 0,
                    b: 0
                };

            return {
                r: parseInt(hex.slice(0, 2), 16) / 255,
                g: parseInt(hex.slice(2, 4), 16) / 255,
                b: parseInt(hex.slice(4, 6), 16) / 255
            };
        }

        if (value && value.r !== undefined)
            return {
                r: value.r,
                g: value.g,
                b: value.b
            };

        return {
            r: 0,
            g: 0,
            b: 0
        };
    }

    function toHex(rgb): string {
        function comp(v) {
            const n = Math.max(0, Math.min(255, Math.round(v * 255)));
            return n.toString(16).padStart(2, "0");
        }

        return `#${comp(rgb.r)}${comp(rgb.g)}${comp(rgb.b)}`;
    }

    function linearize(v: real): real {
        if (v <= 0.04045)
            return v / 12.92;
        return Math.pow((v + 0.055) / 1.055, 2.4);
    }

    function luminance(rgb): real {
        const r = linearize(rgb.r);
        const g = linearize(rgb.g);
        const b = linearize(rgb.b);
        return 0.2126 * r + 0.7152 * g + 0.0722 * b;
    }

    function contrastRatio(a, b): real {
        const l1 = luminance(a);
        const l2 = luminance(b);
        const light = Math.max(l1, l2);
        const dark = Math.min(l1, l2);
        return (light + 0.05) / (dark + 0.05);
    }

    function saturation(rgb): real {
        const maxC = Math.max(rgb.r, rgb.g, rgb.b);
        const minC = Math.min(rgb.r, rgb.g, rgb.b);
        const delta = maxC - minC;

        if (delta === 0)
            return 0;

        const l = (maxC + minC) / 2;
        return delta / (1 - Math.abs(2 * l - 1));
    }

    function hue(rgb): real {
        const maxC = Math.max(rgb.r, rgb.g, rgb.b);
        const minC = Math.min(rgb.r, rgb.g, rgb.b);
        const delta = maxC - minC;

        if (delta === 0)
            return 0;

        let h = 0;
        if (maxC === rgb.r)
            h = ((rgb.g - rgb.b) / delta) % 6;
        else if (maxC === rgb.g)
            h = (rgb.b - rgb.r) / delta + 2;
        else
            h = (rgb.r - rgb.g) / delta + 4;

        h *= 60;
        if (h < 0)
            h += 360;
        return h;
    }

    function hueDistance(a: real, b: real): real {
        const d = Math.abs(a - b);
        return Math.min(d, 360 - d);
    }

    function mix(a, b, t: real) {
        const x = Math.max(0, Math.min(1, t));
        return {
            r: a.r + (b.r - a.r) * x,
            g: a.g + (b.g - a.g) * x,
            b: a.b + (b.b - a.b) * x
        };
    }

    function applyFromQuantizedColors(colors) {
        if (!colors || colors.length === 0)
            return;

        const candidates = colors.map(c => {
            const rgb = fromColor(c);
            return {
                color: c,
                rgb: rgb,
                lum: luminance(rgb),
                sat: saturation(rgb),
                h: hue(rgb)
            };
        });

        let primary = null;
        for (const c of candidates) {
            if (c.lum >= 0.45)
                continue;

            const score = (1 - Math.abs(c.lum - 0.28)) + c.sat * 0.35;
            if (!primary || score > primary.score)
                primary = {
                    score,
                    entry: c
                };
        }

        if (!primary) {
            primary = {
                score: 0,
                entry: candidates.reduce((acc, c) => c.lum < acc.lum ? c : acc, candidates[0])
            };
        }

        const primaryEntry = primary.entry;

        let secondary = candidates[0];
        let bestContrast = -1;
        for (const c of candidates) {
            const ratio = contrastRatio(primaryEntry.rgb, c.rgb);
            if (ratio > bestContrast) {
                bestContrast = ratio;
                secondary = c;
            }
        }

        let accent = null;
        let accentScore = -1;
        for (const c of candidates) {
            if (c === primaryEntry || c === secondary)
                continue;

            const contrastWithPrimary = contrastRatio(primaryEntry.rgb, c.rgb);
            if (contrastWithPrimary < 1.8)
                continue;

            const hueSep = Math.max(hueDistance(c.h, primaryEntry.h), hueDistance(c.h, secondary.h));
            const score = c.sat * 2 + hueSep / 360 + contrastWithPrimary * 0.15;
            if (score > accentScore) {
                accentScore = score;
                accent = c;
            }
        }

        if (!accent)
            accent = secondary;

        const primaryLight = mix(primaryEntry.rgb, secondary.rgb, 0.12);
        const primaryDark = mix(primaryEntry.rgb, {
            r: 0,
            g: 0,
            b: 0
        }, 0.25);

        Appearance.colors.primary = toHex(primaryEntry.rgb);
        Appearance.colors.primary_light = toHex(primaryLight);
        Appearance.colors.primary_dark = toHex(primaryDark);
        Appearance.colors.secondary = toHex(secondary.rgb);
        Appearance.colors.accent = toHex(accent.rgb);
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
