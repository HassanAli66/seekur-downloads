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

## FFmpeg (Windows installer only)

The Windows installer includes `ffmpeg.exe` and `ffprobe.exe` from the LGPL builds published at
https://github.com/BtbN/FFmpeg-Builds (FFmpeg is licensed under the GNU LGPL v2.1 or later; source:
https://ffmpeg.org/download.html). They are run as separate programs to save camera video. The licence text is
installed next to them (`ffmpeg\LICENSE.txt`).

## Desktop app (apps/desktop)

| Component | Licence | Source |
|---|---|---|
| .NET runtime | MIT | https://github.com/dotnet/runtime |
| Avalonia UI | MIT | https://github.com/AvaloniaUI/Avalonia |
| CommunityToolkit.Mvvm | MIT | https://github.com/CommunityToolkit/dotnet |
| Lucide icons (converted to geometry in `Theme/Icons.axaml`) | ISC | https://lucide.dev |
| Manrope, Instrument Serif, JetBrains Mono fonts | SIL Open Font License 1.1 | https://fonts.google.com |
| Sample camera frames (`Assets/Sample`) | CC BY 4.0, Shoplifting Dataset (2022), MNNIT Allahabad | https://doi.org/10.17632/r3yjf35hzr.1 |

## Website (apps/site)

| Component | Licence / terms | Source |
|---|---|---|
| Windows logo (`assets/windows.svg`) | Trademark of Microsoft, shown only to mark the Windows download | https://commons.wikimedia.org/wiki/File:Windows_logo_-_2021.svg |
| Tux (`assets/tux.svg`) | Free to use with credit: Larry Ewing (lewing@isc.tamu.edu), made with The GIMP | https://commons.wikimedia.org/wiki/File:Tux.svg |
| Lucide icons (inline) | ISC | https://lucide.dev |
| Instrument Serif, Manrope, JetBrains Mono (Google Fonts) | SIL Open Font License 1.1 | https://fonts.google.com |
