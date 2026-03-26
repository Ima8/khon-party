# EXAMPLES

These examples show the intended UX for the `khon-party` command family.

The default feel should be a visible party discussion: short, sharp turns between named personas, followed by a warmer closing synthesis.

## Balanced default

Use the prompt directly:

```text
/khon-party วิเคราะห์ระบบนี้ในมุม dev + biz + governance
```

Use current conversation context:

```text
/khon-party
```

## Broader namespaced mode

```text
/khon-party:more วางแผน rollout feature นี้ให้ครอบคลุม product, engineering, ops, และ risk
```

## Strongest namespaced mode

```text
/khon-party:max เปรียบเทียบ 3 ทางเลือกนี้แล้วกด debate ให้สุดก่อนช่วยเลือกทางที่ practical ที่สุด
```

## Deep debate with the base command

```text
/khon-party [depth=deep] [style=debate] วิเคราะห์ trade-off ของ architecture นี้
```

## Force personas

```text
/khon-party [personas=architect,operator,skeptic,governor] วิเคราะห์ระบบนี้
```

## Force modules

```text
/khon-party:more [modules=cog.role_playing,cog.six_thinking_hats,cog.black_swan] วิเคราะห์โจทย์นี้
```

## Help

```text
/khon-party help
```

## Notes

- The normal path should work without advanced controls.
- `/khon-party:more` and `/khon-party:max` are the preferred expansion syntax once the plugin is loaded.
- Inline `[:more]` and `[:max]` on the base command remain available for back-compat.
