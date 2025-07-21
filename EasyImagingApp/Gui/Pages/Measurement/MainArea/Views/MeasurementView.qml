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
    fillMode: Image.PreserveAspectFit
    cache: false
    smooth: false
    asynchronous: true
    source: Globals.BackendWrapper.imageSource
    Component.onCompleted: {
        Globals.References.pages.measurement.mainContent.views.measurementViewer = measurementViewer
    }
}

