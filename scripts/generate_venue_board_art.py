#!/usr/bin/env python3
"""Generate manufacturer-grade corner art for all 15 Raid Map venue overlays."""

from pathlib import Path

OUT = Path(__file__).resolve().parents[1] / "assets" / "board" / "venues"

GOLD = ("#FFE566", "#E8C547", "#9A7420")


def svg_open(bg_top: str, bg_bot: str, floor_y: int = 188) -> str:
    g0, g1, g2 = GOLD
    return f'''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 400 280" fill="none">
  <defs>
    <linearGradient id="bg" x1="0" y1="0" x2="400" y2="280"><stop stop-color="{bg_top}"/><stop offset="1" stop-color="{bg_bot}"/></linearGradient>
    <linearGradient id="floor" x1="0" y1="{floor_y}" x2="0" y2="280"><stop stop-color="#6A6058"/><stop offset="1" stop-color="#3A3428"/></linearGradient>
    <linearGradient id="gold" x1="0" y1="0" x2="1" y2="1"><stop stop-color="{g0}"/><stop offset="0.5" stop-color="{g1}"/><stop offset="1" stop-color="{g2}"/></linearGradient>
    <radialGradient id="spot" cx="200" cy="72" r="120"><stop stop-color="#FFE566" stop-opacity="0.22"/><stop offset="1" stop-opacity="0"/></radialGradient>
  </defs>
  <rect width="400" height="280" fill="url(#bg)" rx="8"/>
  <rect x="0" y="{floor_y}" width="400" height="{280 - floor_y}" fill="url(#floor)"/>
  <ellipse cx="200" cy="72" rx="120" ry="80" fill="url(#spot)"/>
  <line x1="0" y1="{floor_y}" x2="400" y2="{floor_y}" stroke="#E8C547" stroke-opacity="0.2" stroke-width="1.2"/>
'''


def svg_close() -> str:
    return "</svg>\n"


def shelf_row(y: int, n: int = 10) -> str:
    parts = [f'<rect x="20" y="{y}" width="360" height="14" fill="#4A3020" fill-opacity="0.55"/>']
    x = 28
    colors = ["#6B3FA0", "#4ECDC4", "#E67E22", "#8B4513", "#2C5282", "#9B2C2C", "#276749", "#805AD5", "#C05621", "#319795"]
    for i in range(n):
        h = 18 + (i % 3) * 4
        parts.append(f'<rect x="{x}" y="{y - h}" width="12" height="{h}" rx="1" fill="{colors[i % len(colors)]}"/>')
        x += 34
    return "\n  ".join(parts)


def desks_grid() -> str:
    parts = []
    for row, y in enumerate([118, 166, 214]):
        for col, x in enumerate([40, 112, 184]):
            parts.append(f'<rect x="{x}" y="{y}" width="56" height="10" rx="2" fill="#8A8070"/>')
            parts.append(f'<rect x="{x + 4}" y="{y + 10}" width="6" height="22" fill="#5A5048"/>')
            parts.append(f'<rect x="{x + 46}" y="{y + 10}" width="6" height="22" fill="#5A5048"/>')
    return "\n  ".join(parts)


def lockers() -> str:
    parts = []
    for i, x in enumerate([108, 152, 196, 240]):
        parts.append(f'<rect x="{x}" y="72" width="36" height="88" rx="2" fill="#5A6878" stroke="#8A98A8" stroke-width="0.8"/>')
        parts.append(f'<circle cx="{x + 30}" cy="86" r="2" fill="url(#gold)"/>')
    return "\n  ".join(parts)


VENUES = {
    "home": {
        "living": ("#1E4A38", "#0E2218", lambda: f'''
  <rect x="24" y="28" width="136" height="88" rx="3" fill="#1A3028" fill-opacity="0.5"/>
  <rect x="32" y="36" width="120" height="72" rx="2" fill="#4A7898" fill-opacity="0.55"/>
  <rect x="28" y="148" width="210" height="48" rx="12" fill="#C87838"/>
  <rect x="28" y="134" width="210" height="22" rx="10" fill="#D4883E"/>
  <ellipse cx="168" cy="214" rx="130" ry="42" fill="#1A4A38" fill-opacity="0.55" stroke="#E8C547" stroke-opacity="0.3"/>
  <rect x="312" y="78" width="5" height="108" fill="url(#gold)"/>
  <ellipse cx="314" cy="56" rx="22" ry="14" fill="#FFE566" fill-opacity="0.75"/>
  <rect x="118" y="178" width="88" height="10" rx="3" fill="#5C3820"/>'''),
        "study": ("#1E3048", "#101828", lambda: f'''
  <rect x="20" y="18" width="360" height="108" rx="4" fill="#2A1808" fill-opacity="0.55" stroke="url(#gold)" stroke-opacity="0.4"/>
  {shelf_row(54)}
  {shelf_row(90)}
  <rect x="36" y="164" width="208" height="14" rx="3" fill="#5C3820"/>
  <circle cx="328" cy="196" r="30" fill="#4ECDC4" fill-opacity="0.35" stroke="url(#gold)"/>
  <ellipse cx="220" cy="150" rx="70" ry="60" fill="#FFE566" fill-opacity="0.12"/>'''),
        "kitchen": ("#1E4A3A", "#0E2218", lambda: '''
  <rect x="20" y="22" width="68" height="58" rx="3" fill="#F0E8D8" stroke="#A89880"/>
  <rect x="96" y="22" width="68" height="58" rx="3" fill="#E0D8C8" stroke="#A89880"/>
  <rect x="172" y="22" width="68" height="58" rx="3" fill="#F0E8D8" stroke="#A89880"/>
  <rect x="16" y="112" width="304" height="20" rx="3" fill="#F5F0E8"/>
  <rect x="328" y="22" width="56" height="168" rx="5" fill="#E8ECEE" stroke="#A8B0B4"/>
  <rect x="48" y="168" width="200" height="16" rx="3" fill="#F5F0E8"/>
  <circle cx="188" cy="108" r="5" fill="#E85D04" fill-opacity="0.5"/>'''),
        "garden": ("#1A4D32", "#0E2818", lambda: '''
  <rect x="32" y="148" width="56" height="36" rx="3" fill="#9A9088"/>
  <rect x="96" y="148" width="56" height="36" rx="3" fill="#7A7068"/>
  <rect x="288" y="36" width="80" height="148" rx="4" fill="#5C3820"/>
  <ellipse cx="53" cy="88" rx="24" ry="28" fill="#2D6A4F" fill-opacity="0.8"/>
  <ellipse cx="120" cy="98" rx="20" ry="24" fill="#276749" fill-opacity="0.85"/>
  <circle cx="80" cy="48" r="20" fill="#FFE566" fill-opacity="0.4"/>'''),
    },
    "office": {
        "open_plan": ("#1A2838", "#0E1420", lambda: '''
  <rect x="32" y="100" width="88" height="10" rx="2" fill="#4A3020"/>
  <rect x="48" y="72" width="56" height="32" rx="2" fill="#2A3848" stroke="#4A5868"/>
  <rect x="152" y="100" width="88" height="10" rx="2" fill="#4A3020"/>
  <rect x="168" y="72" width="56" height="32" rx="2" fill="#2A3848"/>
  <rect x="272" y="100" width="88" height="10" rx="2" fill="#4A3020"/>
  <ellipse cx="76" cy="168" rx="16" ry="8" fill="#415A77" fill-opacity="0.7"/>
  <rect x="32" y="24" width="120" height="48" rx="3" fill="#F5F5F5" fill-opacity="0.9" stroke="url(#gold)" stroke-opacity="0.35"/>'''),
        "break_room": ("#2A3848", "#141C28", lambda: '''
  <rect x="24" y="108" width="200" height="16" rx="3" fill="#D4C8B8"/>
  <rect x="240" y="40" width="72" height="140" rx="4" fill="#E8ECEE"/>
  <rect x="128" y="72" width="40" height="32" rx="3" fill="#2A2820"/>
  <ellipse cx="64" cy="100" rx="10" ry="6" fill="#F5F0E8"/>
  <ellipse cx="148" cy="68" rx="8" ry="6" fill="#8B4513" fill-opacity="0.6"/>
  <rect x="80" y="188" width="160" height="12" rx="3" fill="#5C3820"/>'''),
        "meeting_pod": ("#1E2838", "#101820", lambda: '''
  <ellipse cx="200" cy="168" rx="140" ry="48" fill="#4A5048" stroke="url(#gold)" stroke-opacity="0.35"/>
  <rect x="120" y="24" width="160" height="56" rx="3" fill="#F8F8F8" stroke="url(#gold)" stroke-opacity="0.5"/>
  <ellipse cx="80" cy="140" rx="14" ry="8" fill="#415A77" fill-opacity="0.7"/>
  <ellipse cx="320" cy="140" rx="14" ry="8" fill="#415A77" fill-opacity="0.7"/>
  <rect x="320" y="200" width="48" height="40" rx="2" fill="#3A3830"/>'''),
        "supply_closet": ("#1A2030", "#0A1018", lambda: '''
  <rect x="48" y="32" width="304" height="200" rx="4" fill="#2A2838" stroke="url(#gold)" stroke-opacity="0.35"/>
  <line x1="48" y1="88" x2="352" y2="88" stroke="#E8C547" stroke-opacity="0.15"/>
  <line x1="48" y1="144" x2="352" y2="144" stroke="#E8C547" stroke-opacity="0.15"/>
  <rect x="64" y="48" width="48" height="32" rx="2" fill="#4ECDC4" fill-opacity="0.35"/>
  <rect x="128" y="52" width="40" height="28" rx="2" fill="#E85D04" fill-opacity="0.35"/>
  <rect x="200" y="100" width="56" height="36" rx="2" fill="#8A8070" fill-opacity="0.5"/>
  <rect x="280" y="160" width="48" height="56" rx="2" fill="#5A5048"/>'''),
    },
    "school": {
        "classroom": ("#1A3A5C", "#0E2238", lambda: f'''
  <rect x="32" y="24" width="336" height="72" rx="4" fill="#2A6A48" stroke="url(#gold)" stroke-width="1.5"/>
  <text x="56" y="68" fill="#FFE566" font-family="Outfit,sans-serif" font-size="22" font-weight="800">ABC  123</text>
  <circle cx="352" cy="44" r="18" fill="#F5F0E8" stroke="#A89880"/>
  {desks_grid()}
  <circle cx="320" cy="108" r="22" fill="#4ECDC4" fill-opacity="0.4" stroke="url(#gold)"/>'''),
        "library": ("#1E2848", "#101828", lambda: f'''
  <rect x="20" y="16" width="360" height="120" rx="4" fill="#2A1808" fill-opacity="0.55" stroke="url(#gold)" stroke-opacity="0.4"/>
  {shelf_row(56)}
  {shelf_row(96)}
  <rect x="80" y="168" width="240" height="14" rx="3" fill="#5C3820"/>
  <rect x="168" y="148" width="64" height="20" rx="3" fill="#4B2A8C" fill-opacity="0.6" stroke="url(#gold)" stroke-opacity="0.4"/>
  <text x="200" y="163" fill="#FFE566" font-family="Outfit,sans-serif" font-size="11" font-weight="700" text-anchor="middle">QUIET</text>'''),
        "hallway": ("#1A2838", "#0E1828", lambda: f'''
  <path d="M80 40 L320 40 L360 260 L40 260 Z" fill="#3A4858" fill-opacity="0.65"/>
  {lockers()}
  <rect x="288" y="88" width="48" height="56" rx="2" fill="#8B4513" fill-opacity="0.55" stroke="url(#gold)" stroke-opacity="0.35"/>
  <rect x="148" y="200" width="104" height="10" rx="2" fill="#5C3820"/>'''),
        "gym": ("#1A3048", "#0E1828", lambda: '''
  <rect x="0" y="168" width="400" height="112" fill="#C87838" fill-opacity="0.45"/>
  <rect x="168" y="32" width="64" height="6" rx="1" fill="#8A8070"/>
  <ellipse cx="200" cy="92" rx="28" ry="6" fill="none" stroke="#E85D04" stroke-width="2.5"/>
  <circle cx="120" cy="200" r="18" fill="#E85D04" fill-opacity="0.8"/>
  <rect x="280" y="80" width="80" height="8" rx="2" fill="#4A4840"/>
  <rect x="32" y="120" width="72" height="36" rx="4" fill="#2A3848"/>'''),
    },
    "hospital": {
        "patient_bay": ("#1A3048", "#0E1828", lambda: '''
  <rect x="48" y="140" width="140" height="24" rx="6" fill="#F0F4F8" stroke="#A8B8C8"/>
  <rect x="56" y="132" width="124" height="16" rx="4" fill="#E8ECEE"/>
  <line x1="220" y1="80" x2="220" y2="200" stroke="#A8B0B4" stroke-width="2"/>
  <rect x="240" y="88" width="64" height="48" rx="3" fill="#2A3848"/>
  <path d="M252 120 L268 104 L284 116 L296 100" stroke="#70AD47" stroke-width="2" fill="none"/>'''),
        "nurses_station": ("#1A3848", "#0E2030", lambda: '''
  <rect x="280" y="168" width="96" height="14" rx="2" fill="#E8E0D4"/>
  <rect x="288" y="182" width="80" height="40" rx="2" fill="#D0C8BC" fill-opacity="0.6"/>
  <rect x="48" y="56" width="48" height="48" rx="4" fill="#F0F4F8" fill-opacity="0.15" stroke="#5B9BD5"/>
  <rect x="338" y="66" width="12" height="28" rx="1" fill="#E63946" fill-opacity="0.7"/>
  <rect x="330" y="78" width="28" height="12" rx="1" fill="#E63946" fill-opacity="0.7"/>'''),
        "waiting_room": ("#1E3848", "#102028", lambda: '''
  <rect x="40" y="148" width="48" height="32" rx="6" fill="#6A8090" fill-opacity="0.65"/>
  <rect x="104" y="148" width="48" height="32" rx="6" fill="#5A7080" fill-opacity="0.65"/>
  <rect x="168" y="148" width="48" height="32" rx="6" fill="#6A8090" fill-opacity="0.65"/>
  <rect x="232" y="148" width="48" height="32" rx="6" fill="#5A7080" fill-opacity="0.65"/>
  <rect x="80" y="40" width="240" height="72" rx="4" fill="#4ECDC4" fill-opacity="0.12" stroke="url(#gold)" stroke-opacity="0.35"/>
  <text x="200" y="88" fill="#FFE566" font-family="Outfit,sans-serif" font-size="14" font-weight="700" text-anchor="middle">WELCOME</text>'''),
        "rehab_gym": ("#1A4038", "#0E2218", lambda: '''
  <rect x="80" y="160" width="240" height="12" rx="3" fill="#81C784" fill-opacity="0.35"/>
  <circle cx="120" cy="120" r="24" fill="#4ECDC4" fill-opacity="0.35" stroke="url(#gold)"/>
  <rect x="240" y="100" width="80" height="8" rx="2" fill="#8A8078"/>
  <ellipse cx="280" cy="200" rx="40" ry="14" fill="#588157" fill-opacity="0.4"/>'''),
    },
    "party": {
        "dance_floor": ("#2A1048", "#100820", lambda: '''
  <rect x="48" y="140" width="304" height="120" rx="4" fill="#1A0828" fill-opacity="0.6"/>
  <rect x="24" y="100" width="32" height="56" rx="3" fill="#2A2820"/>
  <circle cx="40" cy="128" r="10" fill="#1A1818"/>
  <circle cx="200" cy="36" r="20" fill="#C8D0D8" fill-opacity="0.6" stroke="url(#gold)"/>
  <ellipse cx="80" cy="72" rx="14" ry="18" fill="#FF8A00" fill-opacity="0.7"/>
  <ellipse cx="320" cy="68" rx="14" ry="18" fill="#B5179E" fill-opacity="0.7"/>'''),
        "snack_bar": ("#2A1818", "#140E0E", lambda: '''
  <rect x="48" y="128" width="304" height="16" rx="4" fill="#F5F0E8"/>
  <circle cx="100" cy="112" r="14" fill="#FAFAFA" stroke="#C8C0B4"/>
  <circle cx="180" cy="108" r="14" fill="#FAFAFA" stroke="#C8C0B4"/>
  <rect x="240" y="88" width="80" height="48" rx="3" fill="#E85D04" fill-opacity="0.45"/>
  <rect x="72" y="168" width="36" height="40" rx="4" fill="#5C3820" fill-opacity="0.7"/>'''),
        "photo_zone": ("#2A1048", "#100820", lambda: '''
  <rect x="280" y="148" width="64" height="80" rx="2" fill="#FFE566" fill-opacity="0.2" stroke="url(#gold)" stroke-opacity="0.4"/>
  <rect x="48" y="48" width="48" height="72" rx="2" fill="#4ECDC4" fill-opacity="0.25"/>
  <circle cx="200" cy="100" r="32" fill="#B5179E" fill-opacity="0.2" stroke="url(#gold)" stroke-opacity="0.35"/>
  <rect x="120" y="180" width="24" height="16" rx="2" fill="#FF8A00" fill-opacity="0.5"/>'''),
        "backyard": ("#1A2838", "#0E1828", lambda: '''
  <circle cx="200" cy="220" r="20" fill="#3A2818" fill-opacity="0.6" stroke="#FF8A00" stroke-opacity="0.4"/>
  <ellipse cx="200" cy="216" rx="10" ry="6" fill="#FF8A00" fill-opacity="0.5"/>
  <rect x="32" y="148" width="56" height="36" rx="3" fill="#6A6058"/>
  <circle cx="340" cy="48" r="18" fill="#FFE566" fill-opacity="0.25"/>
  <ellipse cx="80" cy="100" rx="28" ry="32" fill="#2D6A4F" fill-opacity="0.55"/>'''),
    },
    "hotel": {
        "lobby": ("#1A2030", "#0A1018", lambda: '''
  <path d="M120 120 L280 120 L300 180 L100 180 Z" fill="#2B2D42" stroke="url(#gold)" stroke-opacity="0.4"/>
  <rect x="48" y="148" width="72" height="28" rx="8" fill="#4A5060" fill-opacity="0.7"/>
  <rect x="168" y="32" width="64" height="48" rx="2" fill="#1A1008" stroke="url(#gold)" stroke-opacity="0.4"/>
  <path d="M200 88 Q200 72 212 72 Q224 72 224 88" fill="url(#gold)"/>'''),
        "conference": ("#1E2838", "#101820", lambda: '''
  <ellipse cx="200" cy="168" rx="140" ry="48" fill="#4A5048" stroke="url(#gold)" stroke-opacity="0.35"/>
  <rect x="120" y="24" width="160" height="56" rx="3" fill="#F8F8F8" stroke="url(#gold)" stroke-opacity="0.5"/>
  <rect x="168" y="156" width="20" height="12" rx="2" fill="#4ECDC4" fill-opacity="0.5"/>
  <rect x="212" y="158" width="20" height="12" rx="2" fill="#FF8A00" fill-opacity="0.5"/>'''),
        "lounge": ("#1A2838", "#101820", lambda: '''
  <rect x="280" y="148" width="72" height="28" rx="8" fill="#4A5060" fill-opacity="0.7"/>
  <rect x="48" y="148" width="72" height="28" rx="8" fill="#4A5060" fill-opacity="0.7"/>
  <rect x="160" y="88" width="80" height="10" rx="2" fill="#5C3820"/>
  <path d="M148 48 Q160 32 172 48" fill="#F5F0E8" stroke="#A89880"/>'''),
        "suite_hall": ("#1A2838", "#0E1828", lambda: f'''
  <path d="M80 40 L320 40 L360 260 L40 260 Z" fill="#3A4858" fill-opacity="0.65"/>
  <rect x="120" y="80" width="48" height="72" rx="2" fill="#5A6878"/>
  <rect x="232" y="80" width="48" height="72" rx="2" fill="#4A5868"/>
  <rect x="300" y="160" width="48" height="32" rx="2" fill="#5A5048"/>
  <circle cx="318" cy="110" r="4" fill="url(#gold)"/>'''),
    },
    "restaurant": {
        "dining_room": ("#2A1818", "#140E0E", lambda: '''
  <rect x="48" y="128" width="304" height="16" rx="4" fill="#F5F0E8"/>
  <path d="M48 144 Q200 160 352 144 L352 200 Q200 220 48 200 Z" fill="#E8E0D4"/>
  <circle cx="100" cy="112" r="14" fill="#FAFAFA" stroke="#C8C0B4"/>
  <circle cx="180" cy="108" r="14" fill="#FAFAFA" stroke="#C8C0B4"/>
  <circle cx="260" cy="108" r="14" fill="#FAFAFA" stroke="#C8C0B4"/>'''),
        "kitchen_pass": ("#1E4A3A", "#0E2218", lambda: '''
  <rect x="16" y="112" width="304" height="20" rx="3" fill="#F5F0E8"/>
  <rect x="20" y="40" width="120" height="56" rx="3" fill="#E0D8C8"/>
  <rect x="200" y="88" width="72" height="16" rx="2" fill="#4A4840"/>
  <rect x="320" y="32" width="56" height="148" rx="4" fill="#E8ECEE"/>
  <rect x="48" y="168" width="200" height="16" rx="3" fill="#D4C8B8"/>'''),
        "bar": ("#1A2030", "#0A1018", lambda: '''
  <rect x="24" y="108" width="280" height="16" rx="3" fill="#2A2820"/>
  <rect x="40" y="88" width="24" height="32" rx="2" fill="#4ECDC4" fill-opacity="0.35"/>
  <rect x="80" y="92" width="20" height="28" rx="2" fill="#E85D04" fill-opacity="0.35"/>
  <ellipse cx="200" cy="76" rx="40" ry="12" fill="#F5F0E8" fill-opacity="0.5"/>
  <rect x="300" y="48" width="64" height="80" rx="3" fill="#5A5048"/>'''),
        "patio": ("#1A4D32", "#0E2818", lambda: '''
  <rect x="48" y="168" width="120" height="12" rx="3" fill="#5C3820"/>
  <rect x="240" y="120" width="96" height="64" rx="3" fill="#8A8070" fill-opacity="0.35"/>
  <ellipse cx="120" cy="100" rx="24" ry="28" fill="#2D6A4F" fill-opacity="0.6"/>
  <circle cx="320" cy="56" r="22" fill="#FFE566" fill-opacity="0.45"/>'''),
    },
    "museum": {
        "gallery": ("#1E1828", "#0E0818", lambda: '''
  <rect x="40" y="48" width="80" height="64" rx="2" fill="#1A1008" stroke="url(#gold)" stroke-width="1.5"/>
  <rect x="160" y="40" width="96" height="72" rx="2" fill="#1A1008" stroke="url(#gold)" stroke-width="2"/>
  <rect x="280" y="52" width="72" height="56" rx="2" fill="#1A1008" stroke="url(#gold)" stroke-width="1.5"/>
  <rect x="168" y="168" width="64" height="12" rx="2" fill="#5A5048"/>
  <ellipse cx="200" cy="140" rx="16" ry="20" fill="#D4A574" fill-opacity="0.5"/>'''),
        "museum_lobby": ("#1A2030", "#0A1018", lambda: '''
  <rect x="120" y="100" width="160" height="48" rx="3" fill="#3A3D52"/>
  <rect x="48" y="48" width="80" height="56" rx="2" fill="#6B4E71" fill-opacity="0.4"/>
  <rect x="272" y="48" width="80" height="56" rx="2" fill="#8B7355" fill-opacity="0.4"/>
  <text x="200" y="132" fill="#FFE566" font-family="Outfit,sans-serif" font-size="12" font-weight="700" text-anchor="middle">TICKETS</text>'''),
        "archive": ("#1E2838", "#101820", lambda: '''
  <rect x="32" y="40" width="336" height="120" rx="4" fill="#2A2418" fill-opacity="0.55" stroke="url(#gold)" stroke-opacity="0.35"/>
  <rect x="48" y="56" width="120" height="80" rx="2" fill="#8B7355" fill-opacity="0.35" stroke="#E8C547" stroke-opacity="0.25"/>
  <rect x="184" y="56" width="120" height="80" rx="2" fill="#8B7355" fill-opacity="0.35"/>
  <rect x="320" y="56" width="32" height="80" rx="1" fill="#6A6058"/>'''),
        "cafe": ("#2A3848", "#141C28", lambda: '''
  <rect x="80" y="108" width="240" height="16" rx="3" fill="#D4C8B8"/>
  <ellipse cx="120" cy="92" rx="10" ry="6" fill="#F5F0E8"/>
  <rect x="240" y="40" width="72" height="140" rx="4" fill="#E8ECEE"/>
  <rect x="48" y="168" width="64" height="12" rx="3" fill="#5C3820"/>'''),
    },
    "gym": {
        "cardio": ("#1A3048", "#0E1828", lambda: '''
  <rect x="32" y="120" width="72" height="36" rx="4" fill="#2A3848" stroke="#4A5868"/>
  <rect x="120" y="120" width="72" height="36" rx="4" fill="#2A3848"/>
  <rect x="208" y="120" width="72" height="36" rx="4" fill="#2A3848"/>
  <rect x="0" y="168" width="400" height="112" fill="#C87838" fill-opacity="0.35"/>'''),
        "weights": ("#1A2838", "#0E1828", lambda: '''
  <rect x="280" y="80" width="80" height="8" rx="2" fill="#4A4840"/>
  <ellipse cx="304" cy="100" rx="14" ry="8" fill="#5A5850" stroke="#8A8078"/>
  <ellipse cx="332" cy="100" rx="14" ry="8" fill="#5A5850" stroke="#8A8078"/>
  <ellipse cx="304" cy="130" rx="12" ry="7" fill="#4A4840"/>
  <rect x="48" y="140" width="160" height="12" rx="3" fill="#5A5048"/>'''),
        "studio": ("#1A3848", "#0E2030", lambda: '''
  <rect x="24" y="48" width="8" height="112" fill="#C8D0D8" fill-opacity="0.35"/>
  <rect x="368" y="48" width="8" height="112" fill="#C8D0D8" fill-opacity="0.35"/>
  <rect x="160" y="168" width="48" height="12" rx="2" fill="#4ECDC4" fill-opacity="0.45"/>
  <rect x="200" y="208" width="48" height="12" rx="2" fill="#81C784" fill-opacity="0.45"/>'''),
        "locker_room": ("#1A2838", "#0E1828", lambda: f'''
  {lockers()}
  <rect x="148" y="200" width="104" height="10" rx="2" fill="#5C3820"/>
  <rect x="48" y="180" width="32" height="48" rx="3" fill="#6A8090" fill-opacity="0.5"/>'''),
    },
    "library": {
        "stacks": ("#1E2848", "#101828", lambda: f'''
  <rect x="20" y="16" width="360" height="140" rx="4" fill="#2A1808" fill-opacity="0.55" stroke="url(#gold)" stroke-opacity="0.4"/>
  {shelf_row(56)}
  {shelf_row(96)}
  {shelf_row(136)}'''),
        "reading": ("#1E3048", "#101828", lambda: '''
  <rect x="80" y="168" width="240" height="14" rx="3" fill="#5C3820"/>
  <line x1="120" y1="168" x2="120" y2="134" stroke="url(#gold)" stroke-width="2"/>
  <circle cx="120" cy="128" r="10" fill="#FFE566" fill-opacity="0.65"/>
  <rect x="48" y="148" width="48" height="32" rx="6" fill="#4A5568" fill-opacity="0.65"/>'''),
        "children": ("#1A3A5C", "#0E2238", lambda: '''
  <rect x="48" y="120" width="120" height="80" rx="6" fill="#90CDF4" fill-opacity="0.25" stroke="url(#gold)" stroke-opacity="0.3"/>
  <circle cx="100" cy="168" r="20" fill="#FFE566" fill-opacity="0.5"/>
  <rect x="200" y="140" width="80" height="60" rx="4" fill="#E85D04" fill-opacity="0.25"/>
  <circle cx="280" cy="100" r="16" fill="#4ECDC4" fill-opacity="0.35"/>'''),
        "service_desk": ("#1A2838", "#0E1420", lambda: '''
  <rect x="120" y="100" width="160" height="48" rx="3" fill="#4B2A8C" fill-opacity="0.45"/>
  <rect x="48" y="100" width="56" height="10" rx="2" fill="#4A3020"/>
  <rect x="296" y="100" width="56" height="10" rx="2" fill="#4A3020"/>
  <rect x="296" y="72" width="56" height="32" rx="2" fill="#2A3848"/>'''),
    },
    "airport": {
        "gate": ("#1A2030", "#0A1018", lambda: '''
  <rect x="48" y="148" width="72" height="28" rx="6" fill="#4A5060" fill-opacity="0.7"/>
  <rect x="280" y="148" width="72" height="28" rx="6" fill="#4A5060" fill-opacity="0.7"/>
  <rect x="160" y="48" width="80" height="48" rx="2" fill="#1D3557" fill-opacity="0.6" stroke="url(#gold)" stroke-opacity="0.35"/>
  <text x="200" y="78" fill="#FFE566" font-family="Outfit,sans-serif" font-size="14" font-weight="700" text-anchor="middle">GATE</text>'''),
        "duty_free": ("#2A2030", "#141018", lambda: '''
  <rect x="24" y="24" width="352" height="16" fill="#5A5048"/>
  <rect x="24" y="40" width="80" height="32" rx="2" fill="#ECE4D4" fill-opacity="0.5"/>
  <rect x="112" y="40" width="80" height="32" rx="2" fill="#FFC83D" fill-opacity="0.35"/>
  <rect x="200" y="88" width="80" height="36" rx="3" fill="#E63946" fill-opacity="0.75"/>
  <text x="240" y="112" fill="#FFE566" font-family="Outfit,sans-serif" font-size="16" font-weight="900" text-anchor="middle">TAX FREE</text>'''),
        "food_court": ("#2A1818", "#140E0E", lambda: '''
  <rect x="32" y="120" width="80" height="48" rx="3" fill="#E85D04" fill-opacity="0.35"/>
  <rect x="128" y="120" width="80" height="48" rx="3" fill="#FF8A00" fill-opacity="0.35"/>
  <rect x="224" y="120" width="80" height="48" rx="3" fill="#4ECDC4" fill-opacity="0.25"/>
  <rect x="80" y="188" width="240" height="12" rx="3" fill="#8A8070"/>'''),
        "arrivals": ("#1A2838", "#0E1828", lambda: '''
  <ellipse cx="200" cy="180" rx="100" ry="24" fill="#3A4858" fill-opacity="0.55"/>
  <rect x="120" y="100" width="160" height="32" rx="2" fill="#A8DADC" fill-opacity="0.35"/>
  <rect x="48" y="200" width="48" height="32" rx="3" fill="#5A5048"/>
  <rect x="304" y="204" width="48" height="28" rx="3" fill="#4A4840"/>'''),
    },
    "community": {
        "main_hall": ("#1E3830", "#0E2018", lambda: '''
  <rect x="48" y="80" width="304" height="48" rx="3" fill="#588157" fill-opacity="0.35"/>
  <rect x="80" y="148" width="48" height="32" rx="4" fill="#5C3820" fill-opacity="0.7"/>
  <rect x="160" y="148" width="48" height="32" rx="4" fill="#5C3820" fill-opacity="0.7"/>
  <rect x="240" y="148" width="48" height="32" rx="4" fill="#5C3820" fill-opacity="0.7"/>
  <rect x="160" y="40" width="80" height="24" rx="2" fill="#2A2820"/>'''),
        "community_kitchen": ("#1E4A3A", "#0E2218", lambda: '''
  <rect x="16" y="112" width="240" height="20" rx="3" fill="#D4C8B8"/>
  <rect x="280" y="40" width="88" height="120" rx="3" fill="#F0E8D8"/>
  <rect x="48" y="168" width="160" height="12" rx="3" fill="#5C3820"/>
  <ellipse cx="120" cy="96" rx="24" ry="16" fill="#E8E0D4" fill-opacity="0.6"/>'''),
        "craft_room": ("#1A4038", "#0E2218", lambda: '''
  <rect x="48" y="120" width="120" height="64" rx="4" fill="#A3B18A" fill-opacity="0.35"/>
  <rect x="200" y="100" width="80" height="80" rx="4" fill="#E8D8C0" fill-opacity="0.35"/>
  <circle cx="100" cy="168" r="16" fill="#E85D04" fill-opacity="0.45"/>
  <rect x="240" y="140" width="48" height="8" rx="1" fill="#4ECDC4" fill-opacity="0.5"/>'''),
        "community_garden": ("#1A4D32", "#0E2818", lambda: '''
  <rect x="288" y="180" width="80" height="24" rx="3" fill="#6A4030" fill-opacity="0.6"/>
  <ellipse cx="308" cy="168" rx="16" ry="14" fill="#81C784" fill-opacity="0.75"/>
  <ellipse cx="340" cy="164" rx="18" ry="16" fill="#66BB6A" fill-opacity="0.8"/>
  <rect x="48" y="100" width="12" height="48" fill="#5C4030"/>
  <ellipse cx="54" cy="88" rx="28" ry="32" fill="#2E7D52" fill-opacity="0.75"/>'''),
    },
    "retail": {
        "storefront": ("#2A2030", "#141018", lambda: '''
  <rect x="24" y="168" width="64" height="80" rx="2" fill="#8ECAE6" fill-opacity="0.15" stroke="url(#gold)" stroke-opacity="0.3"/>
  <rect x="32" y="180" width="24" height="32" rx="1" fill="#FF8A00" fill-opacity="0.4"/>
  <rect x="120" y="48" width="160" height="120" rx="3" fill="#2A2838" stroke="url(#gold)" stroke-opacity="0.25"/>'''),
        "aisle": ("#2A2030", "#141018", lambda: '''
  <rect x="24" y="24" width="352" height="16" fill="#5A5048"/>
  <rect x="24" y="40" width="80" height="32" rx="2" fill="#ECE4D4" fill-opacity="0.5"/>
  <rect x="112" y="40" width="80" height="32" rx="2" fill="#D8D0C0" fill-opacity="0.5"/>
  <rect x="200" y="88" width="80" height="32" rx="2" fill="#FFC83D" fill-opacity="0.35"/>
  <rect x="288" y="88" width="80" height="32" rx="2" fill="#ECE4D4" fill-opacity="0.5"/>'''),
        "fitting": ("#2A2838", "#141820", lambda: '''
  <rect x="160" y="48" width="80" height="120" rx="2" fill="#C8D0D8" fill-opacity="0.25" stroke="url(#gold)" stroke-opacity="0.3"/>
  <rect x="48" y="120" width="80" height="10" rx="2" fill="#8A8070"/>
  <circle cx="200" cy="108" r="28" fill="#E8E0D4" fill-opacity="0.15" stroke="#A89880" stroke-opacity="0.4"/>'''),
        "checkout": ("#2A2030", "#141018", lambda: '''
  <rect x="240" y="196" width="120" height="14" rx="2" fill="#D4C8B8"/>
  <rect x="248" y="210" width="104" height="36" rx="2" fill="#C8B8A0" fill-opacity="0.5"/>
  <path d="M80 200 L100 200 L112 240 L160 240" stroke="#8A8078" stroke-width="2" fill="none"/>
  <circle cx="120" cy="248" r="8" fill="#3A3428"/>'''),
    },
    "campus": {
        "quad": ("#1A4D32", "#0E2818", lambda: '''
  <rect x="0" y="140" width="400" height="140" fill="#3A8A58" fill-opacity="0.45"/>
  <rect x="48" y="100" width="12" height="48" fill="#5C4030"/>
  <ellipse cx="54" cy="88" rx="28" ry="32" fill="#2E7D52" fill-opacity="0.75"/>
  <rect x="320" y="88" width="10" height="56" fill="#5C4030"/>
  <ellipse cx="325" cy="72" rx="24" ry="28" fill="#388E5C" fill-opacity="0.7"/>
  <rect x="160" y="168" width="80" height="12" rx="3" fill="#5C3820"/>'''),
        "student_union": ("#2A1048", "#100820", lambda: '''
  <rect x="32" y="120" width="80" height="48" rx="3" fill="#5A189A" fill-opacity="0.35"/>
  <rect x="128" y="120" width="80" height="48" rx="3" fill="#FF8A00" fill-opacity="0.35"/>
  <rect x="224" y="120" width="80" height="48" rx="3" fill="#4ECDC4" fill-opacity="0.25"/>
  <rect x="80" y="188" width="240" height="12" rx="3" fill="#8A8070"/>'''),
        "campus_library": ("#1E2848", "#101828", lambda: f'''
  <rect x="20" y="16" width="360" height="120" rx="4" fill="#2A1808" fill-opacity="0.55" stroke="url(#gold)" stroke-opacity="0.4"/>
  {shelf_row(56)}
  {shelf_row(96)}
  <rect x="168" y="148" width="64" height="20" rx="3" fill="#C77DFF" fill-opacity="0.35" stroke="url(#gold)" stroke-opacity="0.35"/>'''),
        "lab": ("#1A3848", "#0E2030", lambda: '''
  <rect x="48" y="100" width="56" height="10" rx="2" fill="#8A8070"/>
  <rect x="120" y="100" width="56" height="10" rx="2" fill="#8A8070"/>
  <rect x="192" y="100" width="56" height="10" rx="2" fill="#8A8070"/>
  <rect x="264" y="48" width="88" height="56" rx="3" fill="#4ECDC4" fill-opacity="0.2" stroke="url(#gold)" stroke-opacity="0.3"/>
  <circle cx="100" cy="72" r="16" fill="#4ECDC4" fill-opacity="0.35"/>'''),
    },
    "seniorLiving": {
        "lounge": ("#1E4A38", "#0E2218", lambda: '''
  <rect x="28" y="148" width="180" height="48" rx="12" fill="#C87838"/>
  <rect x="28" y="134" width="180" height="22" rx="10" fill="#D4883E"/>
  <rect x="276" y="72" width="72" height="20" rx="2" fill="#1A1008" fill-opacity="0.8"/>
  <ellipse cx="168" cy="214" rx="100" ry="30" fill="#1A4A38" fill-opacity="0.55"/>'''),
        "dining_hall": ("#2A2030", "#141018", lambda: '''
  <rect x="32" y="120" width="336" height="16" rx="4" fill="#F5F0E8"/>
  <rect x="48" y="148" width="40" height="36" rx="4" fill="#7B6B8A" fill-opacity="0.55"/>
  <rect x="120" y="148" width="40" height="36" rx="4" fill="#7B6B8A" fill-opacity="0.55"/>
  <rect x="192" y="148" width="40" height="36" rx="4" fill="#7B6B8A" fill-opacity="0.55"/>
  <rect x="264" y="148" width="40" height="36" rx="4" fill="#7B6B8A" fill-opacity="0.55"/>'''),
        "sunrise_garden": ("#1A4D32", "#0E2818", lambda: '''
  <rect x="160" y="180" width="120" height="20" rx="3" fill="#6A4030" fill-opacity="0.6"/>
  <ellipse cx="180" cy="168" rx="14" ry="16" fill="#FFE566" fill-opacity="0.45"/>
  <ellipse cx="220" cy="164" rx="16" ry="18" fill="#81C784" fill-opacity="0.75"/>
  <ellipse cx="260" cy="170" rx="12" ry="14" fill="#F0C878" fill-opacity="0.5"/>'''),
        "activity_room": ("#1A3048", "#0E1828", lambda: '''
  <rect x="80" y="148" width="240" height="14" rx="3" fill="#5C3820"/>
  <rect x="120" y="100" width="48" height="48" rx="4" fill="#5B9BD5" fill-opacity="0.35"/>
  <circle cx="280" cy="120" r="20" fill="#E8C547" fill-opacity="0.4"/>
  <rect x="48" y="180" width="32" height="24" rx="3" fill="#E85D04" fill-opacity="0.35"/>'''),
    },
}


def write_scene(venue_id: str, scene_id: str, bg_top: str, bg_bot: str, body_fn) -> None:
    path = OUT / venue_id / f"{scene_id}.svg"
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(svg_open(bg_top, bg_bot) + body_fn() + svg_close(), encoding="utf-8")


def main() -> None:
    count = 0
    for venue_id, scenes in VENUES.items():
        for scene_id, (bg_top, bg_bot, body_fn) in scenes.items():
            write_scene(venue_id, scene_id, bg_top, bg_bot, body_fn)
            count += 1
    print(f"Generated {count} venue scene SVGs in {OUT}")


if __name__ == "__main__":
    main()
