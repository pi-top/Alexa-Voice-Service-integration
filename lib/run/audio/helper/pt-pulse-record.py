#!/usr/bin/python3

import signal
import sys
import ptpulse.microphone as mic
import time


def exit():
    if mic.is_recording():
        mic.stop()
        mic.save("/tmp/pt-avs/req.wav", True)
    sys.exit(0)


def on_signal_received(signal, frame):
    exit()

signal.signal(signal.SIGTERM, on_signal_received)

mic.set_bit_rate_to_signed_16()
mic.set_sample_rate_to_16khz()
mic.record()

signal.pause()
