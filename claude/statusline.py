#!/usr/bin/env python3
"""Claude Code statusLine.

ターミナル向けのステータス行を出力しつつ、RunCat Neo 用に
~/.claude/runcat-usage.json (RUNCAT_OUT_FILE で上書き可) を書き出す。
"""
import json
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

def fmt(label, pct):
    p = round(pct)
    return f'{DIM}{label}{R} {gradient(pct)}{braille_bar(pct)}{R} {p}%'

def metric(title, pct):
    if pct is None:
        return None
    return {'title': title, 'formattedValue': f'{pct:g}%', 'normalizedValue': round(pct / 100, 4)}

def write_runcat(five, week):
    snapshot = {
        'title': 'Claude Code',
        'symbol': 'staroflife',
        'metrics': [m for m in [
            metric('5h', five),
            metric('7d', week),
        ] if m is not None],
        'lastUpdatedDate': datetime.now(timezone.utc).strftime('%Y-%m-%dT%H:%M:%SZ'),
    }
    if five is not None or week is not None:
        snapshot['metricsBarValue'] = '{}/{}'.format(
            f'{five:g}%' if five is not None else '-',
            f'{week:g}%' if week is not None else '-',
        )

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
five = data.get('rate_limits', {}).get('five_hour', {}).get('used_percentage')
week = data.get('rate_limits', {}).get('seven_day', {}).get('used_percentage')

# RunCat 側の書き出しが失敗してもステータス行の表示は止めない
try:
    write_runcat(five, week)
except Exception:
    pass

parts = [location]
if model:
    parts.append(model)
if ctx is not None:
    parts.append(fmt('ctx', ctx))
if five is not None:
    parts.append(fmt('5h', five))
if week is not None:
    parts.append(fmt('7d', week))

print(f' {DIM}│{R} '.join(parts), end='')
