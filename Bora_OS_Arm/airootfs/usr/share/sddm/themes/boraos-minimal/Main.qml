import QtQuick 2.15
import QtQuick.Controls 2.15
import SddmComponents 2.0

Rectangle {
    id: root
    width: 1920
    height: 1080
    color: "#1a1b26"

    // Background gradient
    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#1a1b26" }
            GradientStop { position: 1.0; color: "#16161e" }
        }
    }

    // Center login panel
    Rectangle {
        id: loginPanel
        width: 400
        height: 300
        anchors.centerIn: parent
        color: "#24283b"
        radius: 12
        opacity: 0.95

        Column {
            anchors.centerIn: parent
            spacing: 20
            width: parent.width - 60

            // Welcome text
            Text {
                text: "Welcome to BoraOS"
                font.family: "Sans Serif"
                font.pixelSize: 24
                font.weight: Font.Light
                color: "#c0caf5"
                anchors.horizontalCenter: parent.horizontalCenter
            }

            // Username field
            TextField {
                id: usernameField
                width: parent.width
                placeholderText: "Username"
                font.pixelSize: 14
                color: "#c0caf5"
                background: Rectangle {
                    color: "#1a1b26"
                    radius: 6
                    border.color: usernameField.activeFocus ? "#7aa2f7" : "#414868"
                    border.width: 2
                }
                padding: 12
                text: userModel.lastUser
                
                KeyNavigation.backtab: passwordField
                KeyNavigation.tab: passwordField
                
                Keys.onPressed: {
                    if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                        passwordField.forceActiveFocus()
                    }
                }
            }

            // Password field
            TextField {
                id: passwordField
                width: parent.width
                placeholderText: "Password"
                echoMode: TextInput.Password
                font.pixelSize: 14
                color: "#c0caf5"
                background: Rectangle {
                    color: "#1a1b26"
                    radius: 6
                    border.color: passwordField.activeFocus ? "#7aa2f7" : "#414868"
                    border.width: 2
                }
                padding: 12
                
                KeyNavigation.backtab: usernameField
                KeyNavigation.tab: usernameField
                
                Keys.onPressed: {
                    if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                        loginButton.clicked()
                    }
                }
                
                onTextChanged: {
                    if (loginFailed) {
                        loginFailed = false
                    }
                }
            }

            // Login button
            Button {
                id: loginButton
                width: parent.width
                height: 44
                text: "Login"
                
                background: Rectangle {
                    color: loginButton.down ? "#5a7bc7" : (loginButton.hovered ? "#8cb2ff" : "#7aa2f7")
                    radius: 6
                }
                
                contentItem: Text {
                    text: loginButton.text
                    font.pixelSize: 16
                    color: "#1a1b26"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                
                onClicked: sddm.login(usernameField.text, passwordField.text, sessionSelect.currentIndex)
            }

            // Error message
            Text {
                id: errorMessage
                width: parent.width
                text: ""
                font.pixelSize: 12
                color: "#f7768e"
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WordWrap
                visible: loginFailed
            }
        }
    }

    // Bottom bar
    Rectangle {
        id: bottomBar
        width: parent.width
        height: 50
        anchors.bottom: parent.bottom
        color: "#16161e"
        opacity: 0.8

        Row {
            anchors.centerIn: parent
            spacing: 40

            // Session selector
            ComboBox {
                id: sessionSelect
                model: sessionModel
                currentIndex: sessionModel.lastIndex
                textRole: "name"
                width: 180
                
                background: Rectangle {
                    color: "#24283b"
                    radius: 6
                    border.color: "#414868"
                    border.width: 1
                }
                
                contentItem: Text {
                    text: sessionSelect.displayText
                    font.pixelSize: 13
                    color: "#c0caf5"
                    verticalAlignment: Text.AlignVCenter
                    leftPadding: 12
                }
            }

            // Power buttons
            Row {
                spacing: 12

                Button {
                    width: 40
                    height: 40
                    text: "⏻"
                    font.pixelSize: 18
                    
                    background: Rectangle {
                        color: parent.down ? "#3d4559" : (parent.hovered ? "#32344a" : "#24283b")
                        radius: 6
                    }
                    
                    contentItem: Text {
                        text: parent.text
                        font.pixelSize: parent.font.pixelSize
                        color: "#c0caf5"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    
                    onClicked: sddm.powerOff()
                }

                Button {
                    width: 40
                    height: 40
                    text: "⟲"
                    font.pixelSize: 18
                    
                    background: Rectangle {
                        color: parent.down ? "#3d4559" : (parent.hovered ? "#32344a" : "#24283b")
                        radius: 6
                    }
                    
                    contentItem: Text {
                        text: parent.text
                        font.pixelSize: parent.font.pixelSize
                        color: "#c0caf5"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    
                    onClicked: sddm.reboot()
                }
            }
        }
    }

    // Clock
    Text {
        id: clock
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.margins: 30
        font.pixelSize: 32
        font.weight: Font.Light
        color: "#c0caf5"
        
        Timer {
            interval: 1000
            running: true
            repeat: true
            onTriggered: {
                clock.text = Qt.formatDateTime(new Date(), "hh:mm")
            }
        }
        
        Component.onCompleted: {
            clock.text = Qt.formatDateTime(new Date(), "hh:mm")
        }
    }

    // Connections for login feedback
    property bool loginFailed: false
    
    Connections {
        target: sddm
        
        function onLoginFailed() {
            loginFailed = true
            errorMessage.text = "Login failed. Please try again."
            passwordField.text = ""
            passwordField.forceActiveFocus()
        }
        
        function onLoginSucceeded() {
            loginFailed = false
        }
    }
    
    Component.onCompleted: {
        if (usernameField.text === "") {
            usernameField.forceActiveFocus()
        } else {
            passwordField.forceActiveFocus()
        }
    }
}
