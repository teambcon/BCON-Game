import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

import com.bcon.datamanager 1.0

Item {
    id: playGameOverlay
    state: "activePlay"
    property int score: 0
    property int numberOfRolls: 6
    property int currentRoll: 0

    onVisibleChanged: {
        if ( !visible )
        {
            playGameOverlay.state = "activePlay"
            score = 0;
            numberOfRolls = 6;
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
        color: "#eee8aa"

        MenuButton {
            id: rollBall
            anchors.centerIn: parent
            buttonHeight: 300
            buttonWidth: 75
            buttonText: qsTr( "Roll" )

            onClicked: playGameOverlay.state = "rollResults";
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
            anchors.bottomMargin: 40
            buttonWidth: 300
            buttonHeight: 75
            buttonText: qsTr( "Click for Next Roll\n" + numberOfRolls + " rolls remaining." )

            onClicked: numberOfRolls == 0? playGameOverlay.state = "gameOver" : playGameOverlay.state = "activePlay";
        }

        Text {
            id: rollResultText
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: 28
            font.bold: true
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignHCenter
            color: "green"
            text: qsTr( "You rolled " + currentRoll + "." )
        }

        Text {
            id: gameOverText
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: 28
            font.bold: true
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignHCenter
            color: "green"
            text: qsTr( "Game over. You scored a total of " + score + " and gained " + score / 10 + " tickets." )
        }

    }

    onStateChanged: {
        if(playGameOverlay.state === "rollResults") {
            currentRoll = Math.floor( Math.random() * 10 ) * 10;
            score += currentRoll;
            numberOfRolls -= 1;
            if(numberOfRolls == 0) {
                DataManager.publishStats( score, score );
                DataManager.deductTokens()
            }
        }
    }

    states: [
        State {
            name: "activePlay"

            PropertyChanges {
                target: rollBall
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
                target: rollBall
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
                target: rollBall
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

