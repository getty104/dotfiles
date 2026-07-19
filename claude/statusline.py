#!/usr/bin/env python3
"""Claude Code statusLine.

ターミナル向けのステータス行を出力しつつ、RunCat Neo 用に
~/.claude/runcat-usage.json (RUNCAT_OUT_FILE で上書き可) を書き出す。
"""
import json
import math
import sys
import os
import socket
import tempfile
from datetime import datetime, timezone
from pathlib import Path

RUNCAT_OUT = Path(os.environ.get('RUNCAT_OUT_FILE', str(Path.home() / '.claude' / 'runcat-usage.json')))

try:
    data = json.load(sys.stdin)
    if not isinstance(data, dict):
        data = {}
except Exception:
    data = {}

R = '\033[0m'
DIM = '\033[2m'
BRAILLE = ' ⣀⣄⣤⣦⣶⣷⣿'

def gradient(pct):
    if pct < 50:
        r = int(pct * 5.1)
        return f'\033[38;2;{r};200;80m'
    else:
        g = int(200 - (pct - 50) * 4)
        return f'\033[38;2;255;{max(g, 0)};60m'

def braille_bar(pct, width=8):
    pct = min(max(pct, 0), 100)
    level = pct / 100
    bar = ''
    for i in range(width):
        seg_start = i / width
        seg_end = (i + 1) / width
        if level >= seg_end:
            bar += BRAILLE[7]
        elif level <= seg_start:
            bar += BRAILLE[0]
        else:
            frac = (level - seg_start) / (seg_end - seg_start)
            bar += BRAILLE[min(int(frac * 7), 7)]
    return bar

def reset_dt(ts):
    """リセット時刻 (UNIX epoch 秒) をローカルの datetime にする。不正値は None。

    秒以下は切り上げて分境界に揃える (14:59:59 → 15:00)。
    リセット時刻は :59 秒で返るため、そのまま切り捨て表示すると 1 分手前に見える。
    """
    if not isinstance(ts, (int, float)):
        return None
    try:
        return datetime.fromtimestamp(math.ceil(ts / 60) * 60).astimezone()
    except (OSError, OverflowError, ValueError):
        return None

def reset_stamp(ts):
    """'HH:MM' 形式。日を跨ぐ場合は日付も付ける。"""
    dt = reset_dt(ts)
    if dt is None:
        return ''
    if dt.date() == datetime.now().astimezone().date():
        return dt.strftime('%H:%M')
    return dt.strftime('%m/%d %H:%M')

def reset_hour(ts):
    """'HH' のみ。バーのように幅が限られる用途向け。"""
    dt = reset_dt(ts)
    return dt.strftime('%H') if dt is not None else ''

def fmt_reset(ts):
    stamp = reset_stamp(ts)
    return f' {DIM}↻{stamp}{R}' if stamp else ''

def fmt(label, pct, resets_at=None):
    p = round(pct)
    return f'{DIM}{label}{R} {gradient(pct)}{braille_bar(pct)}{R} {p}%{fmt_reset(resets_at)}'

def metric(title, pct, resets_at=None):
    if pct is None:
        return None
    stamp = reset_stamp(resets_at)
    value = f'{pct:g}%' + (f' ↻{stamp}' if stamp else '')
    return {'title': title, 'formattedValue': value, 'normalizedValue': round(pct / 100, 4)}

def write_runcat(five, five_reset, week, week_reset):
    # 使用率がまだ取れていない起動直後などは、前回の内容を残す
    if five is None and week is None:
        return
    snapshot = {
        'title': 'Claude Code',
        'symbol': 'staroflife',
        'metrics': [m for m in [
            metric('5h', five, five_reset),
            metric('7d', week, week_reset),
        ] if m is not None],
        'lastUpdatedDate': datetime.now(timezone.utc).strftime('%Y-%m-%dT%H:%M:%SZ'),
    }
    # バーは狭いので % は省き、5h のリセットを時 (HH) だけ添える
    bar = '{}/{}'.format(
        f'{five:g}' if five is not None else '-',
        f'{week:g}' if week is not None else '-',
    )
    stamp = reset_hour(five_reset) if five is not None else ''
    snapshot['metricsBarValue'] = f'{bar} ↻{stamp}' if stamp else bar

    RUNCAT_OUT.parent.mkdir(parents=True, exist_ok=True)
    fd, tmp = tempfile.mkstemp(prefix='.runcat-', dir=str(RUNCAT_OUT.parent))
    try:
        with os.fdopen(fd, 'w', encoding='utf-8') as f:
            json.dump(snapshot, f, ensure_ascii=False)
        os.replace(tmp, RUNCAT_OUT)
    except Exception:
        try:
            os.unlink(tmp)
        except OSError:
            pass
        raise

current_dir = data.get('workspace', {}).get('current_dir', '')
basename_dir = os.path.basename(current_dir)
user = os.getlogin()
hostname = socket.gethostname().split('.')[0]
location = f'{user}@{hostname}:{basename_dir}'

model = data.get('model', {}).get('display_name', '')
ctx = data.get('context_window', {}).get('used_percentage')
rate_limits = data.get('rate_limits', {})
five = rate_limits.get('five_hour', {}).get('used_percentage')
five_reset = rate_limits.get('five_hour', {}).get('resets_at')
week = rate_limits.get('seven_day', {}).get('used_percentage')
week_reset = rate_limits.get('seven_day', {}).get('resets_at')

# RunCat 側の書き出しが失敗してもステータス行の表示は止めない
try:
    write_runcat(five, five_reset, week, week_reset)
except Exception:
    pass

parts = [location]
if model:
    parts.append(model)
if ctx is not None:
    parts.append(fmt('ctx', ctx))
if five is not None:
    parts.append(fmt('5h', five, five_reset))
if week is not None:
    parts.append(fmt('7d', week, week_reset))

print(f' {DIM}│{R} '.join(parts), end='')
