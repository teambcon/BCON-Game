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
        color: "orange"

        AnimatedImage {
            id: skeeBallIcon
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 100
            anchors.horizontalCenter: parent.horizontalCenter
            source: "qrc:/images/skee-ball.gif"
            width: 400
            height: 400

            MouseArea {
                id: skeeBallClickable
                anchors.fill: parent
                onClicked: playGameOverlay.state = "rollResults"
            }
        }

        MenuButton {
            id: exitButton
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 40
            buttonWidth: 300
            buttonHeight: 75
            buttonText: qsTr( "Close" )

            onClicked: playGameOverlay.visible = false;
        }

        MenuButton {
            id: nextRollButton
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 100
            buttonWidth: 300
            buttonHeight: 75
            buttonText: qsTr( "Click for next roll\n" + numberOfRolls + " rolls remaining." )

            onClicked: numberOfRolls == 0? playGameOverlay.state = "gameOver" : playGameOverlay.state = "activePlay";
        }

        Text {
            id: playGameText
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: -225
            font.pixelSize: 28
            font.bold: true
            anchors.bottomMargin: 100
            color: "blue"
            text: qsTr( "Click the image to make your roll." )
        }

        Text {
            id: rollResultText
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: 46
            font.bold: true
            color: "blue"
            text: qsTr( "You rolled " + currentRoll + "." )
        }

        Text {
            id: gameOverText
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: 32
            font.bold: true
            color: "black"
            text: qsTr( "Game over. You scored a total of " + score + " and gained " + score / 10 + " tickets." )
        }

    }

    onStateChanged: {
        if(playGameOverlay.state === "rollResults") {
            currentRoll = Math.floor( Math.random() * 10 ) * 10;
            score += currentRoll;
            numberOfRolls -= 1;
            if(numberOfRolls == 0) {
                console.log("id ", DataManager.playerId);
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
                target: playGameText
                visible: true
            }

            PropertyChanges {
                target: nextRollButton
                visible: false
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
                target: exitButton
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
                target: playGameText
                visible: false
            }

            PropertyChanges {
                target: nextRollButton
                visible: true
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
                target: exitButton
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
                target: nextRollButton
                visible: false
            }

            PropertyChanges {
                target: rollResultText
                visible: false
            }

            PropertyChanges {
                target: gameOverText
                visible: true
            }

            PropertyChanges {
                target: exitButton
                visible: true
            }
        }

    ]
}

