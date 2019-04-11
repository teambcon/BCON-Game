import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

import com.bcon.datamanager 1.0

Item {
    id: playGameOverlay
    state: "activePlay"
    property int score: 0
    property int numberOfRolls: 3
    property int currentRoll: 0

    onVisibleChanged: {
        if ( !visible )
        {
            playGameOverlay.state = "activePlay"
            score = 0;
            numberOfRolls = 3;
            currentRoll = 0;
        }
    }

    MouseArea {
        id: mouseCatcher
        anchors.fill: parent
        visible: parent.visible
    }

    Rectangle {
        id: background
        anchors.fill: parent
        color: "pink"

        AnimatedImage {
            id: skeeBallIcon
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 100
            anchors.horizontalCenter: parent.horizontalCenter
            source: "qrc:/images/skee-ball.gif"
            width: 500
            height: 430

            MouseArea {
                id: skeeBallClickable
                anchors.fill: parent
                onClicked: if(true) {
                               stateChangedTimer.start();
                               playGameOverlay.state = "rollResults"
                           }
            }
        }

        MenuButton2 {
            id: playGameText
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottomMargin: 50
            buttonText: qsTr( "Hey " + DataManager.screenName + "!  Click the image to roll." )
        }

        Text {
            id: rollResultText
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: 46
            font.bold: true
            color: "white"
            text: qsTr( "You rolled " + currentRoll + ".\n\n\nRolls left: " + numberOfRolls + "" )
            Timer {
                id: stateChangedTimer
                interval: 1800
                running: true
                repeat: false

                onTriggered:numberOfRolls == 0? playGameOverlay.state = "gameOver" : playGameOverlay.state = "activePlay";
            }
        }

        Text {
            id: gameOverText
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: 285
            font.pixelSize: 36
            font.bold: true
            color: "black"
            text: qsTr( "You scored a total of " + score + " points\n and gained " + score / 10 + " tickets." )
        }

        Image {
            id: gameOverImage
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 125
            anchors.horizontalCenter: parent.horizontalCenter
            source: "qrc:/images/gameOver.jpg"
            width: 1250
            height: 600


            MouseArea {
                id: exitButton
                anchors.fill: parent
                onClicked: playGameOverlay.visible = false;
            }
        }

        Rectangle {
            id: skeeRect
            height: 700
            width: 125
            anchors.right: skeeBallIcon.left
            anchors.rightMargin: 115
            color: "yellow"
            border.color: "black"
            border.width: 6
            Text {
                id: skeeRectText
                anchors.topMargin: -200
                anchors.leftMargin: 100
                anchors.horizontalCenter: parent.horizontalCenter
                font.bold: true
                font.pixelSize: 135
                horizontalAlignment: Text.AlignHCenter
                text: qsTr( "S\nK\nE\nE")
            }
        }

        Rectangle {
            id: ballRect
            height: 700
            width: 125
            anchors.left: skeeBallIcon.right
            anchors.leftMargin: 115
            color: "yellow"
            border.color: "black"
            border.width: 6
            Text {
                id: skeeBallText
                anchors.topMargin: -200
                anchors.leftMargin: 100
                anchors.horizontalCenter: parent.horizontalCenter
                font.bold: true
                font.pixelSize: 135
                horizontalAlignment: Text.AlignHCenter
                text: qsTr( "B\nA\nL\nL")
            }
        }

    }

    onStateChanged: {
        if(playGameOverlay.state === "rollResults") {
            currentRoll = Math.floor( Math.random() * 10 ) * 10;
            score += currentRoll;
            numberOfRolls -= 1;
            if(numberOfRolls == 0) {
                DataManager.publishStats( score / 10, score );
                DataManager.deductTokens()
            }
        }
    }

    states: [
        State {
            name: "activePlay"

            PropertyChanges {
                target: skeeBallIcon
                visible: true
            }

            PropertyChanges {
                target: skeeRect
                visible: true
            }

            PropertyChanges {
                target: ballRect
                visible: true
            }

            PropertyChanges {
                target: skeeRectText
                visible: true
            }

            PropertyChanges {
                target: playGameText
                visible: true
            }

            PropertyChanges {
                target: rollResultText
                visible: false
            }

            PropertyChanges {
                target: gameOverText
                visible: false
            }

            PropertyChanges {
                target: gameOverImage
                visible: false
            }

        },


        State {
            name: "rollResults"

            PropertyChanges {
                target: skeeBallIcon
                visible: false
            }

            PropertyChanges {
                target: skeeRect
                visible: false
            }

            PropertyChanges {
                target: ballRect
                visible: false
            }

            PropertyChanges {
                target: playGameText
                visible: false
            }

            PropertyChanges {
                target: rollResultText
                visible: true
            }

            PropertyChanges {
                target: gameOverText
                visible: false
            }

            PropertyChanges {
                target: gameOverImage
                visible: false
            }

        },

        State {
            name: "gameOver"

            PropertyChanges {
                target: skeeBallIcon
                visible: false
            }


            PropertyChanges {
                target: playGameText
                visible: false
            }

            PropertyChanges {
                target: rollResultText
                visible: false
            }

            PropertyChanges {
                target: gameOverImage
                visible: true
            }

            PropertyChanges {
                target: gameOverText
                visible: true
            }

        }

    ]
}

