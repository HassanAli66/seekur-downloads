# Third-party notices

Seekur includes or downloads the following. Thank you to their authors.

## AI models
| Component | Use | Licence |
|---|---|---|
| YOLOX-s (Megvii) — `yolox_s.onnx` | People, bags and items | Apache-2.0 — https://github.com/Megvii-BaseDetection/YOLOX |
| YOLOX person detector + RTMPose (OpenMMLab), via rtmlib | People and body points | Apache-2.0 — https://github.com/open-mmlab/mmpose, https://github.com/Tau-J/rtmlib |
| Seekur concealment model (`concealment_model.json`) | Possible-concealment scoring | Trained by Seekur on the dataset below |

## Training data
**Shoplifting Dataset (2022) — CV Laboratory MNNIT Allahabad.** Mohd. Aquib Ansari, Dushyant Kumar Singh.
Mendeley Data, V1, doi:10.17632/r3yjf35hzr.1. Licensed under CC BY 4.0
(https://creativecommons.org/licenses/by/4.0/). The videos are not redistributed; the concealment model was
trained on features derived from them.

## Software
Python, FastAPI, Uvicorn, SQLAlchemy, Pydantic, httpx, cryptography, psutil, NumPy, OpenCV (Apache-2.0),
ONNX Runtime (MIT), rtmlib (Apache-2.0), React (MIT), Vite (MIT), lucide (ISC), WinSW (MIT),
Inno Setup (Inno Setup licence), python-build-standalone (Python licence and bundled licences).
Each is distributed under its own licence; see the respective projects.
