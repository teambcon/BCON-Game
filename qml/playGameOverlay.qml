import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

import com.bcon.datamanager 1.0

Item {
    id: playGameOverlay

    MouseArea {
        id: mouseCatcher
        anchors.fill: parent
        visible: parent.visible
    }

    Rectangle {
        id: background
        anchors.fill: parent
        color: "#eee8aa"

        ListView {
            id: playGame
            anchors.top: parent.top
            anchors.topMargin: 40
            anchors.left: parent.left
            anchors.leftMargin: 40
            anchors.right: parent.right
            anchors.rightMargin: 40
           // model: // playGame model
          //  height: 400

            delegate: Text {
                font.pixelSize: 24
                text: modelData[ 0 ] + modelData[ 1 ] +  modelData[ 2 ] +  modelData[ 3 ]
                color: "white"

                // TODO
            }
        }

    }
}
