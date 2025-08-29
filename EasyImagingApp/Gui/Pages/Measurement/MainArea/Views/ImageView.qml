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
    id: imageView
    anchors.fill: parent
    // fillMode: Image.Stretch
    fillMode: Image.PreserveAspectFit
    cache: false
    smooth: false
    retainWhileLoading: true
    asynchronous: true
    source: Globals.BackendWrapper.imageSource
    Component.onCompleted: {
        Globals.References.pages.measurement.mainContent.views.imageView = imageView
    }

    property int pressX
    property int pressY
    property int releaseX
    property int releaseY

    property var roiList: []

    MouseArea {
        id: roiRectArea
        anchors.horizontalCenter: imageView.horizontalCenter
        anchors.verticalCenter: imageView.verticalCenter
        width: imageView.paintedWidth
        height: imageView.paintedHeight
        acceptedButtons: Qt.LeftButton
        // hoverEnabled: true
        cursorShape: Qt.CrossCursor

        onPressed: {
            roiRect.visible = true;
            imageView.pressX = mouseX
            imageView.pressY = mouseY
            imageView.releaseX = mouseX
            imageView.releaseY = mouseY
            console.debug("Mouse pressed at: ", pressX, pressY)
        }
        onPositionChanged: {
            if (mouseX < 0) {
                imageView.releaseX = 0
            } else if (mouseX > roiRectArea.width) {
                imageView.releaseX = roiRectArea.width
            } else {
                imageView.releaseX = mouseX
            }

            if (mouseY < 0) {
                imageView.releaseY = 0
            } else if (mouseY > roiRectArea.height) {
                imageView.releaseY = roiRectArea.height
            } else {
                imageView.releaseY = mouseY
            }
        }
        onReleased: {
            Globals.BackendWrapper.createROI(
                imageView.pressX/imageView.paintedWidth,
                imageView.pressY/imageView.paintedHeight,
                imageView.releaseX/imageView.paintedWidth,
                imageView.releaseY/imageView.paintedHeight
            )
            console.debug("Mouse released at: ", releaseX, releaseY)
            roiRect.visible = false;
            const newRect = Qt.createQmlObject(
                `import QtQuick 2.15;
                 Rectangle { 
                    color: 'transparent'
                    border.color: "red"
                    border.width: 2 
                    x: ${Math.min(imageView.pressX, imageView.releaseX)}
                    y: ${Math.min(imageView.pressY, imageView.releaseY)}
                    width: ${Math.abs(imageView.releaseX - imageView.pressX)}
                    height: ${Math.abs(imageView.releaseY - imageView.pressY)}
                 }`,
                roiRectArea
            );
            Globals.Variables.measurementRoiRectList[Globals.BackendWrapper.activeMeasurementIndex].push(newRect);
            console.debug("ROI Rect List after adding new rect:", Globals.Variables.measurementRoiRectList);
        }

        Rectangle {
            id: roiRect
            color: "transparent"
            border.color: EaStyle.Colors.blue
            border.width: 2

            x: Math.min(imageView.pressX, imageView.releaseX)
            y: Math.min(imageView.pressY, imageView.releaseY)
            width: Math.abs(imageView.releaseX - imageView.pressX)
            height: Math.abs(imageView.releaseY - imageView.pressY)

            Behavior on color { EaAnimations.ThemeChange {} }
        }
    }
}

