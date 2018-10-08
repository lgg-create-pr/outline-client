#!/bin/bash -eux
#
# Copyright 2018 The Outline Authors
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Compile the Electron-specific code.
tsc -p src/electron

# Build the web app (renderer process).
yarn do src/www/build
rsync -ac www/ build/electron/renderer

# # Copy binaries into the Electron folder.
# # The destination folder must be kept in sync with:
# #  - the value specified for --config.asarUnpack in package_action.sh
# #  - the value returned by process_manager.ts#pathToEmbeddedExe
# readonly BIN_DEST=$OUTPUT/electron/bin/win32
# mkdir -p $BIN_DEST
# rsync -ac \
#   third_party/shadowsocks-libev/windows/ third_party/badvpn/windows/ \
#   $BIN_DEST

# # Copy files for OutlineService.
# cp src/electron/install_windows_service.bat $OUTPUT
# rsync -ac \
#   --include '*.exe' --include '*.dll' \
#   --exclude='*' \
#   third_party/newtonsoft/ tools/OutlineService/OutlineService/bin/ \
#   $OUTPUT

# Version info and Sentry config.
# In Electron, the path is relative to electron_index.html.
scripts/environment_json.sh -p windows > build/electron/renderer/environment.json

# # Generate CSS rules to mirror the UI in RTL languages.
# node -e "require('./scripts/generate_rtl_css.js')('www/ui_components/*.html', '$OUTPUT/www/ui_components')"

# # Icons.
# electron-icon-maker --input=src/electron/logo.png --output=build/windows