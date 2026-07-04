"""환경 로딩 — lib_huni.load_env verbatim 승계.

[HARD] 비밀값은 os.environ 에만 주입하고 절대 출력하지 않는다.
"""
import os


def load_env(path=None):
    """.env.local 을 os.environ 에 주입(이미 있으면 보존).

    경로 자동계산: hdx/foundation/ → repo root(.env.local).
    hdx/foundation → hdx → _foundation → _workspace → <repo root>.
    """
    if path is None:
        here = os.path.dirname(os.path.abspath(__file__))
        # hdx/foundation(=here) → hdx → _foundation → _workspace → repo root
        path = os.path.abspath(os.path.join(here, "..", "..", "..", "..", ".env.local"))
    if not os.path.exists(path):
        return
    with open(path, encoding="utf-8") as f:
        for line in f:
            line = line.strip()
            if not line or line.startswith("#") or "=" not in line:
                continue
            k, v = line.split("=", 1)
            k = k.strip()
            v = v.strip().strip('"').strip("'")
            os.environ.setdefault(k, v)
