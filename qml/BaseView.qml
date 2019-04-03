import QtQuick 2.0
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12

import com.bcon.datamanager 1.0

Item {
    id: baseView
    objectName: "baseView"
    state: "idle"

    Connections {
        target: DataManager
        onCardInserted: {
            if ( ( "idle" == baseView.state ) && ( !lookupOverlay.visible ) )
            {
                lookupOverlay.visible = true
            }
        }
    }

    Rectangle {
        id: background
        anchors.fill: parent
        color: "#ff4500"

        Text {
            id: header
            anchors.top: parent.top
            anchors.topMargin: 120
            anchors.horizontalCenter: parent.horizontalCenter
            color: "white"
            font.pixelSize: 32
            font.bold: true
        }

        Text {
            id: subHeader
            anchors.top: header.bottom
            anchors.topMargin: 100
            anchors.horizontalCenter: parent.horizontalCenter
            color: "white"
            font.pixelSize: 28
        }

        AnimatedImage {
            id: rfidIcon
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 100
            anchors.horizontalCenter: parent.horizontalCenter
            source: "qrc:/images/rfid.gif"
            width: 128
            height: 128
        }

        Column {
            id: actionButtons
            anchors.top: subHeader.bottom
            anchors.topMargin: 60
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 30
            visible: false

            MenuButton {
                id: playGame
                anchors.horizontalCenter: parent.horizontalCenter
                buttonWidth: 400
                buttonHeight: 75
                buttonText: qsTr( "Play Skee-Ball!" )

                onClicked: playGameOverlay.visible = true
            }

            MenuButton {
                id: exitButton
                anchors.horizontalCenter: parent.horizontalCenter
                buttonWidth: 400
                buttonHeight: 75
                buttonText: qsTr( "Exit" )

                onClicked: baseView.state = "idle"
            }
        }
    }



    MouseArea {
        id: keyboardMask
        height: parent.height - inputPanel.height
        y: parent.y
        anchors.left: parent.left
        anchors.right: parent.right
        visible: Qt.inputMethod.visible ? true : false

        onClicked: {
            Qt.inputMethod.hide();
            baseView.forceActiveFocus();
        }
    }

    states: [

        State {
            name: "idle"

            PropertyChanges {
                target: statusBar
                visible: false
            }

            PropertyChanges {
                target: header
                text: qsTr( "Skee-Ball" )
            }

            PropertyChanges {
                target: subHeader
                anchors.topMargin: 100
                text: qsTr( "Please tap your RFID card." )
            }


            PropertyChanges {
                target: actionButtons
                visible: false
            }


            PropertyChanges {
                target: // enough tokens?
                visible: false
            }

            PropertyChanges {
                target: rfidIcon
                visible: true
            }
        },

        State {
            name: "active"

            PropertyChanges {
                target: statusBar
                visible: true
            }

            PropertyChanges {
                target: header
                text: qsTr( "Good luck, " + DataManager.firstName + "!" )
            }

            PropertyChanges {
                target: // skeeBall Slots
                visible: true
            }

            PropertyChanges {
                target: rfidIcon
                visible: false
            }
        }

    ]
}