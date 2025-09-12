// SPDX-FileCopyrightText: 2024 EasyApp contributors
// SPDX-License-Identifier: BSD-3-Clause
// © 2024 Contributors to the EasyApp project <https://github.com/easyscience/EasyApp>

import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs
import QtCore

import EasyApp.Gui.Style as EaStyle
import EasyApp.Gui.Globals as EaGlobals
import EasyApp.Gui.Elements as EaElements
import EasyApp.Gui.Components as EaComponents
import EasyApp.Gui.Logic as EaLogic

import Gui.Globals as Globals

import QtGraphs

Column {
    spacing: EaStyle.Sizes.fontPixelSize / 4

    Row {
        spacing: 0

        EaComponents.TableViewLabel {
            width: EaStyle.Sizes.sideBarContentWidth
            text: qsTr("Min")
            horizontalAlignment: Text.AlignLeft
            color: EaStyle.Colors.themeForegroundMinor
        }
        EaComponents.TableViewLabel {
            width: EaStyle.Sizes.sideBarContentWidth
            verticalAlignment: Text.AlignBottom
            text: qsTr("Current")
            color: EaStyle.Colors.themeForegroundMinor
        }
        EaComponents.TableViewLabel {
            width: EaStyle.Sizes.sideBarContentWidth
            text: qsTr("Max")
            horizontalAlignment: Text.AlignRight
            color: EaStyle.Colors.themeForegroundMinor
        }
    }

    Row {
        spacing: 0
        
        EaComponents.TableViewLabel {
            width: EaStyle.Sizes.sideBarContentWidth / 2 - EaStyle.Sizes.sideBarContentWidth / 20
            text: qsTr("0")
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignBottom
        }
        EaElements.Parameter {
            width: EaStyle.Sizes.sideBarContentWidth / 10
            text: Globals.BackendWrapper.timeFrame.toFixed(0)
            onEditingFinished: {
                Globals.BackendWrapper.timeFrame = text
                Globals.References.pages.measurement.sidebar.basic.groups.timeFrameSlider.slider.value = parseFloat(text)
                text: Globals.BackendWrapper.timeFrame.toFixed(0)
            }
        }
        EaComponents.TableViewLabel {
            width: EaStyle.Sizes.sideBarContentWidth / 2 - EaStyle.Sizes.sideBarContentWidth / 20
            text: qsTr((Globals.BackendWrapper.timeBins - 1).toString())
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignBottom
        }
    }

    Slider {
        visible: Globals.BackendWrapper.measurementExists
        id: timeslider
        width: parent.width
        from: 0
        to: Globals.BackendWrapper.timeBins - 1
        stepSize: 1
        snapMode: Slider.SnapAlways
        value: 0
        onValueChanged: {
            Globals.BackendWrapper.timeFrame = value
        }
        Component.onCompleted: {
            Globals.References.pages.measurement.sidebar.basic.groups.timeFrameSlider.slider = timeslider
        }
    }
}
