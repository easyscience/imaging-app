// SPDX-FileCopyrightText: 2024 EasyApp contributors
// SPDX-License-Identifier: BSD-3-Clause
// © 2024 Contributors to the EasyApp project <https://github.com/easyscience/EasyApp>

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import EasyApp.Gui.Style as EaStyle
import EasyApp.Gui.Animations as EaAnimations
import EasyApp.Gui.Elements as EaElements

import Gui.Globals as Globals

import Qt.labs.platform as Platform


Rectangle {

    color: EaStyle.Colors.mainContentBackground
    Behavior on color { EaAnimations.ThemeChange {} }

    RowLayout{
        id: mainLayout
        anchors.fill: parent
        spacing: 0

        Image {
            id: imageviewer
            fillMode: Image.PreserveAspectFit
            asynchronous: true
        }

        ToolButton {
            text: qsTr("Open")
            icon.name: "document-open"
            onClicked: fileOpenDialog.open()
        }

        Platform.FileDialog {
            id: fileOpenDialog
            title: "Select an image"
            folder: StandardPaths.writeableLocation(StandardPaths.DocumentsLocation)
            onAccepted: {
                imageviewer.source = fileOpenDialog.fileUrl
            }
        }
    }

}
