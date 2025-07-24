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


Image {
    id: measurementViewer
    anchors.fill: parent
    // fillMode: Image.Stretch
    fillMode: Image.PreserveAspectFit
    cache: false
    smooth: false
    retainWhileLoading: true
    asynchronous: true
    source: Globals.BackendWrapper.imageSource
    Component.onCompleted: {
        Globals.References.pages.measurement.mainContent.views.measurementViewer = measurementViewer
    }

    property int pressX
    property int pressY
    property int releaseX
    property int releaseY

    MouseArea {
        id: roiRectArea
        anchors.horizontalCenter: measurementViewer.horizontalCenter
        anchors.verticalCenter: measurementViewer.verticalCenter
        width: measurementViewer.paintedWidth
        height: measurementViewer.paintedHeight
        acceptedButtons: Qt.LeftButton
        // hoverEnabled: true
        cursorShape: Qt.CrossCursor

        onPressed: {
            measurementViewer.pressX = mouseX
            measurementViewer.pressY = mouseY
            measurementViewer.releaseX = mouseX
            measurementViewer.releaseY = mouseY
            console.debug("Mouse pressed at: ", pressX, pressY)
        }
        onReleased: {
            // measurementViewer.releaseX = mouseX
            // measurementViewer.releaseY = mouseY
            console.debug("Mouse released at: ", releaseX, releaseY)
        }
        onPositionChanged: {
            if (mouseX < 0) {
                measurementViewer.releaseX = 0
            } else if (mouseX > roiRectArea.width) {
                measurementViewer.releaseX = roiRectArea.width
            } else {
                measurementViewer.releaseX = mouseX
            }

            if (mouseY < 0) {
                measurementViewer.releaseY = 0
            } else if (mouseY > roiRectArea.height) {
                measurementViewer.releaseY = roiRectArea.height
            } else {
                measurementViewer.releaseY = mouseY
            }

        }

        Rectangle {
            id: roiRect
            color: "transparent"
            border.color: EaStyle.Colors.blue
            border.width: 2

            x: Math.min(measurementViewer.pressX, measurementViewer.releaseX)
            y: Math.min(measurementViewer.pressY, measurementViewer.releaseY)
            width: Math.abs(measurementViewer.releaseX - measurementViewer.pressX)
            height: Math.abs(measurementViewer.releaseY - measurementViewer.pressY)

            Behavior on color { EaAnimations.ThemeChange {} }
        }
    }
}

