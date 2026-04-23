#!/bin/bash
DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$DIR"

if [ ! -f target/trex-stateless-gui.jar ]; then
    echo "Building..."
    rm -rf target/lib
    mvn package -DskipTests -q
    mvn dependency:copy-dependencies -DincludeScope=runtime -DoutputDirectory=target/lib -q
fi

JAVAFX_PATH=$(ls target/lib/javafx-*.jar | tr '\n' ':')
OTHER_CP=$(ls target/lib/*.jar | grep -v '/javafx-' | tr '\n' ':')

exec java \
  --module-path "${JAVAFX_PATH%:}" \
  --add-modules javafx.controls,javafx.fxml,javafx.graphics,javafx.base,javafx.swing \
  --add-opens javafx.controls/javafx.scene.control=ALL-UNNAMED \
  --add-opens javafx.graphics/com.sun.javafx.scene=ALL-UNNAMED \
  --add-opens javafx.controls/com.sun.javafx.scene.control.skin=ALL-UNNAMED \
  --add-exports javafx.base/com.sun.javafx.event=ALL-UNNAMED \
  -cp "target/trex-stateless-gui.jar:${OTHER_CP%:}" \
  com.exalttech.trex.application.TrexApp "$@"
