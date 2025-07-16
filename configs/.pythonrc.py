import atexit
import os
import readline
import rlcompleter

readline.parse_and_bind("tab: complete")
histfile = os.path.expanduser("~/.pyhistory")
try:
    readline.read_history_file(histfile)
except FileNotFoundError:
    pass
atexit.register(readline.write_history_file, histfile)
del os, atexit, readline, rlcompleter, histfile