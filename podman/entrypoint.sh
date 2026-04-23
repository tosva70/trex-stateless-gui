#!/bin/bash
# Runs inside the container. Passes DISPLAY through from the host.
exec java \
  -p /app/javafx \
  --add-modules javafx.controls,javafx.fxml,javafx.graphics,javafx.base,javafx.swing \
  --add-opens  javafx.graphics/com.sun.javafx.scene=ALL-UNNAMED \
  --add-opens  javafx.controls/javafx.scene.control=ALL-UNNAMED \
  --add-opens  javafx.controls/com.sun.javafx.scene.control.skin=ALL-UNNAMED \
  --add-exports javafx.base/com.sun.javafx.event=ALL-UNNAMED \
  --add-exports javafx.controls/com.sun.javafx.scene.control.skin=ALL-UNNAMED \
  -cp "/app/trex-stateless-gui.jar:/app/lib/*" \
  com.exalttech.trex.application.TrexApp
