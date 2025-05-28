// SPDX-FileCopyrightText: 2025 EasyApp contributors
// SPDX-License-Identifier: BSD-3-Clause
// © 2024 Contributors to the EasyApp project <https://github.com/easyscience/EasyApp>

import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs

import EasyApp.Gui.Globals as EaGlobals
import EasyApp.Gui.Components as EaComponents

import Gui.Globals as Globals


FileDialog{

    id: loadMeasurementFileDialog

    fileMode: FileDialog.OpenFile
    nameFilters: [ 'TIFF files (*.tiff)']

    onAccepted: {
        Globals.References.applicationWindow.appBarCentralTabs.summaryButton.enabled = true
        Globals.BackendWrapper.measurementLoad(selectedFile)
    }

    Component.onCompleted: {
        Globals.References.pages.measurement.sidebar.basic.popups.openMeasurementFileDialog = loadMeasurementFileDialog
    }

}
