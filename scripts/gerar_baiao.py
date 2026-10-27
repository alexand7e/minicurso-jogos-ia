"""Gera a música do tema B-R-O Bró (spec 001): um baião original, sintetizado do zero.

Sanfona (melodia e baixos), zabumba e triângulo, 16 compassos em 2/4 que emendam em loop.
Feito para este projeto e liberado como CC0. Só usa a biblioteca padrão do Python.

Uso, na raiz do projeto:
    python scripts/gerar_baiao.py
Gera art/teresina/baiao_do_bro_bro.wav. Rode scripts/check.sh depois, para a Godot importar.
"""

import math
import random
import struct
import wave
from pathlib import Path

RATE = 22050          # amostras por segundo
BPM = 120             # batidas (semínimas) por minuto
BEAT = 60 / BPM       # segundos por batida
BARS = 16             # compassos de 2 batidas
OUT = Path(__file__).resolve().parent.parent / "art" / "teresina" / "baiao_do_bro_bro.wav"

# Notas MIDI usadas (sol mixolídio, a escala típica do baião, mais o fá sustenido do ré com sétima).
G3, B3, D4, F4, G4, A4, B4, C5, D5, E5, F5, FS5, G5, A5 = 55, 59, 62, 65, 67, 69, 71, 72, 74, 76, 77, 78, 79, 81
C4, E4, A3, FS4, FS3, C3, D3, G2, A2, F3, F2 = 60, 64, 57, 66, 54, 48, 50, 43, 45, 53, 41
REST = None

# Melodia: (nota, duração em semicolcheias). Cada compasso soma 8.
MELODY = [
    [(D5, 2), (B4, 1), (D5, 1), (G5, 2), (F5, 2)],            # 1  G
    [(E5, 2), (D5, 2), (B4, 4)],                               # 2  G
    [(C5, 1), (E5, 1), (G5, 2), (E5, 2), (C5, 2)],             # 3  C
    [(D5, 2), (C5, 1), (B4, 1), (A4, 4)],                      # 4  C
    [(A4, 2), (D5, 2), (FS5, 2), (E5, 2)],                     # 5  D7
    [(D5, 2), (C5, 2), (A4, 4)],                               # 6  D7
    [(B4, 1), (D5, 1), (G5, 2), (F5, 1), (E5, 1), (D5, 2)],    # 7  G
    [(G4, 4), (REST, 4)],                                      # 8  G
    [(G5, 2), (F5, 1), (G5, 1), (A5, 2), (G5, 2)],             # 9  G
    [(F5, 2), (E5, 1), (F5, 1), (D5, 4)],                      # 10 F
    [(E5, 1), (F5, 1), (G5, 2), (E5, 2), (C5, 2)],             # 11 C
    [(D5, 2), (E5, 2), (C5, 4)],                               # 12 C
    [(D5, 1), (E5, 1), (FS5, 2), (A5, 2), (FS5, 2)],           # 13 D7
    [(E5, 2), (C5, 2), (A4, 2), (FS4, 2)],                     # 14 D7
    [(G4, 1), (B4, 1), (D5, 2), (F5, 1), (E5, 1), (D5, 1), (B4, 1)],  # 15 G
    [(G4, 4), (REST, 2), (D5, 2)],                             # 16 G (a última nota puxa a volta)
]

# Acorde de cada compasso: (baixo, quinta, notas do acorde).
G7 = (G2, D3, [G3, B3, D4, F4])
C = (C3, G2, [G3, C4, E4])
D7 = (D3, A2, [FS3, A3, C4])
F = (F2, C3, [F3, A3, C4])
CHORDS = [G7, G7, C, C, D7, D7, G7, G7, G7, F, C, C, D7, D7, G7, G7]


def freq(note):
    return 440.0 * 2 ** ((note - 69) / 12)


def accordion(note, seconds, volume):
    """Sanfona: algumas harmônicas e duas vozes levemente desafinadas (o 'tremido' da sanfona)."""
    n = int(seconds * RATE)
    f = freq(note)
    out = []
    for i in range(n):
        t = i / RATE
        envelope = min(1.0, t / 0.015) * min(1.0, (seconds - t) / 0.04)
        s = 0.0
        for detune in (0.997, 1.003):
            phase = 2 * math.pi * f * detune * t
            s += math.sin(phase) + 0.5 * math.sin(2 * phase) + 0.3 * math.sin(3 * phase) + 0.15 * math.sin(4 * phase)
        out.append(volume * envelope * s / 4)
    return out


def zabumba(volume, deep=True):
    """Zabumba: batida grave com o tom caindo rápido. Sem 'deep' é o bacalhau (vareta, agudo e seco)."""
    if deep:
        n = int(0.35 * RATE)
        return [volume * math.exp(-i / RATE * 9) * math.sin(2 * math.pi * (55 + 60 * math.exp(-i / RATE * 30)) * i / RATE)
                for i in range(n)]
    n = int(0.05 * RATE)
    return [volume * math.exp(-i / RATE * 80) * (random.random() * 2 - 1) for i in range(n)]


def triangle(volume, open_):
    """Triângulo: metal agudo; aberto soa mais, fechado (mão abafando) é curto."""
    decay = 6 if open_ else 45
    n = int((0.4 if open_ else 0.08) * RATE)
    return [volume * math.exp(-i / RATE * decay) *
            (math.sin(2 * math.pi * 3520 * i / RATE) + 0.6 * math.sin(2 * math.pi * 5280 * i / RATE)) / 1.6
            for i in range(n)]


def main():
    random.seed(7)  # o bacalhau usa ruído; semente fixa deixa o arquivo sempre igual
    total = int(BARS * 2 * BEAT * RATE)
    mix = [0.0] * total

    def add(samples, start_seconds):
        # O que passa do fim volta para o começo, para o loop emendar sem estalo.
        start = int(start_seconds * RATE)
        for i, s in enumerate(samples):
            mix[(start + i) % total] += s

    sixteenth = BEAT / 4
    for bar in range(BARS):
        bar_start = bar * 2 * BEAT
        # Melodia
        t = bar_start
        for note, length in MELODY[bar]:
            if note is not REST:
                add(accordion(note, length * sixteenth * 0.95, 0.30), t)
            t += length * sixteenth
        # Baixo no ritmo do baião: tônica, tônica na "e-a" do 1, quinta no 2.
        bass, fifth, chord = CHORDS[bar]
        add(accordion(bass, 3 * sixteenth, 0.30), bar_start)
        add(accordion(bass, sixteenth, 0.22), bar_start + 3 * sixteenth)
        add(accordion(fifth, 3 * sixteenth, 0.26), bar_start + BEAT)
        # Acorde curto nos contratempos
        for offbeat in (2, 6):
            for note in chord:
                add(accordion(note, sixteenth * 0.8, 0.07), bar_start + offbeat * sixteenth)
        # Zabumba: grave no 1, na "e-a" do 1 e no 2; bacalhau nos contratempos.
        add(zabumba(0.55), bar_start)
        add(zabumba(0.35), bar_start + 3 * sixteenth)
        add(zabumba(0.50), bar_start + BEAT)
        for offbeat in (2, 6):
            add(zabumba(0.12, deep=False), bar_start + offbeat * sixteenth)
        # Triângulo em todas as semicolcheias, aberto nos contratempos.
        for k in range(8):
            add(triangle(0.06, open_=k in (2, 6)), bar_start + k * sixteenth)

    peak = max(abs(s) for s in mix)
    OUT.parent.mkdir(parents=True, exist_ok=True)
    with wave.open(str(OUT), "wb") as w:
        w.setnchannels(1)
        w.setsampwidth(2)
        w.setframerate(RATE)
        w.writeframes(b"".join(struct.pack("<h", int(s / peak * 0.9 * 32767)) for s in mix))
    print(f"Gerado {OUT} ({total / RATE:.1f} s)")


if __name__ == "__main__":
    main()
