# Examples

Use these prompts to sanity-check the `khon-party` command family UX.

## Minimal

```text
/khon-party วิเคราะห์แผนนี้
```

## No-argument context mode

```text
/khon-party
```

## Broader namespaced mode

```text
/khon-party:more เปรียบเทียบ 3 ทางเลือกนี้
```

## Strongest namespaced mode

```text
/khon-party:max เปรียบเทียบ 3 ทางเลือกนี้
```

## Forced personas

```text
/khon-party [personas=architect,operator,skeptic,governor] วิเคราะห์ระบบนี้
```

## Forced modules

```text
/khon-party:more [modules=cog.role_playing,cog.six_thinking_hats,cog.black_swan] วิเคราะห์โจทย์นี้
```
