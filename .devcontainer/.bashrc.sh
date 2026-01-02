# Copyright 2025 The Kubernetes Authors All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

alias k=kubectl
alias kgp='kubectl get pods -A'
alias kl='kubectl logs'
alias m="minikube"
alias ml="minikube profile list"
alias mld="minikube delete --all"
alias mk="/workspaces/minikube/out/minikube"

if [ -t 1 ]; then
  cat <<'EOF'
╔══════════════════════════════════════════════════════════════════════╗
║  Welcome to minikube in browser offered by Codespaces               ║
╚══════════════════════════════════════════════════════════════════════╝

To start minikube simply type:

    minikube start

Useful aliases:
  m          - minikube
  k          - kubectl
EOF
fi

# Update VS Code remote settings to toggle between terminal and IDE layouts.
vscode_layout() {
  local mode="$1"
  local settings_file=""
  local candidate=""
  local py_bin="python3"

  if ! command -v python3 >/dev/null 2>&1; then
    py_bin="python"
  fi
  if ! command -v "$py_bin" >/dev/null 2>&1; then
    echo "python3 is required to update VS Code settings." >&2
    return 1
  fi

  for candidate in \
    "$HOME/.vscode-remote/data/Machine/settings.json" \
    "$HOME/.vscode-server/data/Machine/settings.json" \
    "$HOME/.vscode-server-insiders/data/Machine/settings.json"; do
    if [ -f "$candidate" ]; then
      settings_file="$candidate"
      break
    fi
  done

  if [ -z "$settings_file" ]; then
    settings_file="$HOME/.vscode-remote/data/Machine/settings.json"
  fi

  mkdir -p "$(dirname "$settings_file")"

  "$py_bin" - "$mode" "$settings_file" <<'PY'
import json
import os
import sys

mode = sys.argv[1]
path = sys.argv[2]

settings = {}
if os.path.exists(path):
    with open(path, "r", encoding="utf-8") as f:
        content = f.read()
    if content.strip():
        try:
            settings = json.loads(content)
        except Exception as exc:
            sys.stderr.write("Failed to parse VS Code settings: %s\n" % exc)
            sys.exit(1)

if not isinstance(settings, dict):
    sys.stderr.write("VS Code settings must be a JSON object.\n")
    sys.exit(1)

terminal_settings = {
    "workbench.startupEditor": "terminal",
    "terminal.integrated.defaultLocation": "editor",
    "terminal.integrated.tabs.enabled": False,
    "workbench.editor.showTabs": "none",
    "workbench.editor.empty.hint": "hidden",
    "workbench.activityBar.location": "hidden",
    "workbench.secondarySideBar.defaultVisibility": "hidden",
    "workbench.statusBar.visible": False,
}

ide_settings = {
    "workbench.startupEditor": "welcomePage",
    "terminal.integrated.defaultLocation": "view",
    "terminal.integrated.tabs.enabled": True,
    "workbench.editor.showTabs": "multiple",
    "workbench.editor.empty.hint": "text",
    "workbench.activityBar.location": "default",
    "workbench.secondarySideBar.defaultVisibility": "visibleInWorkspace",
    "workbench.statusBar.visible": True,
}

if mode == "terminal":
    settings.update(terminal_settings)
elif mode == "ide":
    settings.update(ide_settings)
else:
    sys.stderr.write("Unknown layout: %s\n" % mode)
    sys.exit(1)

with open(path, "w", encoding="utf-8") as f:
    json.dump(settings, f, indent=2, sort_keys=True)
    f.write("\n")
PY

  echo "VS Code settings updated in $settings_file. Reload the window if needed."
}

alias ideview='vscode_layout ide'
alias termview='vscode_layout terminal'
source <(kubectl completion bash)
complete -o default -F __start_kubectl k
source <(minikube completion bash)
