# SPDX-FileCopyrightText: 2024 EasyApp contributors
# SPDX-License-Identifier: BSD-3-Clause
# © 2024 Contributors to the EasyApp project <https://github.com/easyscience/EasyApp>

import os
import sys
from urllib.parse import urlparse

class IO:

    @staticmethod
    def format_msg(type, *args):
        types = {'main': '*', 'sub': '  -'}
        mark = types[type]
        widths = [22,21,20,10]
        widths[0] -= len(mark)
        msgs = []
        for idx, arg in enumerate(args):
            msgs.append(f'{arg:<{widths[idx]}}')
        msg = ' ▌ '.join(msgs)
        msg = f'{mark} {msg}'
        return msg

    @staticmethod
    def generalize_path(fpath: str) -> str:
        """
        Generalize the filepath to be platform-specific, so all file operations
        can be performed.
        :param URI fpath: URI to the file
        :return URI filename: platform specific URI
        """
        filename = urlparse(fpath).path
        if not sys.platform.startswith('win'):
            return filename
        if filename[0] == '/':
            filename = filename[1:].replace('/', os.path.sep)
        return filename

class DottyDict:

    @staticmethod
    def get(obj, path):
        *path, last = path.split(".")
        for bit in path:
            obj = obj.setdefault(bit, {})
        return obj[last]

    @staticmethod
    def set(obj, path, value):
        *path, last = path.split(".")
        for bit in path:
            obj = obj.setdefault(bit, {})
        obj[last] = value
